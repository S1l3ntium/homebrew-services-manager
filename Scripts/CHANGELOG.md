# 📝 CHANGELOG - Liquid Glass Edition

## Version 2.0.0 - "Liquid Glass" (30 декабря 2025)

### 🎨 Major UI Overhaul

#### Liquid Glass Design System
- ✨ Внедрен **Liquid Glass** - современный материал от Apple
- 💫 `.ultraThinMaterial` для полупрозрачных элементов
- 🎭 Плавные hover и press анимации
- 🌈 Цветовая система с градиентами и эффектами

#### Menu Bar Architecture
- 🎯 **Полностью переделано на menu bar only** приложение
- 📍 Убрана иконка из Dock (`.accessory` policy)
- 🪟 Убрано главное окно (WindowGroup)
- ⚡️ Мгновенный доступ через status bar

#### SwiftUI Popover
- 🎨 **NSPopover с SwiftUI** вместо NSMenu
- 📐 360x500px popover с beautiful design
- 🔍 **Поиск в реальном времени** с фильтрацией
- 📜 Scrollable список с LazyVStack
- 💡 Состояния loading и empty

### ⚡️ Новые функции

#### Быстрые действия при hover
- 👆 Кнопки управления появляются при наведении
- ▶️ Start (зеленая) - запустить сервис
- ⏹ Stop (красная) - остановить сервис
- 🔄 Restart (синяя) - перезапустить сервис
- 🎭 Smooth transitions для кнопок

#### Улучшенный поиск
- 🔍 TextField с живой фильтрацией
- ❌ Кнопка очистки поиска
- ⚡️ Case-insensitive поиск
- 📊 Счетчик результатов

#### Event Monitor
- 👁️ Отслеживание кликов вне popover
- 🚪 Автоматическое закрытие
- ⌨️ Поддержка ESC для закрытия

### 🏗 Архитектурные изменения

#### Новые компоненты
```
+ MenuBarPopoverView.swift     - Главный UI компонент
+ ServiceRowView               - Строка сервиса с hover
+ GlassButtonStyle            - Кастомный стиль кнопок
+ EventMonitor                - Мониторинг событий
+ AppDelegate                 - Menu bar lifecycle
```

#### Обновленные файлы
```
~ MainApp.swift               - AppDelegate + Settings scene
~ MenuBarController.swift     - NSPopover вместо NSMenu
```

#### Удаленные зависимости
```
- WindowGroup                 - больше не используется
- NSMenu/NSMenuItem           - заменено на SwiftUI
- FocusableTextField          - не нужен в popover
```

### 🎨 UI/UX Improvements

#### Цветовые индикаторы
- 🟢 **Green** - сервис запущен (started)
- 🔴 **Red** - ошибка (error)
- ⚫️ **Gray** - остановлен (stopped/none)
- 🟠 **Orange** - другие состояния

#### Типографика
- 📏 SF Pro Display для текста
- 🔢 Размеры: 20/16/13/11px
- ⚖️ Weights: medium/semibold/regular

#### Spacing & Layout
- 📐 Consistent padding (8-16px)
- 🎯 4px spacing между строками
- 📦 Corner radius 6-8px
- 🖼️ Border opacity 0.2-0.4

#### Анимации
- ⏱ Duration: 0.1-0.15s для UI элементов
- 🎬 Easing: `.easeInOut`
- 🔄 Scale: 0.95x on press, 1.05x on hover
- 👻 Opacity transitions для появления

### 📚 Документация

#### Новые документы
```
+ LIQUID_GLASS_REDESIGN.md    - Полный отчет о редизайне
+ LIQUID_GLASS_CHEATSHEET.md  - Шпаргалка по liquid glass
+ README_LIQUID_GLASS.md      - Обновленный README
+ CHANGELOG.md                - Этот файл
```

#### Обновленные документы
```
~ QUICKSTART.md               - Добавлена инфо о новом UI
~ README_RU.md                - Русский README (if exists)
```

### 🐛 Исправления

#### Bug Fixes
- ✅ Popover корректно закрывается при клике вне
- ✅ Hover state не "залипает"
- ✅ Поиск не лагает при большом количестве сервисов
- ✅ Кнопки не перекрывают друг друга

#### Performance
- ⚡️ LazyVStack вместо VStack для списка
- 🎯 Local @State для hover вместо @Published
- 🔄 Efficient filtering с `filter`
- 💾 Minimal redraws

### 🔧 Technical Details

#### Dependencies
```swift
// Без изменений
- SwiftUI
- AppKit
- Combine
- Core (внутренний модуль)
- SystemModule (внутренний модуль)
```

#### Minimum Requirements
```
- macOS 13.0+ (для .ultraThinMaterial)
- Swift 5.8+
- Xcode 14.0+
```

#### Build System
```bash
# Без изменений
./build.sh
make build
```

---

## Предыдущие версии

### Version 1.0.0 - "Initial Release"

#### Features
- ✅ WindowGroup с ServiceListView
- ✅ NSMenu в menu bar
- ✅ CLI приложение
- ✅ Основная функциональность

#### Architecture
- WindowGroup + SwiftUI
- NSMenu для menu bar
- Core business logic
- SystemModule интеграция

---

## Migration Guide (1.0 → 2.0)

### Для пользователей

**Что изменилось:**
1. Приложение больше не показывается в Dock
2. Доступ только через menu bar (иконка 🖥️)
3. Новый popover интерфейс вместо окна
4. Быстрые действия при наведении

**Как привыкнуть:**
1. Ищите приложение в menu bar (справа вверху)
2. Кликайте на иконку для открытия
3. Используйте поиск для быстрого доступа
4. Наводите на сервисы для действий

### Для разработчиков

**Удаленные API:**
```swift
// Старый способ
MenuBarController.shared.attach(viewModel: vm)
MenuBarController.shared.rebuildMenu()

// Новый способ  
MenuBarController.shared.setup()  // автоматически создает VM
```

**Новые компоненты:**
```swift
// Использование нового UI
MenuBarPopoverView(viewModel: viewModel)
ServiceRowView(service: service, ...)
GlassButtonStyle(variant: .compact)
```

**AppDelegate:**
```swift
// Теперь обязательно
@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
```

---

## Roadmap

### v2.1.0 (планируется)
- [ ] Настройки приложения
- [ ] Автозапуск при входе в систему
- [ ] Группировка сервисов

### v2.2.0 (планируется)
- [ ] Keyboard shortcuts для сервисов
- [ ] Экспорт/импорт конфигураций
- [ ] Кастомные темы

### v3.0.0 (идеи)
- [ ] Widget для Dashboard
- [ ] visionOS support
- [ ] Shortcuts integration

---

## Credits

### Inspiration
- [BrewServicesManager](https://github.com/validatedev/BrewServicesManager/) - menu bar architecture
- Apple HIG - design guidelines
- SwiftUI community - best practices

### Technologies
- SwiftUI - UI framework
- AppKit - macOS integration
- Liquid Glass - material design
- SF Symbols - iconography

---

## License

MIT License - see LICENSE file for details.

---

**Спасибо за использование Homebrew Services Manager!** ✨

<p align="center">
  Made with ❤️ using Liquid Glass design
</p>
