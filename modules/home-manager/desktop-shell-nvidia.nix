{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.niri.settings.environment = {
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "LIBVA_DRIVER_NAME" = "nvidia";
    # export WLR_NO_HARDWARE_CURSORS=1
  };

  wayland.windowManager.sway = {
    extraSessionCommands = ''
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export LIBVA_DRIVER_NAME=nvidia
      # export WLR_NO_HARDWARE_CURSORS=1
    '';
  };
}
