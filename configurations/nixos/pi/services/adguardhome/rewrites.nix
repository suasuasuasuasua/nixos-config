{
  domain,
  labIP,
  piIP,
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
    "bazarr"
    "cache"
    "calibre"
    "gitea"
    "grafana"
    "home-assistant"
    "immich"
    "it-tools"
    "jellyfin"
    "lidarr"
    "linkwarden"
    "mattermost"
    "mealie"
    "navidrome"
    "paperless"
    "prowlarr"
    "qbittorrent"
    "radarr"
    "readarr"
    "searxng"
    "sonarr"
    "stirling-pdf"
    "termix"
    "vaultwarden"
    "wastebin"
  ] labIP hostName
  ++ [
    {
      domain = "${hostName}.${domain}";
      answer = labIP;
    }
    (mkServiceRewrite "dashy.${hostName}" labIP)
    (mkServiceRewrite "glances.${hostName}" labIP)
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
    (mkServiceRewrite "glances.${hostName}" piIP)
  ]
)
