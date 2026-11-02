_: {
  system = "aarch64-linux";
  target = "qcow-efi";
  module = {lib, ...}: {
    modules = {
      profiles = {
        vim-workstation.enable = true;
        user = lib.mkDefault "developer";
        vm-image = {
          enable = true;
          hostName = "utm";
          diskSize = 51200;
          extraPackages = [
            "jq"
            "htop"
            "tree"
          ];
        };
      };
      editors = {
        default = "nvim";
        vim.enable = true;
      };
      shell.zsh.enable = true;
      theme.active = "alucard";
    };
  };
}
