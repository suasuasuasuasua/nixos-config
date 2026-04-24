{
  domain,
  labIp,
  piIp,
  ...
}:
let
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
        # ex. adguardhome.sua.dev
        (mkServiceRewrite cur answer)
        # fully qualified with host name rewrite
        # ex. adguardhome.pi.sua.dev
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
    "13ft"
    "actual"
    "audiobookshelf"
    "calibre"
    "firefox-syncserver"
    "gitea"
    "grafana"
    "home-assistant"
    "hydra"
    "immich"
    "it-tools"
    "jellyfin"
    "linkwarden"
    "mealie"
    "miniflux"
    "navidrome"
    "open-webui"
    "paperless"
    "searxng"
    "stirling-pdf"
    "termix"
    "vaultwarden"
    "wastebin"
  ] labIp hostName
  ++ [
    # {
    #   inherit domain;
    #   answer = labIP;
    # }
    {
      domain = "${hostName}.${domain}";
      answer = labIp;
    }
    {
      domain = "vpn.${domain}";
      answer = labIp;
    }
    {
      domain = "vpn-sua.duckdns.org";
      answer = labIp;
    }
    (mkServiceRewrite "dashy.${hostName}" labIp)
    (mkServiceRewrite "glances.${hostName}" labIp)
  ]
)
++ (
  let
    hostName = "pi";
  in
  mkServiceRewrites [
    "adguardhome"
    "uptime-kuma"
  ] piIp hostName
  ++ [
    {
      domain = "${hostName}.${domain}";
      answer = piIp;
    }
    (mkServiceRewrite "dashy.${hostName}" piIp)
    (mkServiceRewrite "glances.${hostName}" piIp)
  ]
)
