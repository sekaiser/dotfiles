# Explicit workstation policy, separate from Nixi's generic mechanism.
{
  hey,
  config,
  options,
  lib,
  pkgs,
  ...
}: {
  config =
    {
      modules.profiles =
        {
          workstation.enable = true;
          zsh-workstation.enable = true;
          home-workstation.enable = true;
        }
        // lib.optionalAttrs (!(options ? homebrew)) {
          # Explicit workstation account policy.
          administrator.enable = true;
          primary-user.extraGroups = ["users" "docker"];
        };
      hey.enable = lib.mkDefault true;
      user.packages = [hey.packages.tmuxsel];
      home.stateVersion = "25.05";
      home-manager.users.${config.user.name}.home.sessionVariables = {
        DOTFILES = config.home.dir + "/dotfiles";
        DOTFILES_HOME = config.home.dir + "/dotfiles";
      };
      ids.gids.nixbld = 30000;
      home-manager.backupFileExtension = lib.mkDefault "nixi-backup";
      nix = {
        channel.enable = false;
        package = pkgs.nixVersions.nix_2_31;
        extraOptions = ''
          warn-dirty = false
          http2 = true
          experimental-features = nix-command flakes
        '';
        nixPath =
          lib.mapAttrsToList (name: input: "${name}=${input}")
          (lib.filterAttrs (_: input: input ? outputs) hey.inputs)
          ++ ["dotfiles=${hey.dir}"];
        settings = {
          substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org/"];
          trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
          trusted-users = ["root" config.user.name];
          allowed-users = ["root" config.user.name];
        };
        optimise.automatic = true;
      };
    }
    // lib.optionalAttrs (options ? homebrew) {
      # Explicit private policy: do not inherit Darwin's unsandboxed default.
      nix.settings.sandbox = true;
      # Workstation choices, not framework defaults. Leave undeclared software alone.
      homebrew = {
        enable = true;
        global.autoUpdate = true;
        onActivation = {
          # Migration hold: review explicit Brew updates separately after cutover.
          autoUpdate = false;
          upgrade = false;
          cleanup = "none";
        };
      };
      fonts.packages = lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts);
    };
}
