{
  devtools = import ./devtools.nix;
  nvim = import ./nvim.nix;
  nixvim = import ./nixvim/default.nix;
  proxy = import ./proxy.nix;
  shell = import ./shell.nix;
  tty = import ./tty.nix;
  librewolf = import ./librewolf.nix;
  shell-nvidia = import ./shell-nvidia.nix;
}
