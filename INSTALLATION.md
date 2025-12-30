# Installation Guide / Руководство по установке

## English

### Option 1: Install via Homebrew Cask (Recommended)

```bash
# Add the tap
brew tap USERNAME/tap

# Install the application
brew install --cask homebrew-services-manager

# The app will be accessible from menu bar
```

### Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/USERNAME/homebrew-services-manager.git
cd homebrew-services-manager

# Build the release version
swift build -c release

# Run the application
.build/release/HomebrewServicesManager
```

### Option 3: Download Release Binary

1. Go to [Releases](https://github.com/USERNAME/homebrew-services-manager/releases)
2. Download `HomebrewServicesManager` binary
3. Make it executable:
   ```bash
   chmod +x HomebrewServicesManager
   ```
4. Move to Applications or a location in your PATH:
   ```bash
   mv HomebrewServicesManager /usr/local/bin/
   # Then run: homebrew-services-manager
   ```

### Uninstall via Homebrew

```bash
brew uninstall --cask homebrew-services-manager
```

---

## Русский

### Способ 1: Установка через Homebrew Cask (Рекомендуется)

```bash
# Добавляем tap репозиторий
brew tap USERNAME/tap

# Устанавливаем приложение
brew install --cask homebrew-services-manager

# Приложение будет доступно в меню bar
```

### Способ 2: Сборка из исходного кода

```bash
# Клонируем репозиторий
git clone https://github.com/USERNAME/homebrew-services-manager.git
cd homebrew-services-manager

# Собираем релизную версию
swift build -c release

# Запускаем приложение
.build/release/HomebrewServicesManager
```

### Способ 3: Скачать готовый бинарь

1. Перейдите на страницу [Releases](https://github.com/USERNAME/homebrew-services-manager/releases)
2. Скачайте бинарь `HomebrewServicesManager`
3. Сделайте его исполняемым:
   ```bash
   chmod +x HomebrewServicesManager
   ```
4. Переместите в Applications или в папку в PATH:
   ```bash
   mv HomebrewServicesManager /usr/local/bin/
   # Затем запустите: homebrew-services-manager
   ```

### Удаление через Homebrew

```bash
brew uninstall --cask homebrew-services-manager
```

---

## Requirements / Требования

- macOS 13.0 или позже
- Homebrew установлен (для работы приложения)
- Swift 5.8+ (только для сборки из исходного кода)

## First Launch / При первом запуске

1. Application will appear as a menu bar icon (server rack icon)
2. Click the icon to see list of Homebrew services
3. You may be prompted to authorize certain operations (start/stop services)

---

## Troubleshooting / Решение проблем

### Application doesn't appear in menu bar

```bash
# Try running directly
/usr/local/bin/homebrew-services-manager

# Or if installed via Cask
$(brew --cellar)/homebrew-services-manager/1.0/bin/HomebrewServicesManager
```

### Permission denied error

```bash
# Make sure binary is executable
chmod +x /usr/local/bin/homebrew-services-manager

# Some operations may require sudo
sudo brew services list
```

### Homebrew not found

The application requires Homebrew to be installed. Install it from https://brew.sh/

---

## Support / Поддержка

For issues or questions:
- Open an issue on GitHub: https://github.com/USERNAME/homebrew-services-manager/issues
- Check existing documentation in README.md

---

**Version:** 1.0
**Last Updated:** 2025-12-30
