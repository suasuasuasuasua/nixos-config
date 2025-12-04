# iSponsorBlockTV automatically skips sponsors in YouTube videos played on smart TVs
# https://github.com/dmunozv04/iSponsorBlockTV
#
# Manual Setup Required:
# Before the service can run properly, you need to initialize the configuration:
#
# 1. Ensure the data directory exists and has proper permissions:
#    mkdir -p /home/admin/isponsorblocktv
#    chown 568:568 /home/admin/isponsorblocktv
#
# 2. Run the initial setup to create the config.json file:
#    podman run --rm -it \
#      --network=host \
#      --user 568:568 \
#      -v /home/admin/isponsorblocktv:/app/data \
#      ghcr.io/dmunozv04/isponsorblocktv:latest \
#      --setup
#
# 3. After setup is complete, the service will start automatically on the next
#    system rebuild or reboot.
#
# Note: The service uses host networking mode to properly communicate with
#       YouTube devices on the local network.
{
  imports = [ ./compose.nix ];
}
