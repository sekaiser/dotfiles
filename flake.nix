{
  description = "Shareable MBP and UTM workstation configurations using Nixi";

  inputs = {
    # Public source; keep this revision pinned independently of local edits.
    # Development overrides use the nested Nixi checkout without rewriting this lock.
    nixi.url = "git+https://github.com/sekaiser/nixi.git";
    nixi.inputs.nixpkgs.follows = "nixpkgs";
    nixi.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    nixi.inputs.nixpkgs-darwin.follows = "nixpkgs-darwin";
    nixi.inputs.home-manager.follows = "home-manager";
    nixi.inputs.darwin.follows = "darwin";
    nixi.inputs.alejandra.follows = "alejandra";
    nixi.inputs.doom-emacs.follows = "doom-emacs";
    nixi.inputs.disko.follows = "disko";
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # Keep MBP Atuin on its working 18.19 package while newer Darwin tests fail.
    nixpkgs-atuin = {
      url = "https://releases.nixos.org/nixos/unstable/nixos-26.11pre1070770.8ce4ef6cb6f8/nixexprs.tar.xz";
      flake = false;
    };
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs-unstable";
    doom-emacs = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    kokedera-theme = {
      url = "github:sekaiser/doom-emacs-theme-kokedera";
      flake = false;
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs: let
    lib = inputs.nixi.lib;
    devShells = inputs.nixi.devShellDefs;
    overlays = import ./workspace-overlays.nix;
    packages =
      inputs.nixi.packageDefs;
  in
    lib.mkHostFlake {
      inherit inputs devShells overlays packages;
      checks.workspace-policy = import ./checks/workspace-policy.nix;
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

      hosts = lib.mapHosts ./hosts;
      hostModules = [./workspace-policy.nix];
      nixpkgsConfig.allowUnfree = true;
    };
}
