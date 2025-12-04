# iSponsorBlockTV automatically skips sponsors in YouTube videos played on smart TVs
# https://github.com/dmunozv04/iSponsorBlockTV
{ config, ... }:
{
  virtualisation.oci-containers.containers.isponsorblocktv = {
    # Using 'latest' tag as the project doesn't publish semantic version tags
    # This matches the upstream docker-compose example
    image = "ghcr.io/dmunozv04/isponsorblocktv:latest";
    autoStart = true;

    # Use host networking mode (equivalent to network_mode: host in docker-compose)
    # Required for the service to communicate with YouTube devices on the local network
    extraOptions = [ "--network=host" ];

    # Set user to 568:568 (equivalent to user: '568:568' in docker-compose)
    user = "568:568";

    # Mount the data directory (equivalent to volumes in docker-compose)
    volumes = [ "/home/admin/isponsorblocktv:/app/data" ];
  };
}
