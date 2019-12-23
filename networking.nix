{ lib, ... }: {

  networking = {
    hostName = "hestia";

    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 8080 ];
    };
  };

  # openssh daemon
  services.openssh.enable = true;

}