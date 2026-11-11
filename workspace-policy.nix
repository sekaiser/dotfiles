# Explicit workstation policy, separate from Nixi's generic mechanism.
{
  hey,
  self,
  config,
  options,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      modules.profiles = {
        workstation.enable = true;
        zsh-workstation.enable = true;
        home-workstation.enable = true;
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
        '';
        nixPath =
          lib.mapAttrsToList (name: input: "${name}=${input}")
          (lib.filterAttrs (_: input: input ? outputs) hey.inputs)
          ++ ["dotfiles=${hey.dir}"];
        settings = {
          experimental-features = ["nix-command" "flakes"];
          substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org/"];
          trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
          # Additional daemon trust is a private administrator decision.
          trusted-users = ["root"];
          allowed-users = ["root" config.user.name];
        };
        optimise.automatic = true;
      };
    }
    (lib.mkIf config.modules.editors.emacs.enable {
      modules.editors.emacs.extraConfig = lib.mkBefore ''
        (add-to-list 'custom-theme-load-path "${self.inputs.kokedera-theme}")
        (setq doom-theme 'doom-kokedera-summer)
      '';
    })
    (lib.optionalAttrs (options ? homebrew) {
      # Explicitly sandbox Darwin builds too.
      nix.settings.sandbox = true;
      # macOS caps compiled sandbox path lists at 64 KiB. A store-wide rule
      # keeps large unions buildable, at the cost of undeclared store access.
      nix.settings.extra-sandbox-paths = ["/nix/store"];
      # Workstation choices, not framework defaults. Leave undeclared software alone.
      homebrew = {
        enable = true;
        global.autoUpdate = true;
        onActivation = {
          # Review explicit Brew updates separately; leave undeclared software alone.
          autoUpdate = false;
          upgrade = false;
          cleanup = "none";
        };
      };
      fonts.packages = lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts);
    })
  ];
}
