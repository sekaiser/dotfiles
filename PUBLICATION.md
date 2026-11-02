# Publication checklist

- Publish only the reviewed tracked snapshot and its fresh Git history.
- Keep nested development checkouts, local environment hooks and runtime
  credentials ignored; never force-add them or upload the whole editor workspace.
- Verify that no private customization input, identity, project path,
  infrastructure identifier, trust key or actual encrypted secret file is present.
- Evaluate the recipes without any private customization checkout or input.
- Run an independent credential-pattern scan over both source and fresh history.
- Review commit author/committer email addresses as well as source contents.
  A clean file tree does not conceal personal identity in Git metadata.
- Review access policy before deploying the example account or VM image.
- Publish Nixi and switch its input to a public transport before expecting
  unauthenticated users to evaluate these recipes.
- Changing repository visibility requires separate approval.

Encrypted secrets belong in the private consumer, not these examples. Encryption
does not conceal all metadata. Private histories are preserved outside this
repository; they must never be merged or force-pushed into the public history.
