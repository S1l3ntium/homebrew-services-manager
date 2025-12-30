# Homebrew Services Manager

Нативное macOS-приложение для управления сервисами, установленными через Homebrew.

Цели этого репозитория:

- Быстрый прототип CLI для взаимодействия с `brew services`.
- Шаблоны для Homebrew Cask и Formula для распространения GUI и/или CLI.
- Исходная структура для последующей реализации SwiftUI-приложения.

Структура:

- `Package.swift` — Swift Package с CLI и модулями Core/System.
- `Sources/` — `CLI`, `Core`, `System`.
- `Scripts/build.sh` — скрипт сборки CLI.
- `HomebrewFormula/` — шаблоны Cask и Formula.
- `dist/` — сборочные артефакты (CLI, dmg и т.п.).

Быстрый старт (требуется Swift 5.8+, macOS 13+):

```bash
# собрать CLI
cd /path/to/HomebrewServicesManager
bash Scripts/build.sh

# запустить
./dist/hsmanager-cli
```

Дальнейшие шаги:

- Реализовать GUI на SwiftUI + AppKit мост (Xcode проект).
- Добавить SMJobBless helper для операций, требующих root.
- Автоматизировать сборку .dmg и подпись/нотаризацию для релизов.
- Заполнить `homebrew-services-manager-cask.rb` URL и sha256 релизного .dmg.
