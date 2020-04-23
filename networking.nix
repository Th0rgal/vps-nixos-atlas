{ lib, ... }: {

  networking = {
    hostName = "atlas";

    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 8080 443 ];
    };
  };

  # openssh daemon
  services.openssh.enable = true;

}