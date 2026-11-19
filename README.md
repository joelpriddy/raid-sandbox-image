# raid-sandbox-image

The container image RAID uses for tier-3 sandbox runs (rootless Podman). It is Chainguard busybox, pinned by digest:
a minimal, non-root image with a shell and core utilities only.

`.github/workflows/build.yml` has two jobs:

- **scan** (every event, read-only rights): builds the image and scans it with Trivy. A fixable high or critical
  finding fails it.
- **publish** (`main`, the weekly run and manual runs, after scan): pushes the image to
  `ghcr.io/joelpriddy/raid-sandbox` by commit tag, scans that exact pushed digest, signs it keyless with cosign, then
  moves `:latest`. The signer is this repository's workflow on `main`.

The base image is pinned by digest. Dependabot (`.github/dependabot.yml`) proposes base-digest and action bumps as
pull requests. The weekly run rescans the image, so a newly published vulnerability shows up as a failed run.

## Pinning a digest in RAID

RAID pins the image by digest in `harness/src/raid/data/sandbox/podman-v<version>.json`. Before a new digest is
pinned:

1. verify its signature:

   ```
   cosign verify ghcr.io/joelpriddy/raid-sandbox@sha256:<digest> \
     --certificate-identity https://github.com/joelpriddy/raid-sandbox-image/.github/workflows/build.yml@refs/heads/main \
     --certificate-oidc-issuer https://token.actions.githubusercontent.com
   ```

2. review the workflow run's scan result;
3. update the pin through a RAID pull request, and run the tier-3 acceptance (`harness/scripts/sandbox_tier3_acceptance.py`).

Each merged base bump produces a new signed digest. RAID moves to it only through the steps above, and reviews its
pin at least once a month.
