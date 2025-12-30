# Quick Start: Publishing to Homebrew Cask
# Быстрый старт: публикация в Homebrew Cask

## За 5 минут до публикации

### 1. Подготовьте GitHub репозиторий

```bash
# Убедитесь, что проект на GitHub
git remote -v

# Если нет - создайте репозиторий на GitHub и добавьте:
git remote add origin https://github.com/YOUR_USERNAME/homebrew-services-manager.git
git push -u origin main
```

### 2. Создайте GitHub Release

```bash
# Собираем релиз версию
swift build -c release

# Создаем GitHub Release (установите gh CLI сначала)
gh release create v1.0 \
  --title "v1.0 - Initial Release" \
  --notes "Homebrew Services Manager - Menu bar app for managing Homebrew services"

# Загружаем бинарь в релиз
gh release upload v1.0 .build/release/HomebrewServicesManager
```

### 3. Вычислите SHA256

```bash
# Получите хеш загруженного файла
shasum -a 256 .build/release/HomebrewServicesManager
# Вывод: abc123... homebrew-services-manager

# Скопируйте этот хеш - понадобится в формуле
```

### 4. Создайте свой Homebrew Tap

На GitHub создайте новый репозиторий с именем: `homebrew-tap`

```bash
# Клонируйте его локально
git clone https://github.com/YOUR_USERNAME/homebrew-tap.git
cd homebrew-tap

# Создайте структуру директорий
mkdir -p Casks

# Создайте формулу (скопируйте содержимое ниже)
cat > Casks/homebrew-services-manager.rb << 'EOF'
cask 'homebrew-services-manager' do
  version '1.0'
  sha256 'ABC123...'  # ← ЗАМЕНИТЕ НА ПОЛУЧЕННЫЙ ХЕШ

  url "https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager"

  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services'
  homepage 'https://github.com/YOUR_USERNAME/homebrew-services-manager'

  binary 'HomebrewServicesManager', target: 'homebrew-services-manager'

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
EOF
```

### 5. Отправьте в свой tap репозиторий

```bash
git add .
git commit -m "Add homebrew-services-manager cask"
git push
```

## Готово! ✅

Теперь пользователи могут установить ваше приложение:

```bash
brew tap YOUR_USERNAME/tap
brew install --cask homebrew-services-manager
```

---

## Дополнительно: Обновление версии

Когда выпустите v1.1:

```bash
# В основном репозитории:
git tag v1.1
swift build -c release
gh release create v1.1 .build/release/HomebrewServicesManager

# В tap репозитории:
# Обновите файл Casks/homebrew-services-manager.rb:
# - Измените version на '1.1'
# - Обновите sha256 на новый хеш
git commit -am "Update homebrew-services-manager to v1.1"
git push
```

---

## Файлы для справки

- `HOMEBREW_CASK.md` - Подробное описание процесса
- `homebrew-services-manager.rb` - Пример готовой формулы
- `INSTALLATION.md` - Инструкции для конечных пользователей

---

## Что скопировать в свой tap репозиторий

Из этого проекта копируете только файл:
- `homebrew-services-manager.rb` → `Casks/homebrew-services-manager.rb`

В tap репозитории минимальная структура:

```
homebrew-tap/
├── Casks/
│   └── homebrew-services-manager.rb
├── README.md (опционально)
└── .git/
```

---

**Итого:** 5 команд → готово к установке через Homebrew! 🎉
