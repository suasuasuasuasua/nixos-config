# Rootless Podman Quick Reference

A quick reference guide for using rootless Podman on lab, pi, and legion hosts.

## Verify Setup

```bash
# Check rootless status
podman info | grep rootless

# View your UID/GID ranges
cat /etc/subuid
cat /etc/subgid

# Check kernel setting
sysctl kernel.unprivileged_userns_clone
```

## Basic Commands

```bash
# Run a container (no sudo needed!)
podman run --rm -it alpine:latest sh

# Run in background
podman run -d --name myapp -p 8080:80 nginx:alpine

# List running containers
podman ps

# List all containers
podman ps -a

# Stop a container
podman stop myapp

# Remove a container
podman rm myapp

# View logs
podman logs myapp
podman logs -f myapp  # follow
```

## Images

```bash
# Pull an image
podman pull nginx:alpine

# List images
podman images

# Build an image
podman build -t myapp:latest .

# Remove an image
podman rmi myapp:latest

# Clean up unused images
podman image prune
```

## Volumes

```bash
# Create a volume
podman volume create mydata

# List volumes
podman volume ls

# Inspect a volume
podman volume inspect mydata

# Use a volume
podman run -d -v mydata:/data alpine:latest

# Remove a volume
podman volume rm mydata

# Clean up unused volumes
podman volume prune
```

## Networking

```bash
# Create a network
podman network create mynet

# List networks
podman network ls

# Run container on network
podman run -d --network mynet --name db postgres:16-alpine

# Inspect network
podman network inspect mynet

# Remove network
podman network rm mynet
```

## Systemd Integration

```bash
# Generate systemd service for existing container
podman generate systemd --new --files --name myapp

# Move to user systemd directory
mv container-myapp.service ~/.config/systemd/user/

# Reload systemd
systemctl --user daemon-reload

# Enable service
systemctl --user enable container-myapp.service

# Start service
systemctl --user start container-myapp.service

# Check status
systemctl --user status container-myapp.service

# View logs
journalctl --user -u container-myapp.service -f

# Enable services to start on boot (without login)
sudo loginctl enable-linger $USER
```

## Compose

```bash
# Start services
podman-compose up -d

# List services
podman-compose ps

# View logs
podman-compose logs -f

# Stop services
podman-compose down

# Restart a service
podman-compose restart servicename
```

## Monitoring

```bash
# View resource usage
podman stats

# View specific container
podman stats myapp

# Interactive TUI
podman-tui
```

## Cleanup

```bash
# Remove stopped containers
podman container prune

# Remove unused images
podman image prune

# Remove unused volumes
podman volume prune

# Remove everything unused
podman system prune -a

# Free space used by containers
podman system df
```

## Common Patterns

### Run a web service

```bash
podman run -d \
  --name nginx \
  -p 8080:80 \
  -v ~/html:/usr/share/nginx/html:ro \
  nginx:alpine
```

### Run a database with persistence

```bash
podman volume create postgres-data
podman run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=secret \
  -v postgres-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16-alpine
```

### Create a systemd service

```bash
# 1. Run container first
podman run -d --name myapp -p 8080:80 myapp:latest

# 2. Generate and install service
podman generate systemd --new --files --name myapp
mv container-myapp.service ~/.config/systemd/user/

# 3. Stop original and enable service
podman stop myapp && podman rm myapp
systemctl --user daemon-reload
systemctl --user enable --now container-myapp.service
```

## Important Notes

### Port Restrictions
- ❌ Cannot bind to ports < 1024 directly
- ✅ Use ports ≥ 1024 or nginx reverse proxy

### Storage Location
- System: `/var/lib/containers`
- User: `~/.local/share/containers`

### Differences from Root Podman
- No `sudo` required
- Separate image/volume storage
- Port binding restrictions
- User-specific services

## Troubleshooting

### Container won't start
```bash
# Check logs
podman logs containername

# Check events
podman events

# Inspect container
podman inspect containername
```

### Permission issues
```bash
# Ensure directory ownership
ls -la ~/mydata
chown -R $USER:$USER ~/mydata
```

### Networking issues
```bash
# Test container networking
podman run --rm alpine:latest ping -c 3 google.com

# Recreate default network
podman network rm podman
podman network create podman
```

### Service won't start on boot
```bash
# Enable linger
sudo loginctl enable-linger $USER

# Check service status
systemctl --user status container-myapp.service

# View logs
journalctl --user -u container-myapp.service
```

## Learn More

- Concepts: `/docs/rootless-podman.md`
- Examples: `/docs/rootless-podman-examples.md`
- Summary: `/docs/ROOTLESS-PODMAN-SUMMARY.md`

## Common Use Cases

### Development server
```bash
podman run -d --name dev-server \
  -p 3000:3000 \
  -v $(pwd):/app \
  -w /app \
  node:20-alpine \
  npm run dev
```

### Temporary testing
```bash
podman run --rm -it \
  -v $(pwd):/work \
  -w /work \
  python:3.12-alpine \
  sh
```

### Background service
```bash
podman run -d --name redis \
  --restart=always \
  -p 6379:6379 \
  redis:alpine
```

Remember: All commands work without `sudo` in rootless mode! 🎉
