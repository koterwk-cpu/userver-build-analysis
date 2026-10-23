#!/usr/bin/env bash
# set -euo pipefail

IMG=ghcr.io/userver-framework/ubuntu-22.04-userver
DIGEST=sha256:fca9c8ac7e97b4e2b042d822facbb152aec10a9d4e09c0862e44c50640f3f303
LIMITS=(--cpus=4 --cpuset-cpus=0-3 --memory=8g --memory-swap=8g)

cd "$(dirname "$0")"
rm -rf results
mkdir -p results

docker run --rm "${LIMITS[@]}" \
  -v "$PWD/scripts":/work/scripts:ro \
  -v "$PWD/results":/work/results \
  -w /work \
  "$IMG@$DIGEST" \
  bash scripts/measure.sh