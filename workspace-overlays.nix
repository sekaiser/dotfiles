# Consumer VM-image compatibility policy, not a Nixi-wide dependency override.
{
  # The LKL image helper needs more memory for these VM images. This changes
  # only that helper; the global security dependency overrides are not selected.
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
