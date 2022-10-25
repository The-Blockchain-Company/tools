{ config, ... }:
{
    security.acme.email = "rmourey_jr@quantumone.network";
    security.acme.acceptTerms = true;

    services.nginx = {
        enable = config.services.nginx.virtualHosts != [];
    };
}
