# Rootless Podman: A Guide

## What is Rootless Podman?

Rootless Podman allows you to run containers as a regular user without requiring root privileges. This is a significant security improvement over traditional container runtimes that require root access.

## Key Concepts

### 1. **Traditional (Root) Containers vs Rootless Containers**

**Root Containers (Traditional Approach):**
- Require root privileges to run
- Container daemon runs as root
- Any security vulnerability in the container runtime could compromise the entire system
- Used by default in most Docker installations

**Rootless Containers:**
- Run as a regular, unprivileged user
- No root privileges required
- Container processes run under the user's UID
- Security vulnerabilities are isolated to the user's permissions
- Reduces attack surface significantly

### 2. **User Namespaces**

User namespaces are a Linux kernel feature that allows mapping UIDs and GIDs inside containers to different UIDs and GIDs on the host system.

**How it works:**
- A regular user (e.g., UID 1000) can run a container
- Inside the container, processes appear to run as root (UID 0)
- On the host system, those processes actually run as subordinate UIDs mapped to the user
- Example: Container UID 0 → Host UID 100000, Container UID 1 → Host UID 100001, etc.

This is configured through `/etc/subuid` and `/etc/subgid` files, which define the range of subordinate UIDs/GIDs available to each user.

### 3. **Sub-UIDs and Sub-GIDs**

**What they are:**
- Ranges of user IDs (UIDs) and group IDs (GIDs) allocated to regular users
- Allow users to have additional UIDs/GIDs for running containers
- Typically allocate 65536 IDs per user (matching the container's UID space)

**Example configuration:**
```
# /etc/subuid
justinhoang:100000:65536
admin:165536:65536

# /etc/subgid  
justinhoang:100000:65536
admin:165536:65536
```

This means:
- User `justinhoang` can use UIDs 100000-165535 for containers
- User `admin` can use UIDs 165536-231071 for containers

### 4. **Port Binding Restrictions**

**Rootless containers have port limitations:**
- Cannot bind to privileged ports (< 1024) by default
- This is a Linux security feature (only root can bind to ports < 1024)
- Workarounds:
  - Use ports >= 1024 and redirect with iptables/nftables
  - Use nginx/traefik as a reverse proxy (running as root)
  - Enable `net.ipv4.ip_unprivileged_port_start` sysctl

### 5. **Performance Considerations**

**Rootless mode implications:**
- Slightly higher overhead due to user namespace mapping
- Storage drivers: `overlay` filesystem requires kernel >= 5.11 for rootless
- Network performance is generally comparable to root mode
- For most workloads, performance difference is negligible

## Security Benefits

### 1. **Principle of Least Privilege**
Running containers without root privileges follows the security principle of least privilege - only grant the minimum permissions necessary.

### 2. **Isolation**
- Container breakout vulnerabilities are limited to user privileges
- An attacker escaping a rootless container gains only user-level access
- Cannot modify system files or access other users' data

### 3. **No Daemon as Root**
- Traditional Docker requires dockerd to run as root
- Podman is daemonless - each container is a separate process
- Rootless Podman eliminates the privileged daemon attack vector

### 4. **Multi-Tenancy**
- Safe for multi-user systems
- Each user has isolated container environment
- Users cannot interfere with each other's containers

## Implementation in NixOS

In NixOS, rootless podman is configured through several mechanisms:

### 1. **Automatic Sub-UID/Sub-GID Allocation**
```nix
users.users.justinhoang = {
  isNormalUser = true;
  # Automatically allocates subuid/subgid ranges
  subUidRanges = [{ startUid = 100000; count = 65536; }];
  subGidRanges = [{ startGid = 100000; count = 65536; }];
};
```

### 2. **Unprivileged User Namespaces**
```nix
# Enable unprivileged user namespaces (required for rootless containers)
boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
```

### 3. **Container Configuration**
```nix
virtualisation.containers.containersConf.settings = {
  engine = {
    # Run containers in rootless mode
    # This sets the default for all users
  };
};
```

## Practical Examples

### Running a Container as a Regular User

**Before (requires root):**
```bash
sudo podman run -d -p 80:80 nginx
```

**After (rootless):**
```bash
# No sudo required!
podman run -d -p 8080:80 nginx
```

### Checking Rootless Status

```bash
# Check if running in rootless mode
podman info | grep rootless

# View your subordinate UID/GID ranges
cat /etc/subuid
cat /etc/subgid

# List running containers (your user only)
podman ps
```

### Systemd User Services

Rootless containers can integrate with systemd user services:

```bash
# Generate a user systemd service
podman generate systemd --new --name mycontainer > ~/.config/systemd/user/mycontainer.service

# Enable at user login
systemctl --user enable mycontainer.service
systemctl --user start mycontainer.service
```

## Common Questions

### Q: Can rootless containers access all the same features?
A: Most features work, but some require root privileges:
- ✅ Running containers
- ✅ Building images
- ✅ Managing volumes and networks
- ✅ Compose/pod management
- ❌ Binding to privileged ports (< 1024) directly
- ❌ Some advanced networking features (may require slirp4netns)
- ❌ Modifying system-level resources

### Q: What about performance?
A: Performance is very close to root mode for most workloads. The user namespace overhead is minimal on modern kernels.

### Q: Can I mix root and rootless containers?
A: Yes! System-level containers can run alongside user containers:
- System: `/var/lib/containers`
- User: `~/.local/share/containers`

These are completely separate and don't interfere with each other.

### Q: How do I handle services that need privileged ports?
A: Use a reverse proxy (nginx, traefik, caddy) running as root to forward traffic to your rootless containers on high ports.

## Migration Notes

When migrating from root to rootless podman:

1. **Images**: Need to be re-pulled or copied (separate storage)
2. **Volumes**: Existing volumes are in `/var/lib/containers`, user volumes in `~/.local/share/containers`
3. **Networks**: Rootless uses slirp4netns or pasta for networking by default
4. **Ports**: Update port mappings to use ports >= 1024 or set up reverse proxy

## Conclusion

Rootless Podman represents a significant security improvement for container workloads. By removing the requirement for root privileges, it:
- Reduces the attack surface
- Enables safer multi-user environments  
- Maintains compatibility with OCI standards
- Provides near-identical functionality to root mode

For production systems, especially those exposed to the internet or running untrusted workloads, rootless containers should be the default choice.

## References

- [Podman Rootless Tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
- [NixOS Podman Wiki](https://wiki.nixos.org/wiki/Podman)
- [User Namespaces (man 7)](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)
- [OCI Runtime Specification](https://github.com/opencontainers/runtime-spec)
