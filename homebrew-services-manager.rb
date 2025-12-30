cask 'homebrew-services-manager' do
  version '1.0'
  sha256 '13dd29bcb3b45114c0dcaa97149e0f74a7b5223c9b74e5eba0b1b03289bbb863'

  url "https://github.com/S1l3ntium/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager.app.zip"
  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services on macOS'
  homepage 'https://github.com/S1l3ntium/homebrew-services-manager'

  app 'HomebrewServicesManager.app'

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
