# RAID tier-3 sandbox image (RAID harness plan 3.6, R4).
# Chainguard busybox: a minimal, non-root (65532) image with a shell and core utilities only, pinned by digest.
# RAID runs every container with --user 1000:1000, --cap-drop=ALL, no-new-privileges, a read-only root, no network
# and the task folder as its only mount; this image adds nothing to that.
FROM cgr.dev/chainguard/busybox@sha256:1e9e2a1a441baad9344011745fd15f1985ce658b6be239ac06fd6133a0006788

LABEL org.opencontainers.image.source="https://github.com/joelpriddy/raid-sandbox-image" \
      org.opencontainers.image.description="Minimal non-root image for RAID tier-3 sandbox runs"

USER 65532:65532
