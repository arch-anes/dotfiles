{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      user = builtins.getEnv "USER";
      mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./nix/home/common.nix ] ++ modules;
        extraSpecialArgs = { dotfilesPath = toString ./.; inherit user; };
      };
    in {
      homeConfigurations = {
        arch   = mkHome "x86_64-linux"   [ ./nix/home/linux.nix ./nix/home/arch.nix ];
        ubuntu = mkHome "x86_64-linux"   [ ./nix/home/linux.nix ./nix/home/ubuntu.nix ];
        macos  = mkHome "aarch64-darwin" [ ./nix/home/macos.nix ];
      };
    };
}
