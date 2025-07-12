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
(
  let
    hostName = "lab";
  in
  mkServiceRewrites [
    "actual"
    "audiobookshelf"
    "calibre"
    "firefox-syncserver"
    "gitea"
    "home-assistant"
    "hydra"
    "immich"
    "jellyfin"
    "jellyseerr"
    "mealie"
    "miniflux"
    "navidrome"
    "open-webui"
    "paperless"
    "searxng"
    "stirling-pdf"
    "vaultwarden"
    "wastebin"
  ] labIP hostName
  ++ [
    {
      inherit domain;
      answer = labIP;
    }
    {
      domain = "${hostName}.${domain}";
      answer = labIP;
    }
    (mkServiceRewrite "dashy.${hostName}" labIP)
    (mkServiceRewrite "glances.${hostName}" labIP)
    (mkServiceRewrite "vpn.${hostName}" labIP)
  ]
)
++ (
  let
    hostName = "pi";
  in
  mkServiceRewrites [
    "adguardhome"
    "uptime-kuma"
  ] piIP hostName
  ++ [
    {
      domain = "${hostName}.${domain}";
      answer = piIP;
    }
    (mkServiceRewrite "dashy.${hostName}" piIP)
    (mkServiceRewrite "glances.${hostName}" piIP)
  ]
)
