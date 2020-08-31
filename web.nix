{ pkgs, lib, config, ... }: {

    services.nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;

        sslCiphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305";

        commonHttpConfig = ''
          add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

          ssl_session_timeout 1d;
          ssl_session_cache shared:MozSSL:10m;
          ssl_session_tickets off;
          ssl_prefer_server_ciphers off;

          ssl_stapling on;
          ssl_stapling_verify on;
        '';

        virtualHosts = let
        vhost = config: lib.mkMerge [
            ({
            http2 = true;
            enableACME = true;
            forceSSL = true;
            extraConfig = ''
                charset UTF-8;
            '';
            })
            config
        ];
        in {
            "atlas.oraxen.com" = vhost {
                locations."/" = {
                    extraConfig = ''
                        proxy_http_version 1.1;
                        proxy_set_header Host $host;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_redirect off;
                        proxy_buffering off;
                    '';
                    proxyPass = "http://polymath.aiohttp"; 
                };
            };
        };
        upstreams = {
            "polymath.aiohttp".servers."127.0.0.1:8080 fail_timeout=0" = {};
        };
    };

}
