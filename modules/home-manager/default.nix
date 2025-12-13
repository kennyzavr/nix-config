{
  devtools = import ./devtools.nix;
  nvim = import ./nvim.nix;
  nixvim = import ./nixvim/default.nix;
  proxy = import ./proxy.nix;
  desktop-shell = import ./desktop-shell.nix;
  tty = import ./tty.nix;
  librewolf = import ./librewolf.nix;
  desktop-shell-nvidia = import ./desktop-shell-nvidia.nix;
}
