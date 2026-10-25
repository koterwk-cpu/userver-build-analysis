#!/usr/bin/env bash
set -euo pipefail


apt-get update -qq
apt-get install -y --no-install-recommends clang cmake make git time

mkdir -p /work/results
{
  echo "=== OS ==="
  cat /etc/os-release
  echo "=== CPU ==="
  lscpu
  echo "=== Memory ==="
  free -h
  echo "=== cgroup CPU limit ==="
  cat /sys/fs/cgroup/cpu.max
  echo "=== cgroup memory limit ==="
  cat /sys/fs/cgroup/memory.max
  echo "=== Compilers and build tools ==="
  clang --version
  cmake --version
  make --version
  ld --version
} > /work/results/environment.txt

git clone --depth=1 https://github.com/aras-p/ClangBuildAnalyzer.git /opt/ClangBuildAnalyzer

bash /work/scripts/run_baseline.sh
bash /work/scripts/run_test.sh