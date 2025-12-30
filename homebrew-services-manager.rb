cask 'homebrew-services-manager' do
  version '1.0'
  sha256 '7e5dc3e0358d66d41e00b12a1fcca549305c1282f59b59d7c93e5284e381ec68'

  url "https://github.com/S1l3ntium/homebrew-services-manager/releases/download/v#{version}/HomebrewServicesManager.app.zip"
  name 'Homebrew Services Manager'
  desc 'A lightweight menu bar application for managing Homebrew services on macOS'
  homepage 'https://github.com/S1l3ntium/homebrew-services-manager'

  app 'HomebrewServicesManager.app' do |app|
    FileUtils.rm_rf("#{app}/_CodeSignature")
  end

  postflight do
    system_command 'xattr', args: ['-d', 'com.apple.quarantine', "#{staged_path}/HomebrewServicesManager.app"]
  end

  zap trash: [
    '~/Library/Preferences/com.homebrew.services-manager.plist',
    '~/Library/Caches/com.homebrew.services-manager'
  ]
end
