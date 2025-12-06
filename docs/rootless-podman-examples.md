# Rootless Podman: Practical Examples

This guide provides practical examples for using rootless Podman on the lab, pi, and legion hosts.

## Table of Contents

- [Verifying Rootless Setup](#verifying-rootless-setup)
- [Basic Container Operations](#basic-container-operations)
- [Running Services](#running-services)
- [Managing Systemd User Services](#managing-systemd-user-services)
- [Networking Examples](#networking-examples)
- [Troubleshooting](#troubleshooting)

## Verifying Rootless Setup

After the system is built with the new configuration, verify that rootless podman is properly configured:

### Check if running in rootless mode

```bash
# Should show "rootless: true"
podman info | grep rootless

# Check your allocated subordinate UID/GID ranges
cat /etc/subuid
cat /etc/subgid

# Example output for justinhoang user:
# justinhoang:100000:65536

# Example output for admin user:
# admin:165536:65536
```

### Verify kernel settings

```bash
# Should return 1 (enabled)
sysctl kernel.unprivileged_userns_clone
```

### Check podman version and storage

```bash
# View detailed podman configuration
podman info

# You should see:
# - rootless: true
# - graphRoot: /home/<user>/.local/share/containers/storage
# - runRoot: /run/user/<uid>/containers
```

## Basic Container Operations

### Running a simple container

```bash
# Run a container without sudo
podman run --rm -it alpine:latest sh

# Inside the container:
whoami  # Shows 'root' (but it's mapped to your user on the host)
exit
```

### Running a web server

```bash
# Note: Using port 8080 instead of 80 (rootless can't bind to ports < 1024)
podman run -d --name nginx-test -p 8080:80 nginx:alpine

# Test it
curl http://localhost:8080

# Stop and remove
podman stop nginx-test
podman rm nginx-test
```

### Building custom images

```bash
# Create a simple Dockerfile
cat > /tmp/Dockerfile <<EOF
FROM alpine:latest
RUN apk add --no-cache curl
CMD ["sh"]
EOF

# Build it (no sudo needed!)
podman build -t my-alpine:latest /tmp/

# Run it
podman run --rm my-alpine:latest curl --version
```

## Running Services

### Example: Simple Redis Container

```bash
# Run Redis on a high port
podman run -d \
  --name redis \
  -p 6379:6379 \
  redis:alpine

# Check if it's running
podman ps

# Test connection
redis-cli -h localhost ping

# View logs
podman logs redis

# Stop it
podman stop redis
```

### Example: PostgreSQL Database

```bash
# Create a volume for persistence
podman volume create postgres-data

# Run PostgreSQL
podman run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydb \
  -v postgres-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16-alpine

# Connect to it
podman exec -it postgres psql -U myuser -d mydb

# Cleanup
podman stop postgres
podman rm postgres
podman volume rm postgres-data
```

## Managing Systemd User Services

One of the powerful features of rootless Podman is integration with systemd user services. This allows containers to start automatically when you log in.

### Creating a user service for a container

```bash
# Create user systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Run a container first
podman run -d --name my-nginx -p 8080:80 nginx:alpine

# Generate systemd service file
podman generate systemd --new --files --name my-nginx

# This creates: container-my-nginx.service
# Move it to the right location
mv container-my-nginx.service ~/.config/systemd/user/

# Stop and remove the original container (systemd will manage it now)
podman stop my-nginx
podman rm my-nginx

# Enable and start the service
systemctl --user daemon-reload
systemctl --user enable container-my-nginx.service
systemctl --user start container-my-nginx.service

# Check status
systemctl --user status container-my-nginx.service

# View logs
journalctl --user -u container-my-nginx.service -f
```

### Enable linger for services to start on boot

By default, user services only run when you're logged in. To have them start on boot:

```bash
# Enable linger for your user
sudo loginctl enable-linger $USER

# Verify
loginctl show-user $USER | grep Linger
# Should show: Linger=yes
```

### Example: Persistent Service with Auto-Restart

```bash
# Create a monitoring service
podman run -d \
  --name glances \
  --restart=always \
  -p 61208:61208 \
  nicolargo/glances:alpine-latest-full

# Generate systemd unit
podman generate systemd --new --files --name glances
mv container-glances.service ~/.config/systemd/user/

# Remove the original container
podman stop glances
podman rm glances

# Enable and start
systemctl --user daemon-reload
systemctl --user enable --now container-glances.service

# Access at http://localhost:61208
```

## Networking Examples

### Container-to-Container Communication

```bash
# Create a network
podman network create my-app-network

# Run a database on the network
podman run -d \
  --name db \
  --network my-app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:16-alpine

# Run an app that connects to the database
# The database is accessible at hostname 'db' within the network
podman run -d \
  --name app \
  --network my-app-network \
  -p 8080:8080 \
  -e DATABASE_URL=postgresql://postgres:secret@db:5432/postgres \
  your-app-image

# List networks
podman network ls

# Inspect a network
podman network inspect my-app-network

# Cleanup
podman stop app db
podman rm app db
podman network rm my-app-network
```

### Using Host Networking

```bash
# For services that need to bind to the host's network directly
# (e.g., AdGuard Home on pi host)
podman run -d \
  --name adguard \
  --network host \
  -v /home/admin/adguardhome:/opt/adguardhome/work \
  -v /home/admin/adguardhome/conf:/opt/adguardhome/conf \
  adguard/adguardhome:latest
```

## Advanced Examples

### Using Podman Compose

Create a `docker-compose.yml` file (yes, it works with Podman!):

```yaml
# ~/my-app/docker-compose.yml
version: '3'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

Run it with podman-compose:

```bash
# Install podman-compose if not already available
# (should be available if using this NixOS config)

cd ~/my-app
podman-compose up -d

# View running containers
podman-compose ps

# View logs
podman-compose logs -f

# Stop everything
podman-compose down
```

### Managing Volumes

```bash
# List volumes
podman volume ls

# Create a volume
podman volume create my-data

# Inspect a volume
podman volume inspect my-data

# Use a volume
podman run -d \
  --name app \
  -v my-data:/data \
  alpine:latest sleep infinity

# Access volume data from host
# Volume location: ~/.local/share/containers/storage/volumes/my-data/_data

# Backup a volume
podman run --rm \
  -v my-data:/source:ro \
  -v $(pwd):/backup \
  alpine:latest \
  tar czf /backup/my-data-backup.tar.gz -C /source .

# Restore a volume
podman run --rm \
  -v my-data:/target \
  -v $(pwd):/backup \
  alpine:latest \
  tar xzf /backup/my-data-backup.tar.gz -C /target

# Remove a volume
podman volume rm my-data
```

### Resource Limits

```bash
# Limit CPU and memory
podman run -d \
  --name limited-app \
  --cpus=2 \
  --memory=512m \
  --memory-swap=1g \
  nginx:alpine

# View resource usage
podman stats limited-app

# Update limits on running container
podman update --cpus=1 limited-app
```

## Troubleshooting

### Container can't bind to privileged port

**Problem:** You get a permission error trying to bind to port 80 or 443.

**Solution:** Use a high port (>= 1024) and set up nginx as a reverse proxy:

```bash
# Run your app on port 8080
podman run -d --name myapp -p 8080:80 myapp:latest

# System-level nginx (configured in NixOS) can proxy to it
# Add to nginx configuration:
# location / {
#   proxy_pass http://localhost:8080;
# }
```

### Permission denied on volume mount

**Problem:** Container can't access mounted directory.

**Solution:** Ensure the directory has proper permissions:

```bash
# The UIDs inside the container are mapped to your subordinate UIDs
# Check the container's UID
podman run --rm alpine:latest id

# Make directory readable by your user
chmod 755 ~/my-data
podman run -d -v ~/my-data:/data alpine:latest sleep infinity
```

### Can't pull images

**Problem:** DNS or network issues when pulling images.

**Solution:** Check your DNS settings:

```bash
# Test DNS resolution
podman run --rm alpine:latest nslookup docker.io

# If it fails, check /etc/containers/registries.conf
# Should have docker.io in search registries
```

### Container networking issues

**Problem:** Containers can't reach the internet or each other.

**Solution:** Check podman network configuration:

```bash
# List networks
podman network ls

# Inspect default network
podman network inspect podman

# Recreate default network if needed
podman network rm podman
podman network create podman

# Check firewall rules aren't blocking
sudo nft list ruleset | grep podman
```

### Systemd service won't start on boot

**Problem:** Container service doesn't start after reboot.

**Solution:** Enable linger for your user:

```bash
# Enable linger
sudo loginctl enable-linger $USER

# Verify
loginctl show-user $USER | grep Linger

# Check service status
systemctl --user status container-myapp.service

# View logs
journalctl --user -u container-myapp.service
```

## Tips and Best Practices

1. **Always use specific image tags** instead of `latest` for reproducibility
   ```bash
   # Good
   podman run nginx:1.25-alpine
   
   # Avoid
   podman run nginx:latest
   ```

2. **Use podman-tui for interactive management**
   ```bash
   podman-tui
   ```

3. **Clean up regularly**
   ```bash
   # Remove stopped containers
   podman container prune
   
   # Remove unused images
   podman image prune
   
   # Remove unused volumes
   podman volume prune
   
   # Remove everything unused
   podman system prune -a
   ```

4. **Use podman auto-update for automatic container updates**
   ```bash
   # Label containers for auto-update
   podman run -d \
     --label io.containers.autoupdate=registry \
     --name myapp \
     myapp:latest
   
   # Enable auto-update timer
   systemctl --user enable --now podman-auto-update.timer
   ```

5. **Monitor container logs**
   ```bash
   # View logs in real-time
   podman logs -f container-name
   
   # View last 100 lines
   podman logs --tail 100 container-name
   
   # Use journalctl for systemd services
   journalctl --user -u container-myapp.service -f
   ```

## Additional Resources

- [Podman Official Docs](https://docs.podman.io/)
- [Rootless Podman Tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
- [Podman Desktop](https://podman-desktop.io/) - GUI for managing containers
- [NixOS Podman Wiki](https://wiki.nixos.org/wiki/Podman)

## Conclusion

Rootless Podman provides a secure and user-friendly way to run containers without requiring root privileges. With the configuration applied to lab, pi, and legion hosts, you can now:

- Run containers as a regular user
- Integrate with systemd user services
- Maintain proper isolation and security
- Use all standard Podman/Docker workflows

For more information about rootless concepts, see `/docs/rootless-podman.md`.
