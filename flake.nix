{
  description = "kennyzar's home config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    alejandra,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    packages = import ./pkgs nixpkgs.legacyPackages.${system};

    formatter = import nixpkgs.legacyPackages.${system}.alejandra;

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      kennyzar-lt = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          ./nixos/configuration.nix
          self.nixosModules.nvidia
          # stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "kennyzar@kennyzar-lt" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          stylix.homeModules.stylix
          nixvim.homeManagerModules.nixvim
          ./home-manager/home.nix
          self.homeManagerModules."shell-nvidia"
        ];
      };
    };
  };
}
