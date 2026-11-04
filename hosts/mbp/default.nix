_: {
  system = "aarch64-darwin";
  module = {
    hey,
    lib,
    ...
  }: let
    inherit (lib) mkDefault mkForce;
  in {
    modules = {
      profiles = {
        atuin-workstation.enable = true;
        rust-workstation.enable = true;
        go-workstation.enable = true;
        java-workstation.enable = true;
        omp-workstation.enable = true;
        vim-workstation.enable = true;
        tmux-workstation.enable = true;
        alacritty-workstation.enable = true;
        doom-workstation.enable = true;
        zed-workstation.enable = true;
        user = mkDefault "developer";
        primary-user.description = mkDefault "Developer workstation";
      };

      desktop = {
        homebrew = {
          extraConfig = ''
            tap "can1357/tap", trusted: true
          '';
          casks = [
            "stablyai/orca/orca"
            "gyorgysh/keepresso/keepresso"
            "ausweisapp"
            "chatgpt"
            "codex"
            "copilot-cli"
            "teamviewer"
            "tiptoi-manager"
            "diffusionbee"
            "utm@beta"
            "discord"
            "intellij-idea-ce"
            "arc"
            "steam"
            "ollama-app"
            "inkscape"
            # "gimp"
            "element"
            "mqttx"
            "tailscale-app"
            "visual-studio-code"
            "whatsapp"
            "notion"
            "vlc"
            "zed"
          ];
          brews = [
            "yt-dlp"
            "openvpn"
            "pinentry-mac"
            "p7zip"
            "mactop"
            "wireguard-tools"
            "graphviz"
            "xan"
            "openai-whisper"
            "qemu"
            "sniffnet"
            "omp"
            "rtk"
          ];
        };
      };
      shell = {
        awscli2 = {
          enable = true;
          eks.enable = true;
        };
        alacritty.enable = true;
        atuin.enable = true;
        direnv.enable = true;
        git = {
          enable = true;
        };
        gnupg.enable = true;
        tmux = {
          enable = true;
          autoAttach = true;
        };
        zsh.enable = true;
      };
      editors = {
        default = "nvim";
        emacs = {
          enable = true;
        };
        vim.enable = true;
        zed = {
          enable = true;
        };
      };
      services = {
        docker.enable = true;
      };
      dev = {
        rust.enable = true;
        java.openjdk25.enable = true;
        go.enable = true;
      };
      agents = {
        codex = {
          enable = true;
          plugins = ["github@openai-curated" "caveman@caveman-repo"];
          mcpServers = ["codegraph" "tencent-memory"];
          skills = {
            design-taste-frontend = hey.packages.taste-skill;
            humanizer = hey.packages.humanizer;
          };
        };
        memory.enable = true;
        codegraph.enable = true;
        copilot = {
          enable = true;
          command = "/opt/homebrew/bin/copilot";
        };
        omp.enable = true;
        rtk = {
          enable = true;
          command = "/opt/homebrew/bin/rtk";
        };
      };
      theme.active = "kokedera";
    };

    hardware = {config, ...}: {
      system.stateVersion = 5;
      system.primaryUser = config.user.name;
    };

    # local config
    config = {pkgs, ...}: {
      nix.enable = true;
      nix.optimise.automatic = mkForce false;
      nix.linux-builder = {
        enable = true;
        config = {
          nix.settings = {
            keep-outputs = true;
            keep-derivations = true;
          };
          virtualisation = {
            cores = 4;
            memorySize = mkForce 8192;
            darwin-builder.diskSize = 160 * 1024;
          };
        };
      };
      environment.systemPackages = [
        pkgs.dockutil # https://github.com/kcrawford/dockutil
      ];
      modules.desktop = {
        dock = {
          enable = true;
          entries = [
            {path = "/System/Applications/Apps.app/";}
            {path = "/System/Applications/Calendar.app/";}
            {path = "/Applications/Arc.app/";}
            {path = "/Applications/Safari.app/";}
            {path = "${pkgs.alacritty}/Applications/Alacritty.app/";}
            {path = "/Applications/IntelliJ IDEA CE.app/";}
            {path = "/Applications/UTM.app/";}
            {path = "/Applications/VMware Fusion.app/";}
            {path = "/Applications/WhatsApp.app/";}
            {path = "/Applications/Zed.app/";}
            {path = "/System/Applications/Notes.app/";}
            {path = "/System/Applications/Preview.app/";}
            {path = "/System/Applications/System Settings.app/";}
          ];
        };
      };
    };
  };
}
