#!/usr/bin/env bash

cd /work/my_service

cat >> CMakeLists.txt <<'EOF'

option(ENABLE_PCH "Precompiled headers experiment" OFF)

if(ENABLE_PCH)
  set(PCH_HEADERS
      <handlers/hello_service.usrv.pb.hpp>
      "${CMAKE_CURRENT_SOURCE_DIR}/src/hello_grpc.hpp"
      "${CMAKE_CURRENT_SOURCE_DIR}/src/hello_postgres.hpp"
      <userver/components/component.hpp>
      <fmt/format.h>
  )
  target_precompile_headers(${PROJECT_NAME}_objs PRIVATE ${PCH_HEADERS})
  target_precompile_headers(${PROJECT_NAME} PRIVATE ${PCH_HEADERS})
endif()
EOF

cmake -S /work/my_service -B /work/my_service/build-pch \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_CXX_FLAGS="-ftime-trace" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DENABLE_PCH=ON

CCACHE_DISABLE=1 /usr/bin/time -o /work/results/pch_time.txt -v \
  make -C /work/my_service/build-pch -j4 -k \
  > /work/results/pch_build.log 2>&1 || true

ClangBuildAnalyzer --all /work/my_service/build-pch /work/results/pch.cba

ClangBuildAnalyzer --analyze /work/results/pch.cba > /work/results/pch_cba.txt

find /work/my_service/build-pch -name "main.cpp*.json" -type f -exec cp {} /work/results/pch_main.json \; 2>/dev/null || true