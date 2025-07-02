{ domain, ... }:
{
  # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
  http = {
    pprof = {
      port = 6060;
      enabled = false;
    };
    address = "0.0.0.0:3000";
    session_ttl = "720h";
  };
  users = [
    {
      name = "justinhoang";
      password = "$2a$10$z.gJA167Kf36rsjwjvgofu.LA2NTz1YL7OCEdimkag6.K/gqbNL9i";
    }
  ];
  auth_attempts = 5;
  block_auth_min = 15;
  http_proxy = "";
  language = "";
  theme = "auto";
  dns = {
    bind_hosts = [ "0.0.0.0" ];
    port = 53;
    anonymize_client_ip = false;
    ratelimit = 20;
    ratelimit_subnet_len_ipv4 = 24;
    ratelimit_subnet_len_ipv6 = 56;
    ratelimit_whitelist = [ ];
    refuse_any = true;
    upstream_dns = [ "https://dns10.quad9.net/dns-query" ];
    upstream_dns_file = "";
    bootstrap_dns = [
      "9.9.9.10"
      "149.112.112.10"
      "2620:fe::10"
      "2620:fe::fe:10"
    ];
    fallback_dns = [ ];
    upstream_mode = "load_balance";
    fastest_timeout = "1s";
    allowed_clients = [ ];
    disallowed_clients = [ ];
    blocked_hosts = [
      "version.bind"
      "id.server"
      "hostname.bind"
    ];
    trusted_proxies = [
      "127.0.0.0/8"
      "::1/128"
    ];
    cache_size = 4194304;
    cache_ttl_min = 0;
    cache_ttl_max = 0;
    cache_optimistic = false;
    bogus_nxdomain = [ ];
    aaaa_disabled = false;
    enable_dnssec = false;
    edns_client_subnet = {
      custom_ip = "";
      enabled = false;
      use_custom = false;
    };
    max_goroutines = 300;
    handle_ddr = true;
    ipset = [ ];
    ipset_file = "";
    bootstrap_prefer_ipv6 = false;
    upstream_timeout = "10s";
    private_networks = [ ];
    use_private_ptr_resolvers = false;
    local_ptr_upstreams = [ ];
    use_dns64 = false;
    dns64_prefixes = [ ];
    serve_http3 = false;
    use_http3_upstreams = false;
    serve_plain_dns = true;
    hostsfile_enabled = true;
  };
  tls = {
    enabled = false;
    server_name = "";
    force_https = false;
    port_https = 443;
    port_dns_over_tls = 853;
    port_dns_over_quic = 853;
    port_dnscrypt = 0;
    dnscrypt_config_file = "";
    allow_unencrypted_doh = false;
    certificate_chain = "";
    private_key = "";
    certificate_path = "";
    private_key_path = "";
    strict_sni_check = false;
  };
  querylog = {
    dir_path = "";
    ignored = [ ];
    interval = "2160h";
    size_memory = 1000;
    enabled = true;
    file_enabled = true;
  };
  statistics = {
    dir_path = "";
    ignored = [ ];
    interval = "720h";
    enabled = true;
  };
  filters = [
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
      name = "AdGuard DNS filter";
      id = 1;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
      name = "AdAway Default Blocklist";
      id = 2;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_34.txt";
      name = "HaGeZi's Normal Blocklist";
      id = 1738618887;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
      name = "Steven Black's List";
      id = 1738618888;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt";
      name = "HaGeZi's Samsung Tracker Blocklist";
      id = 1738618889;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt";
      name = "HaGeZi's Windows/Office Tracker Blocklist";
      id = 1738618890;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt";
      name = "HaGeZi's Pro Blocklist";
      id = 1738618891;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt";
      name = "HaGeZi's Pro++ Blocklist";
      id = 1738618892;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_60.txt";
      name = "HaGeZi's Xiaomi Tracker Blocklist";
      id = 1738618893;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
      name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
      id = 1738618894;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_16.txt";
      name = "VNM: ABPVN List";
      id = 1738618895;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt";
      name = "ShadowWhisperer's Malware List";
      id = 1738618896;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
      name = "The Big List of Hacked Malware Web Sites";
      id = 1738618897;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_56.txt";
      name = "HaGeZi's The World's Most Abused TLDs";
      id = 1738618898;
    }
    {
      enabled = true;
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt";
      name = "HaGeZi's Threat Intelligence Feeds";
      id = 1738618899;
    }
  ];
  whitelist_filters = [ ];
  user_rules = [ ];
  dhcp = {
    enabled = false;
    interface_name = "";
    local_domain_name = "lan";
    dhcpv4 = {
      gateway_ip = "";
      subnet_mask = "";
      range_start = "";
      range_end = "";
      lease_duration = 86400;
      icmp_timeout_msec = 1000;
      options = [ ];
    };
    dhcpv6 = {
      range_start = "";
      lease_duration = 86400;
      ra_slaac_only = false;
      ra_allow_slaac = false;
    };
  };
  filtering = {
    blocking_ipv4 = "";
    blocking_ipv6 = "";
    blocked_services = {
      schedule = {
        time_zone = "Local";
      };
      ids = [ ];
    };
    protection_disabled_until = null;
    safe_search = {
      enabled = false;
      bing = true;
      duckduckgo = true;
      ecosia = true;
      google = true;
      pixabay = true;
      yandex = true;
      youtube = true;
    };
    blocking_mode = "default";
    parental_block_host = "family-block.dns.adguard.com";
    safebrowsing_block_host = "standard-block.dns.adguard.com";
    rewrites =
      # the lab configuration
      # - note that this configuration also points the base domain name to the
      #   lab for external access
      let
        labIP = "192.168.0.240";
      in
      [
        {
          inherit domain;
          answer = labIP;
        }
        {
          domain = "lab.${domain}";
          answer = domain;
        }
        {
          domain = "*.lab.${domain}";
          answer = domain;
        }
      ]
      # the raspberry pi configuration
      ++ (
        let
          piIP = "192.168.0.250";
        in
        [
          {
            domain = "pi.${domain}";
            answer = piIP;
          }
          {
            domain = "*.pi.${domain}";
            answer = "pi.${domain}";
          }
        ]
      );
    safe_fs_patterns = [ "/var/lib/private/AdGuardHome/userfilters/*" ];
    safebrowsing_cache_size = 1048576;
    safesearch_cache_size = 1048576;
    parental_cache_size = 1048576;
    cache_time = 30;
    filters_update_interval = 24;
    blocked_response_ttl = 10;
    filtering_enabled = true;
    parental_enabled = false;
    safebrowsing_enabled = false;
    protection_enabled = true;
  };
  clients = {
    runtime_sources = {
      whois = true;
      arp = true;
      rdns = true;
      dhcp = true;
      hosts = true;
    };
    persistent = [ ];
  };
  log = {
    enabled = true;
    file = "";
    max_backups = 0;
    max_size = 100;
    max_age = 3;
    compress = false;
    local_time = false;
    verbose = false;
  };
  os = {
    group = "";
    user = "";
    rlimit_nofile = 0;
  };
  schema_version = 29;
}
