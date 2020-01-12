{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./networking.nix
      ./users.nix
    ];

  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "fr";
     defaultLocale = "fr_FR.UTF-8";
  };

  # Time zone
  time.timeZone = "Europe/Zurich";

  # Packages
  environment.systemPackages = with pkgs; [
     wget git
  ];

  programs.fish.enable = true;
  systemd.services = {
      discordbot = import ./services/discordbot.nix { inherit pkgs; };
  };

  # System
  boot = {
    kernelParams = [ "net.ifnames=0" "biosdevname=0" ];
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
  };
  system.stateVersion = "19.09";

}

