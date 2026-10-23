# userver build time analysis

Замеры времени сборки шаблонного сервиса на [userver](https://github.com/userver-framework/userver)
с помощью [Clang Build Analyzer](https://github.com/aras-p/ClangBuildAnalyzer).
Baseline — чистый шаблон из `userver-create-service`, эксперимент — тот же
сервис с precompiled headers (PCH).

## Запуск

```bash
bash run.sh
```