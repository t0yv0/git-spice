{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    nixpkgs_darwin.url = github:NixOS/nixpkgs/nixpkgs-24.05-darwin;
  };

  outputs = { self, nixpkgs, nixpkgs_darwin }: let
    version = self.rev or "dirty";

    packages = nixpkgs: sys: let
      pkgs = import nixpkgs { system = sys; };
      gs = pkgs.buildGo123Module {
          name = "git-spice-${version}";
          version = "${version}";
          src = ./.;
          subPackages = ["."];
          doCheck = false;
          vendorHash = "sha256-faYaf53zsVMk12p3eVkrRejNLjUf27OBH3z9IstH4Ks=";
      };
    in {
      default = gs;
    };

  in {
    packages = {
      "x86_64-darwin" = packages nixpkgs_darwin "x86_64-darwin";
      "aarch64-darwin" = packages nixpkgs_darwin "aarch64-darwin";
      "x86_64-linux" = packages nixpkgs "x86_64-linux";
      "aarch64-linux" = packages nixpkgs "aarch64-linux";
    };
  };
}
