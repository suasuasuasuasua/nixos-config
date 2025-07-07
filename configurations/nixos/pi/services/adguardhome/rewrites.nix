{ domain, ... }:
let
  labIP = "192.168.0.240";
  piIP = "192.168.0.250";

  mkServiceRewrite = name: answer: {
    domain = "${name}.${domain}";
    inherit answer;
  };

  # NOTE: a bit manual for my taste, but it's a good thing that I don't have too
  # many services
  mkServiceRewrites =
    names: answer: builtins.foldl' (acc: cur: [ (mkServiceRewrite cur answer) ] ++ acc) [ ] names;
in
# wildcard rewrites
[
  # - note that this configuration points the base domain name to the lab for
  # external access
  {
    inherit domain;
    answer = labIP;
  }
  {
    domain = "*.${domain}";
    answer = labIP;
  }
  {
    domain = "lab.${domain}";
    answer = labIP;
  }
  {
    domain = "*.lab.${domain}";
    answer = labIP;
  }
  {
    domain = "pi.${domain}";
    answer = piIP;
  }
  {
    domain = "*.pi.${domain}";
    answer = piIP;
  }
]
# specific service rewrites
++ (mkServiceRewrites [
  "actual"
  "audiobookshelf"
  "calibre"
  "dashy"
  "firefox-syncserver"
  "gitea"
  "hydra"
  "immich"
  "jellyfin"
  "jellyseerr"
  "mealie"
  "miniflux"
  "navidrome"
  "open-webui"
  "paperless"
  "stirling-pdf"
  "vaultwarden"
  "wastebin"
] labIP)
++ (mkServiceRewrites [
  "adguardhome"
] piIP)
