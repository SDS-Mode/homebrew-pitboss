class PitbossTui < Formula
  desc "TUI companion for pitboss — live tile grid, log tailing, budget counters."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.13.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-tui-aarch64-apple-darwin.tar.xz"
    sha256 "d645f78a01ad2e18850914e7b19a86adecdd627418f7fde2c56518ac1640c43d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9e0b953290916911ccafef5c313a33b057c4d3d960e08eed0f825662f0f58ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b5e1b9b4ec6791bcd19af6bff5f1391ebaf0e7d90d5f0c890e0d11211490f04"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pitboss-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "pitboss-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "pitboss-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
