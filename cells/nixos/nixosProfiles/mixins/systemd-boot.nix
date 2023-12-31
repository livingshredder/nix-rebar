# Add this mixin to machines that boot with EFI
{ root, inputs, cell, ... }:
{ config, lib, pkgs, ... }: {
  # Only enable during install
  #boot.loader.efi.canTouchEfiVariables = true;

  # Use systemd-boot to boot EFI machines
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = lib.mkDefault 3;
}
