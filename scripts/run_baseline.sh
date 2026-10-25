#!/usr/bin/env bash

cmake -S /opt/ClangBuildAnalyzer \
-B /opt/ClangBuildAnalyzer/build \
-DCMAKE_C_COMPILER=clang \
-DCMAKE_CXX_COMPILER=clang++

cmake --build /opt/ClangBuildAnalyzer/build -j4

install -m755 /opt/ClangBuildAnalyzer/build/ClangBuildAnalyzer /usr/local/bin/ClangBuildAnalyzer

mkdir -p /work/results
cd /work

userver-create-service --grpc --mongo --postgresql my_service

cd /work/my_service

cmake -S /work/my_service -B /work/my_service/build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_CXX_FLAGS="-ftime-trace" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

CCACHE_DISABLE=1 /usr/bin/time -o /work/results/baseline_time.txt -v make -C /work/my_service/build -j4 -k > /work/results/baseline_build.log 2>&1

ClangBuildAnalyzer --all /work/my_service/build /work/results/baseline.cba

ClangBuildAnalyzer --analyze /work/results/baseline.cba > /work/results/baseline_cba.txt

find /work/my_service/build -name "main.cpp*.json" -type f -exec cp {} /work/results/main_trace_baseline.json \; 2>/dev/null || true
