{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    shadowsocks-rust
  ];

  systemd.user.services.shadowsocks = {
    Unit = {
      Description = "Shadowsocks local client (user)";
      After = ["network.target"];
    };

    Service = {
      ExecStart = ''
        ${pkgs.shadowsocks-rust}/bin/sslocal -c %h/.shadowsocks.json
      '';
      Restart = "always";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
