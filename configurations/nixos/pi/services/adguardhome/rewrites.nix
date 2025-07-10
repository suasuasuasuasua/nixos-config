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
    names: answer: hostName:
    builtins.foldl' (
      acc: cur:
      [
        # base rewrite
        # ex. adguardhome.sua.sh
        (mkServiceRewrite cur answer)
        # fully qualified with host name rewrite
        # ex. adguardhome.pi.sua.sh
        (mkServiceRewrite "${cur}.${hostName}" answer)
      ]
      ++ acc
    ) [ ] names;
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
    domain = "lab.${domain}";
    answer = labIP;
  }
  {
    domain = "pi.${domain}";
    answer = piIP;
  }
]
# specific service rewrites
++ (mkServiceRewrites [
  "actual"
  "audiobookshelf"
  "calibre"
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
] labIP "lab")
++ (mkServiceRewrites [
  "adguardhome"
  "uptime-kuma"
] piIP "pi")
++ [
  (mkServiceRewrite "dashy.lab" labIP)
  (mkServiceRewrite "dashy.pi" piIP)
  (mkServiceRewrite "glances.lab" labIP)
  (mkServiceRewrite "glances.pi" piIP)
]
