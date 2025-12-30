cask 'homebrew-services-manager' do
  version '1.0'
  sha256 'c0ccb7a6ab1119e8ba1a02f6365f0fe3529f2cf74e2c9a9d63c4446b7e7082c2'

  url "https://github.com/YOUR_USERNAME/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager.app.zip"
  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services on macOS'
  homepage 'https://github.com/YOUR_USERNAME/homebrew-services-manager'

  app 'HomebrewServicesManager.app'

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
