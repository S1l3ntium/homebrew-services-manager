cask "homebrew-services-manager" do
  version "1.0.0"
  sha256 :no_check # replace with actual sha256 for release asset

  url "https://github.com/USER/REPO/releases/download/v#{version}/HomebrewServicesManager-#{version}.dmg"
  name "Homebrew Services Manager"
  desc "GUI to manage Homebrew services on macOS"
  homepage "https://github.com/USER/REPO"

  depends_on macos: ">= :ventura"

  app "HomebrewServicesManager.app"

  # Optional: expose CLI binary
  # binary "usr/local/bin/hsmanager-cli", target: "hsmanager-cli"
end
