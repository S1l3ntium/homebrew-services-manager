class HomebrewServicesManager < Formula
  desc "Native macOS GUI to manage Homebrew services"
  homepage "https://github.com/USER/REPO"
  url "https://github.com/USER/REPO/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256"
  license "MIT"

  depends_on :xcode => ["14.0"]
  depends_on macos: :ventura

  def install
    # If you provide a CLI executable built via SwiftPM
    system "swift", "build", "-c", "release", "-Xswiftc", "-target", "x86_64-apple-macosx13.0"
    bin.install ".build/release/hsmanager-cli"

    # For GUI cask packaging, prefer providing a Cask and prebuilt .dmg in Releases
  end

  test do
    assert_match "hsmanager-cli", shell_output("#{bin}/hsmanager-cli --help", 0)
  end
end
