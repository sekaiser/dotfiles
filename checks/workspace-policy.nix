{
  hey,
  lib,
  runCommand,
  ...
}: let
  host = system: home: {
    inherit system;
    module = _: {
      config = {
        user = {
          name = "alice";
          inherit home;
        };
        system.stateVersion = if lib.hasSuffix "darwin" system then 6 else "26.05";
      };
    };
  };
  outputs = hey.lib.mkHostFlake {
    inputs = {
      self.outPath = ../.;
      nixi = hey;
    };
    packages = hey.packageDefs;
    hosts = {
      laptop = host "aarch64-darwin" "/Users/alice";
      server = host "x86_64-linux" "/home/alice";
    };
    hostModules = [../workspace-policy.nix];
  };
  darwin = outputs.darwinConfigurations.laptop;
  linux = outputs.nixosConfigurations.server;
  basePolicy = candidate: let
    nix = candidate.config.nix;
  in
    !nix.channel.enable
    && nix.package.drvPath == candidate.pkgs.nixVersions.nix_2_31.drvPath
    && lib.all (feature: builtins.elem feature nix.settings.experimental-features) ["nix-command" "flakes"]
    && builtins.elem "alice" nix.settings.allowed-users
    && builtins.elem "https://nix-community.cachix.org" nix.settings.substituters;
in
  assert basePolicy darwin && basePolicy linux;
  assert darwin.config.nix.settings.sandbox;
  assert darwin.config.nix.settings.extra-sandbox-paths == ["/nix/store"];
  assert (linux.config.nix.settings.extra-sandbox-paths or []) == [];
    runCommand "workspace-policy-check" {} ''
      touch "$out"
    ''
