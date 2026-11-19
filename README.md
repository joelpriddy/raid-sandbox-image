# raid-sandbox-image

The container image RAID uses for tier-3 sandbox runs (rootless Podman). It is Chainguard busybox, pinned by digest:
a minimal, non-root image with a shell and core utilities only.

`.github/workflows/build.yml` builds it on every pull request and scans it with Trivy (a fixable high or critical
finding fails the build). On `main`, and weekly to pick up base-image fixes, it also pushes the image to
`ghcr.io/joelpriddy/raid-sandbox` and signs the pushed digest keyless with cosign. The signer is this repository's
workflow on `main`.

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

A weekly rebuild produces a new digest; RAID moves to it only through the steps above, at least once a month.
