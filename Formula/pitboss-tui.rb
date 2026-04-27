class PitbossTui < Formula
  desc "TUI companion for pitboss — live tile grid, log tailing, budget counters."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.9.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-tui-aarch64-apple-darwin.tar.xz"
    sha256 "9aa27698a77b5190a8ced9e3464803ef97af4157cf3dd0da3323cd3f9ceb4679"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5c0fd9d48876dc696808cc5fceed9cda37d7501560aa05bfdc42d0510be9f6c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8badc59286f47eaf4c535b24ab716291ba58f6e93ef249c9b707e8e064c4ca47"
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
