{ config, pkgs, ... }:


with pkgs;
let
  polymath-packages = python-packages: with python-packages; [
    aiohttp
  ]; 
  python-polymath-debug = python3.withPackages polymath-packages;
in

{
  imports =
    [
      ./hardware-configuration.nix
      ./networking.nix
      ./users.nix
      ./web.nix
    ];

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
  };

  # Time zone
  time.timeZone = "Europe/Zurich";

  # Packages
  environment.systemPackages = with pkgs; [
     wget git python-polymath-debug
  ];

  programs.fish.enable = true;
  systemd.services = {
      polymath = import ./services/polymath.nix { inherit pkgs; };
  };

  # System
  boot = {
    kernelParams = [ "net.ifnames=0" "biosdevname=0" ];
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
  };
  system.stateVersion = "19.09";

}

