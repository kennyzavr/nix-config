{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.xserver.enable = false;
}
