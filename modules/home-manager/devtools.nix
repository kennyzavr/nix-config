{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    llvmPackages_21.clang
    llvmPackages_21.clang-tools
    rustup
    #nui
    nixd
    #gcc
    gnumake
    cmake
    cmake-format
    python314
  ];

  programs.git = {
    enable = true;
    userName = "kennyzavr";
    userEmail = "me@kennyzar.me";
  };
}
