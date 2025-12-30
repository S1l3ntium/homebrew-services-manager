# 🔄 Migration Guide: v1.0 → v2.0 (Liquid Glass)

## Что изменилось?

### TL;DR
- ❌ **Убрано:** Главное окно приложения
- ✅ **Добавлено:** Красивый menu bar popover с Liquid Glass
- 🎨 **Улучшено:** Современный дизайн и быстрые действия

---

## 📱 Для пользователей

### Визуальные изменения

#### Было (v1.0):
```
1. Иконка в Dock 🖥️
2. Главное окно со списком
3. Menu bar с простым NSMenu
4. Действия через подменю
```

#### Стало (v2.0):
```
1. Только menu bar ✨ (без Dock)
2. Красивый popover с Liquid Glass
3. Поиск в реальном времени 🔍
4. Hover actions - кнопки при наведении
```

### Как пользоваться новой версией?

#### 1️⃣ Где найти приложение?

**Старая версия:**
- В Dock
- Cmd+Tab для переключения

**Новая версия:**
- В menu bar (справа вверху, иконка 🖥️)
- Клик на иконке открывает popover

#### 2️⃣ Как открыть приложение?

```
Кликните на иконку 🖥️ в menu bar
           ⬇️
    Откроется popover
```

#### 3️⃣ Как управлять сервисами?

**Старая версия:**
```
1. Открыть окно
2. Выбрать сервис
3. Клик правой кнопкой
4. Выбрать действие
```

**Новая версия:**
```
1. Открыть popover (клик на иконку)
2. Навести на сервис 👆
3. Кликнуть на кнопку: ▶️ ⏹ 🔄
```

#### 4️⃣ Как искать сервисы?

**Новая функция!** 🎉

```
1. Открыть popover
2. Начать вводить в поле поиска 🔍
3. Список автоматически фильтруется
```

#### 5️⃣ Горячие клавиши

| Клавиши | Действие |
|---------|----------|
| `Cmd+Q` | Выход из приложения |
| `Cmd+R` | Обновить список |
| `ESC` | Закрыть popover |

### Типичные вопросы

#### ❓ Где иконка в Dock?
**Ответ:** Приложение теперь не показывается в Dock. Это menu bar app, ищите иконку 🖥️ справа вверху.

#### ❓ Как открыть главное окно?
**Ответ:** Главного окна больше нет. Вместо него - красивый popover с Liquid Glass эффектами.

#### ❓ Как закрыть popover?
**Ответ:** 
- Кликнуть вне popover
- Нажать ESC
- Кликнуть еще раз на иконку в menu bar

#### ❓ Приложение не запускается?
**Ответ:** Проверьте menu bar - возможно, оно уже запущено!

#### ❓ Где настройки?
**Ответ:** В v2.0 пока нет настроек. Запланированы в v2.1.0

---

## 💻 Для разработчиков

### API Changes

#### MainApp.swift

**Было:**
```swift
@main
struct HomebrewServicesManagerApp: App {
    @StateObject private var listVM = ServiceListViewModel()
    
    var body: some Scene {
        WindowGroup("Homebrew Services Manager") {
            ServiceListView(viewModel: listVM)
        }
    }
}
```

**Стало:**
```swift
@main
struct HomebrewServicesManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        Task { @MainActor in
            MenuBarController.shared.setup()
        }
    }
}
```

#### MenuBarController.swift

**Было:**
```swift
MenuBarController.shared.attach(viewModel: viewModel)
MenuBarController.shared.rebuildMenu()

// NSMenu с NSMenuItem
private func rebuildMenu() {
    let menu = NSMenu()
    // ...
}
```

**Стало:**
```swift
MenuBarController.shared.setup()

// NSPopover с SwiftUI
private var popover: NSPopover?
popover?.contentViewController = NSHostingController(
    rootView: MenuBarPopoverView(viewModel: viewModel!)
)
```

#### Новые компоненты

**MenuBarPopoverView:**
```swift
struct MenuBarPopoverView: View {
    @ObservedObject var viewModel: ServiceListViewModel
    @State private var searchText = ""
    @State private var hoveredService: String?
    // ...
}
```

**ServiceRowView:**
```swift
struct ServiceRowView: View {
    let service: BrewService
    let isHovered: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    let onRestart: () -> Void
    // ...
}
```

**GlassButtonStyle:**
```swift
struct GlassButtonStyle: ButtonStyle {
    enum Variant {
        case standard, compact, subtle
    }
    // ...
}
```

**EventMonitor:**
```swift
class EventMonitor {
    init(mask: NSEvent.EventTypeMask, 
         handler: @escaping (NSEvent?) -> Void)
    func start()
    func stop()
}
```

### Удаленные зависимости

```swift
// Больше не используются:
- WindowGroup
- NSMenu / NSMenuItem
- FocusableTextField (для главного окна)
- NotificationCenter.post(.requestSearchFocus)
```

### Новые зависимости

```swift
// Добавлены:
- NSPopover
- NSHostingController
- @NSApplicationDelegateAdaptor
- EventMonitor
```

### Migration Steps

#### 1. Обновите MainApp.swift

```swift
// Добавьте AppDelegate
@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

// Замените WindowGroup на Settings
Settings { EmptyView() }
```

#### 2. Обновите MenuBarController.swift

```swift
// Старый метод - удалить
- func attach(viewModel: ServiceListViewModel)
- func rebuildMenu()

// Новый метод - добавить
+ func setup()
+ private var popover: NSPopover?
+ private var eventMonitor: EventMonitor?
```

#### 3. Добавьте новые файлы

```bash
touch Sources/App/MenuBarPopoverView.swift
# Скопируйте содержимое из примера
```

#### 4. Обновите зависимости

```swift
// Package.swift - без изменений
// Все те же модули: Core, SystemModule
```

#### 5. Пересоберите проект

```bash
BUILD_APP=1 ./build.sh
```

### Testing

#### Unit Tests

```swift
// Тесты Core модуля - без изменений
import Testing

@Test func testBrewService() {
    // ...
}
```

#### UI Testing

```swift
// Preview для нового UI
#Preview {
    MenuBarPopoverView(viewModel: {
        let vm = ServiceListViewModel()
        vm.services = [/* mock data */]
        return vm
    }())
}
```

### Troubleshooting

#### Ошибка: "No such module 'MenuBarPopoverView'"
**Решение:** Убедитесь, что файл находится в `Sources/App/`

#### Ошибка: "Cannot find 'AppDelegate'"
**Решение:** Добавьте класс AppDelegate в MainApp.swift

#### Popover не закрывается
**Решение:** Проверьте EventMonitor - должен вызываться `.start()`

#### Hover не работает
**Решение:** Убедитесь, что у ServiceRowView есть `.onHover { }`

---

## 📊 Feature Comparison

| Feature | v1.0 | v2.0 |
|---------|------|------|
| Главное окно | ✅ | ❌ |
| Menu bar | ✅ (NSMenu) | ✅ (Popover) |
| Иконка в Dock | ✅ | ❌ |
| Поиск | ❌ | ✅ |
| Hover actions | ❌ | ✅ |
| Liquid Glass | ❌ | ✅ |
| Уведомления | ✅ | ✅ |
| CLI | ✅ | ✅ |
| Горячие клавиши | Частично | ✅ |

---

## 🎯 Best Practices (v2.0)

### Для UI

1. **Используйте hover для действий**
   ```swift
   .onHover { hovering in
       hoveredService = hovering ? service.name : nil
   }
   ```

2. **Анимации должны быть плавными**
   ```swift
   .animation(.easeInOut(duration: 0.15), value: isHovered)
   ```

3. **Liquid Glass для интерактивных элементов**
   ```swift
   .background(.ultraThinMaterial)
   ```

### Для Performance

1. **LazyVStack для больших списков**
   ```swift
   LazyVStack(spacing: 4) {
       ForEach(services) { service in
           ServiceRowView(service: service)
       }
   }
   ```

2. **Local state для UI**
   ```swift
   @State private var hoveredService: String?
   // НЕ @Published в ViewModel
   ```

---

## 📚 Дополнительные ресурсы

- [LIQUID_GLASS_REDESIGN.md](LIQUID_GLASS_REDESIGN.md) - Полный отчет
- [LIQUID_GLASS_CHEATSHEET.md](LIQUID_GLASS_CHEATSHEET.md) - Шпаргалка
- [CHANGELOG.md](CHANGELOG.md) - История изменений
- [QUICKSTART.md](QUICKSTART.md) - Быстрый старт

---

## 💬 Нужна помощь?

1. **Прочитайте документацию** выше
2. **Посмотрите примеры** в коде
3. **Создайте Issue** на GitHub
4. **Напишите нам** (контакты в README)

---

## ✨ Заключение

**v2.0** - это major update с фокусом на:
- 🎨 Современный дизайн (Liquid Glass)
- ⚡️ Лучший UX (hover actions, search)
- 🎯 Минимализм (menu bar only)

**Migration time: ~5-10 минут** ⏱️

**Enjoy the new Liquid Glass experience!** 🎉

---

<p align="center">
  Questions? Open an issue on GitHub! 💬
</p>
