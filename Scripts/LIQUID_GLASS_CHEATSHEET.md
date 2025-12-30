# 🎨 Liquid Glass Design Cheatsheet

## Быстрая справка по новому дизайну

### 🎯 Основные концепции Liquid Glass

**Liquid Glass** - это динамический материал от Apple, который:
- Размывает контент позади
- Отражает цвета окружения
- Реагирует на взаимодействия
- Создает эффект стеклянной поверхности

---

## 📦 Компоненты в проекте

### 1. GlassButtonStyle

Кастомный стиль кнопок с glass эффектом:

```swift
// Использование
Button("Click Me") {
    // action
}
.buttonStyle(GlassButtonStyle())

// Варианты
.buttonStyle(GlassButtonStyle(variant: .standard))  // по умолчанию
.buttonStyle(GlassButtonStyle(variant: .compact))   // компактный
.buttonStyle(GlassButtonStyle(variant: .subtle))    // тонкий
```

**Фичи:**
- ✨ `.ultraThinMaterial` фон
- 🎭 Hover эффекты
- ⚡️ Press анимации
- 🎨 Полупрозрачная обводка

---

### 2. ServiceRowView

Строка сервиса с hover actions:

```swift
ServiceRowView(
    service: service,
    isHovered: hoveredService == service.name,
    onStart: { /* action */ },
    onStop: { /* action */ },
    onRestart: { /* action */ }
)
.onHover { hovering in
    hoveredService = hovering ? service.name : nil
}
```

**Фичи:**
- 🎯 Цветовой индикатор статуса
- ⚡️ Кнопки при наведении
- 🎨 Glass фон на hover
- 💫 Плавные transitions

---

### 3. MenuBarPopoverView

Главный view с полным UI:

```swift
MenuBarPopoverView(viewModel: viewModel)
```

**Структура:**
- 📋 Заголовок с refresh кнопкой
- 🔍 Поиск в реальном времени
- 📜 Scrollable список сервисов
- ⚙️ Футер с инфо и кнопками

---

## 🎨 Как применять Liquid Glass

### В SwiftUI (macOS 14+):

#### 1. Фон с материалом

```swift
.background(.ultraThinMaterial)
```

**Доступные материалы:**
- `.ultraThinMaterial` - самый прозрачный
- `.thinMaterial` - тонкий
- `.regularMaterial` - обычный
- `.thickMaterial` - толстый
- `.ultraThickMaterial` - самый плотный

#### 2. Glass Effect (в будущих версиях)

```swift
Text("Hello")
    .padding()
    .glassEffect()  // может потребоваться более новая macOS
```

#### 3. Кастомный Glass

```swift
.background(
    RoundedRectangle(cornerRadius: 8)
        .fill(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 2)
)
```

---

## 🎭 Анимации и эффекты

### Hover эффект

```swift
@State private var isHovered = false

.scaleEffect(isHovered ? 1.05 : 1.0)
.animation(.easeInOut(duration: 0.15), value: isHovered)
.onHover { hovering in
    isHovered = hovering
}
```

### Press эффект

```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.opacity(isPressed ? 0.8 : 1.0)
```

### Появление элементов

```swift
.transition(.opacity.combined(with: .scale(scale: 0.9)))
.animation(.easeInOut(duration: 0.15), value: showElement)
```

---

## 🌈 Цветовая система

### Статусы сервисов

```swift
private var statusColor: Color {
    let status = service.status.lowercased()
    if status.contains("start") {
        return .green      // 🟢 запущен
    } else if status.contains("error") {
        return .red        // 🔴 ошибка
    } else if status.contains("none") || status.contains("stopped") {
        return .gray       // ⚫️ остановлен
    } else {
        return .orange     // 🟠 другое
    }
}
```

### UI цвета

```swift
.blue       // основные действия, акценты
.green      // позитивные действия (start)
.red        // деструктивные действия (stop)
.primary    // основной текст
.secondary  // вторичный текст, иконки
```

---

## 📐 Размеры и отступы

### Popover

```swift
.frame(width: 360, height: 500)
```

### Padding

```swift
.padding(.horizontal, 12)  // боковые отступы для контента
.padding(.vertical, 8)     // вертикальные отступы

.padding(.horizontal, 16)  // заголовок/футер
.padding(.vertical, 12)
```

### Corner Radius

```swift
cornerRadius: 6   // стандартные элементы
cornerRadius: 8   // контейнеры
```

---

## ⚡️ Best Practices

### 1. Используйте lazy loading

```swift
LazyVStack(spacing: 4) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

### 2. Локальное состояние для hover

```swift
@State private var hoveredItem: String?
// вместо @Published в ViewModel
```

### 3. Плавные анимации

```swift
.animation(.easeInOut(duration: 0.15), value: state)
// единообразная длительность для похожих эффектов
```

### 4. Accessibility

```swift
.accessibilityLabel("Service name")
.accessibilityHint("Tap to manage service")
```

---

## 🔧 Debug и тестинг

### Preview с Liquid Glass

```swift
#Preview {
    MenuBarPopoverView(viewModel: {
        let vm = ServiceListViewModel()
        // mock data
        vm.services = [...]
        return vm
    }())
}
```

### Темная/светлая тема

Liquid Glass автоматически адаптируется, но можно протестировать:

```swift
#Preview {
    MyView()
        .preferredColorScheme(.dark)
}
```

---

## 📝 Примеры использования

### Простая кнопка с Glass

```swift
Button(action: refresh) {
    Image(systemName: "arrow.clockwise")
        .font(.system(size: 14))
        .frame(width: 28, height: 28)
}
.buttonStyle(GlassButtonStyle(variant: .compact))
```

### Поле поиска с Glass

```swift
HStack {
    Image(systemName: "magnifyingglass")
    TextField("Search...", text: $query)
}
.padding(.horizontal, 10)
.padding(.vertical, 6)
.background(
    RoundedRectangle(cornerRadius: 8)
        .fill(.ultraThinMaterial)
)
```

### Hover карточка

```swift
VStack {
    // content
}
.padding()
.background(
    ZStack {
        if isHovered {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        }
    }
)
.onHover { isHovered = $0 }
```

---

## 🚀 Полезные ссылки

### Документация Apple
- [Materials and Effects](https://developer.apple.com/documentation/swiftui/view-materials)
- [Visual Effects](https://developer.apple.com/documentation/appkit/nsvisualeffectview)

### Наши файлы
- `MenuBarPopoverView.swift` - все компоненты
- `LIQUID_GLASS_REDESIGN.md` - полный отчет
- `QUICKSTART.md` - быстрый старт

---

## ✨ Итого

Liquid Glass в проекте используется для:
- ✅ Кнопок (GlassButtonStyle)
- ✅ Hover эффектов (ServiceRowView)
- ✅ Фона popover (MenuBarPopoverView)
- ✅ Интерактивных элементов

**Результат:** Современный, красивый и отзывчивый UI! 🎉
