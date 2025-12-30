cask 'homebrew-services-manager' do
  version '1.0'
  sha256 '9e62be93d759b30859dbc1eb40ea4571623fd04121d29e8900f6b53041926247'

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
