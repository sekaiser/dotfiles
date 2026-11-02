# Dotfiles with Nixi

Shareable MBP and UTM workstation recipes built with
[Nixi](https://github.com/sekaiser/nixi). Nixi provides the generic mechanism;
this repository selects software, editor, shell and desktop preferences.

`hosts/mbp` targets Apple Silicon macOS. `hosts/utm` describes an ARM64 Linux
VM image. Their default account name, `developer`, is a placeholder, not a
deployment recommendation. Adapt it in your own consumer before activation.

No personal account data, SSH CA, password hash, encrypted secret file or private
configuration input is required by these recipes. The UTM example has no supplied
login password or trusted user CA and does not enable passwordless activation.
Provision your own access policy before trying to use the image.

The public base does not grant the account administrative groups, Docker-group
membership or Nix daemon trust. Grant those explicitly in your own private
deployment if needed; daemon trust is an administrative privilege, not a
prerequisite for ordinary Nix usage.

## Evaluate and build

```sh
nix flake check --all-systems --no-build --no-write-lock-file
nix build .#darwinConfigurations.mbp.system --no-link
```

Building is not activation. Do not switch these example defaults onto an
existing machine without reviewing its identity, access policy and state
versions. Doom may require evaluation-time helper builds and pinned source
downloads. Inspect the build plan; dependency revisions are pinned, and global
security dependency overrides are not enabled.

Nixi and this repository are currently private staging. The Nixi input still
uses SSH while staging; switch that transport to public HTTPS after Nixi is
published. Publication requires a separate review and approval.

## Private customization

Keep personal identity, project paths, infrastructure identifiers and encrypted
secrets in a separate private consumer. That consumer imports these host
descriptors and `workspace-policy.nix`, then adds private modules through
`hostModules`. Dependency inputs can follow this flake's pins. The public
recipes never fetch the private consumer.

The local editor workspace may contain independent `nixi/`, `homelab/` and
`private-config/` checkouts. They are ignored, not submodules or flake inputs.
Never force-add them. An optional ignored `.envrc.local` may select a private
deployment shell; otherwise `.envrc` selects this public base.

Private deployment commands and migration records belong in the private
consumer. Public host selectors identify the example recipes, not an existing
machine's private deployment.
