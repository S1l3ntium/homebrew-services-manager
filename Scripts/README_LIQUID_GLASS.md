# 🎨 Homebrew Services Manager - Liquid Glass Edition

> Современный macOS menu bar менеджер для Homebrew сервисов с Liquid Glass дизайном

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.8+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

---

## ✨ Особенности

### 🎨 Современный дизайн
- **Liquid Glass Material** - полупрозрачные элементы с размытием
- **Hover эффекты** - интерактивные элементы с плавными анимациями
- **SwiftUI Popover** - красивое всплывающее меню
- **Menu Bar Only** - минималистичный подход без окна в Dock

### ⚡️ Функциональность
- 🔍 **Мгновенный поиск** - фильтрация сервисов в реальном времени
- 🎯 **Быстрые действия** - start/stop/restart при наведении
- 🌈 **Цветовые индикаторы** - статусы сервисов (🟢 запущен, 🔴 ошибка, ⚫️ остановлен)
- 📱 **Уведомления** - нативные macOS notifications
- ⚡️ **Горячие клавиши** - `Cmd+Q` для выхода, `Cmd+R` для обновления

### 🛠 Технологии
- **SwiftUI** - декларативный UI
- **AppKit** - интеграция с macOS
- **Swift Concurrency** - async/await
- **Combine** - reactive programming
- **SF Symbols** - системные иконки

---

## 📸 Скриншоты

```
┌──────────────────────────────────┐
│ 🖥️ Homebrew Services      🔄    │ ← Liquid Glass заголовок
├──────────────────────────────────┤
│ 🔍 Search services...            │ ← Поиск
├──────────────────────────────────┤
│ 🟢 postgresql@14 (started)       │
│ ⚫️ redis (stopped)        ▶️⏹🔄  │ ← Hover actions
│ 🔴 nginx (error)                 │
│ 🟢 mysql (started)               │
├──────────────────────────────────┤
│ 4 service(s)              Quit   │ ← Футер
└──────────────────────────────────┘
```

---

## 🚀 Быстрый старт

### Требования

- macOS 13.0 или новее
- Xcode 14.0 или новее
- Homebrew установлен

### Установка

```bash
# Клонируйте репозиторий
git clone https://github.com/yourusername/homebrew-services-manager.git
cd homebrew-services-manager

# Сделайте скрипт исполняемым
chmod +x first-build.sh

# Запустите автоматическую сборку
./first-build.sh
```

Или через Makefile:

```bash
make build      # Собрать проект
make run-app    # Запустить menu bar app
make run-cli    # Запустить CLI версию
make test       # Запустить тесты
```

### Ручная сборка

```bash
# Сборка
BUILD_APP=1 ./build.sh

# Запуск menu bar приложения
./dist/HomebrewServicesManager

# Запуск CLI
./dist/hsmanager-cli
```

---

## 📖 Использование

### Menu Bar App

1. **Запустите приложение** - иконка 🖥️ появится в menu bar
2. **Кликните на иконку** - откроется popover с liquid glass дизайном
3. **Используйте поиск** - начните вводить название сервиса
4. **Наведите на сервис** - появятся кнопки управления
5. **Выберите действие:**
   - ▶️ **Start** - запустить сервис
   - ⏹ **Stop** - остановить сервис
   - 🔄 **Restart** - перезапустить сервис

### CLI

```bash
# Показать список сервисов
./dist/hsmanager-cli

# С опциями
./dist/hsmanager-cli --help
```

### Горячие клавиши

- `Cmd+Q` - Выход из приложения
- `Cmd+R` - Обновить список сервисов
- `ESC` или клик вне popover - закрыть popover

---

## 🏗 Архитектура

### Структура проекта

```
HomebrewServicesManager/
├── Sources/
│   ├── App/                      # GUI приложение
│   │   ├── MainApp.swift         # Entry point + AppDelegate
│   │   ├── MenuBarController.swift    # Menu bar управление
│   │   ├── MenuBarPopoverView.swift   # UI с Liquid Glass
│   │   ├── ServiceListView.swift      # Основной список (legacy)
│   │   └── ServiceListViewModel.swift # ViewModel
│   ├── CLI/                      # CLI приложение
│   │   └── main.swift
│   ├── Core/                     # Бизнес-логика
│   │   ├── BrewService.swift
│   │   └── BrewServiceManager.swift
│   └── SystemModule/             # Системная интеграция
│       └── NotificationsManager.swift
├── Tests/
│   └── CoreTests/
└── dist/                         # Скомпилированные бинарники
```

### Компоненты

#### MenuBarController
Управляет NSStatusItem и NSPopover:
- Создает иконку в menu bar
- Показывает/скрывает popover
- Event monitoring для закрытия popover

#### MenuBarPopoverView
Главный SwiftUI view с компонентами:
- **Header** - заголовок с refresh кнопкой
- **Search** - поиск с фильтрацией
- **ServiceRowView** - строки сервисов с hover actions
- **Footer** - информация и кнопка Quit

#### GlassButtonStyle
Кастомный ButtonStyle с liquid glass эффектом:
- `.ultraThinMaterial` фон
- Hover и press анимации
- Три варианта: standard, compact, subtle

---

## 🎨 Дизайн система

### Liquid Glass Components

```swift
// Кнопка с glass эффектом
Button("Action") { }
    .buttonStyle(GlassButtonStyle())

// Hover эффект
.background(
    RoundedRectangle(cornerRadius: 8)
        .fill(.ultraThinMaterial)
)

// Анимации
.animation(.easeInOut(duration: 0.15), value: isHovered)
```

### Цветовая палитра

| Цвет | Назначение | Пример |
|------|------------|--------|
| 🟢 Green | Started | Сервис запущен |
| 🔴 Red | Error | Ошибка сервиса |
| ⚫️ Gray | Stopped | Сервис остановлен |
| 🟠 Orange | Other | Другие состояния |
| 🔵 Blue | Actions | Основные действия |

---

## 📚 Документация

- 📖 [QUICKSTART.md](QUICKSTART.md) - быстрый старт
- 🎨 [LIQUID_GLASS_REDESIGN.md](LIQUID_GLASS_REDESIGN.md) - подробный отчет о редизайне
- 📝 [LIQUID_GLASS_CHEATSHEET.md](LIQUID_GLASS_CHEATSHEET.md) - шпаргалка по liquid glass
- 🔧 [FIXES_REPORT.md](FIXES_REPORT.md) - отчет об исправлениях

---

## 🤝 Вклад в проект

Мы приветствуем ваш вклад! Вот как вы можете помочь:

1. 🐛 **Сообщайте о багах** через Issues
2. 💡 **Предлагайте идеи** для новых фич
3. 🔧 **Создавайте Pull Requests** с улучшениями
4. 📖 **Улучшайте документацию**

### Development

```bash
# Запуск тестов
swift test

# Или через make
make test

# Проверка структуры
./check-structure.sh

# Сборка
make build
```

---

## 📝 Roadmap

### В разработке
- [ ] Группировка сервисов по типу
- [ ] Автозапуск при входе в систему
- [ ] Настройки приложения
- [ ] Экспорт/импорт конфигураций

### Рассматривается
- [ ] Widget для Dashboard
- [ ] Интеграция с Notification Center
- [ ] Кастомные темы
- [ ] Keyboard shortcuts для каждого сервиса

---

## 🙏 Благодарности

- **Apple** - за Liquid Glass design и отличные фреймворки
- **[BrewServicesManager](https://github.com/validatedev/BrewServicesManager/)** - за вдохновение и референс
- **Homebrew** - за отличный пакетный менеджер
- **SwiftUI community** - за примеры и best practices

---

## 📄 Лицензия

MIT License - смотрите [LICENSE](LICENSE) файл для деталей.

---

## 📧 Контакты

- GitHub: [@yourusername](https://github.com/yourusername)
- Issues: [GitHub Issues](https://github.com/yourusername/homebrew-services-manager/issues)

---

## ⭐️ Поддержите проект

Если вам нравится проект - поставьте ⭐️ на GitHub!

---

<p align="center">
  Made with ❤️ and ✨ Liquid Glass
</p>
