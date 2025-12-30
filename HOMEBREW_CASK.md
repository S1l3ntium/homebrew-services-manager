# Homebrew Cask Distribution

Этот документ описывает процесс создания и публикации приложения в Homebrew Cask.

## Шаг 1: Подготовка GitHub Repository

Перед публикацией в Homebrew убедитесь, что проект выложен на GitHub:

```bash
# Инициализация удаленного репозитория (если ещё не создан)
git remote add origin https://github.com/YOUR_USERNAME/homebrew-services-manager.git
git push -u origin main

# Создание GitHub Release
# Перейдите на https://github.com/YOUR_USERNAME/homebrew-services-manager/releases
# или используйте gh CLI:
gh release create v1.0 --title "v1.0 - Initial Release" --notes "Первый релиз Homebrew Services Manager"
```

## Шаг 2: Подготовка Binary для Cask

Для Homebrew Cask нужен собранный app bundle. Текущая сборка создает исполняемый файл.

Вариант 1: Используем текущий бинарь (простейший способ)

```bash
# Проверяем сборку
swift build -c release

# Путь к бинарю
ls -lh .build/release/HomebrewServicesManager
# Размер: ~758 KB
```

Вариант 2: Создаем полноценный .app bundle (рекомендуется для UI приложений)

Для этого нужно обновить Package.swift, чтобы создавать .app, но текущего бинаря достаточно для Cask.

## Шаг 3: Вычисление SHA256 хеша бинаря

После загрузки бинаря на GitHub нужно вычислить SHA256:

```bash
# Скачиваем бинарь с GitHub или вычисляем локально
shasum -a 256 .build/release/HomebrewServicesManager
```

## Шаг 4: Создание Cask Formula

Создайте файл `homebrew-services-manager.rb` с содержимым ниже.

**Структура для вашего проекта:**

```
https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v1.0/HomebrewServicesManager
```

### Вариант A: Бинарь как исполняемый файл (текущий подход)

```ruby
cask 'homebrew-services-manager' do
  version '1.0'
  sha256 '<SHA256_HASH_HERE>'

  url "https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager"

  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services'
  homepage 'https://github.com/YOUR_USERNAME/homebrew-services-manager'

  # Устанавливает бинарь в /usr/local/bin
  binary 'HomebrewServicesManager', target: 'homebrew-services-manager'

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
```

### Вариант B: Полный .app bundle (если будет создан)

```ruby
cask 'homebrew-services-manager' do
  version '1.0'
  sha256 '<SHA256_HASH_HERE>'

  url "https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager.app.zip"

  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services'
  homepage 'https://github.com/YOUR_USERNAME/homebrew-services-manager'

  app 'HomebrewServicesManager.app'

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
```

## Шаг 5: Публикация в Homebrew Cask

### Вариант 1: Через личный tap (быстрый способ)

Создайте свой homebrew tap репозиторий:

```bash
# Создайте новый репозиторий с именем homebrew-tap
# На GitHub: https://github.com/YOUR_USERNAME/homebrew-tap

# Клонируйте структуру
mkdir homebrew-tap
cd homebrew-tap
mkdir Casks

# Создайте файл
cat > Casks/homebrew-services-manager.rb << 'EOF'
# ... содержимое cask formula ...
EOF

git add .
git commit -m "Add homebrew-services-manager cask"
git push
```

Тогда пользователи смогут установить через:

```bash
brew tap YOUR_USERNAME/tap
brew install --cask homebrew-services-manager
```

### Вариант 2: Через официальный Homebrew Cask (требует одобрения)

1. Создайте fork репозитория https://github.com/Homebrew/homebrew-cask
2. Создайте файл `Casks/homebrew-services-manager.rb`
3. Отправьте Pull Request с описанием приложения
4. Homebrew team проверит и одобрит

Требования:
- Приложение должно быть стабильным
- Исходный код на GitHub
- Минимум 1-2 дня активной разработки в истории
- Добрый тон при взаимодействии с сообществом

## Шаг 6: Подготовка GitHub Release с бинарём

```bash
# В корне проекта
swift build -c release

# Скопируйте или создайте архив бинаря
cp .build/release/HomebrewServicesManager ./
zip HomebrewServicesManager.zip HomebrewServicesManager

# Создайте GitHub Release и загрузите файл
# https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/new

# Или через gh CLI:
gh release create v1.0 \
  --title "v1.0 - Initial Release" \
  --notes "Первый релиз Homebrew Services Manager" \
  HomebrewServicesManager
```

## Рекомендуемая последовательность действий

1. **Убедитесь, что проект на GitHub:**
   ```bash
   git remote -v  # Проверьте, есть ли origin
   ```

2. **Создайте релиз:**
   ```bash
   swift build -c release
   gh release create v1.0 .build/release/HomebrewServicesManager
   ```

3. **Создайте свой tap (своя формула):**
   ```bash
   # Создайте репозиторий homebrew-tap на GitHub
   # Добавьте файл Casks/homebrew-services-manager.rb
   ```

4. **Пользователи смогут установить:**
   ```bash
   brew tap YOUR_USERNAME/tap
   brew install --cask homebrew-services-manager
   ```

## SHA256 вычисление

После загрузки бинаря на GitHub Release:

```bash
# Скачиваем и вычисляем
curl -L https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v1.0/HomebrewServicesManager | shasum -a 256

# Или локально
shasum -a 256 .build/release/HomebrewServicesManager
```

## Обновление версии в будущих релизах

Для новых версий просто:

1. Обновите версию в коде
2. Создайте новый git tag: `git tag v1.1`
3. Создайте GitHub Release с бинарём
4. Обновите `version` и `sha256` в cask formula
5. Отправьте обновление в свой tap

## Альтернатива: MacPorts

Если хотите распространять через MacPorts, процесс похож, но требует Portfile вместо Ruby formula.

## Проверка локально

После создания cask formula можно проверить локально:

```bash
# Положите файл в ~/.homebrew/Library/Taps/YOUR_USERNAME/homebrew-tap/Casks/

brew install --cask --verbose homebrew-services-manager

# Проверьте установку
which homebrew-services-manager
homebrew-services-manager --help  # если приложение поддерживает --help
```

---

**Резюме:** Для быстрого старта создайте свой tap репозиторий, добавьте туда cask formula, и пользователи смогут устанавливать приложение через `brew install --cask`.
