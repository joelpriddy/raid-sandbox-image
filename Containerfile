# RAID tier-3 sandbox image (RAID harness plan 3.6, R4).
# Chainguard busybox: a minimal, non-root (65532) image with a shell and core utilities only, pinned by digest.
# RAID runs every container with --user 1000:1000, --cap-drop=ALL, no-new-privileges, a read-only root, no network
# and the task folder as its only mount; this image adds nothing to that.
FROM cgr.dev/chainguard/busybox@sha256:133593bec47e8af5012f17105630d8792898c0665778937b7e1eb4aea42309cb

LABEL org.opencontainers.image.source="https://github.com/joelpriddy/raid-sandbox-image" \
      org.opencontainers.image.description="Minimal non-root image for RAID tier-3 sandbox runs"

USER 65532:65532
