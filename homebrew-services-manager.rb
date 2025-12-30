cask 'homebrew-services-manager' do
  version '1.0'
  sha256 'YOUR_SHA256_HASH_HERE'

  url "https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager"
  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services on macOS'
  homepage 'https://github.com/YOUR_USERNAME/homebrew-services-manager'

  # Категория в Homebrew
  auto_updates false

  # Устанавливает бинарь в /usr/local/bin
  binary 'HomebrewServicesManager', target: 'homebrew-services-manager'

  # Удаляет файлы при деинсталляции
  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
