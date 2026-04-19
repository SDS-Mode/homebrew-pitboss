class PitbossCli < Formula
  desc "Dispatcher for running and observing parallel Claude Code sessions."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.5.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.5.5/pitboss-cli-aarch64-apple-darwin.tar.xz"
    sha256 "58197f857563268a5db76d40f299a46d8a075bbb22a7582085f4ba521fc2d270"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.5.5/pitboss-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "545683d04bab696f6ae478a68e2e78518c819b74cf43ee3a3897c7cf196a6651"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.5.5/pitboss-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a1d43f92027e7e0a22542729a88b51b9af4e95f3dd42dc474d8962effff4283"
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
    bin.install "pitboss" if OS.mac? && Hardware::CPU.arm?
    bin.install "pitboss" if OS.linux? && Hardware::CPU.arm?
    bin.install "pitboss" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
