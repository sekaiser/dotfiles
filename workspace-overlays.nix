# Private image-build policy, deliberately outside the Nixi release.
{
  # Opt-in only: security = import ./nixi/overlays/security.nix;
  lkl-image = final: prev:
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      lkl = prev.lkl.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            substituteInPlace tools/lkl/cptofs.c \
              --replace-fail 'lkl_start_kernel("mem=100M")' 'lkl_start_kernel("mem=1024M")'
          '';
      });
    };
}
