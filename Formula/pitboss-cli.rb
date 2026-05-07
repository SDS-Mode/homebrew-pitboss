class PitbossCli < Formula
  desc "Dispatcher for running and observing parallel Claude Code sessions."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.11.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-cli-aarch64-apple-darwin.tar.xz"
    sha256 "fe26267b6cf656b4b65f4461bdcd22903eaf7b0ef0f6f6f8ce28c4d369c90939"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8610c46d1567149906f125de87120b9b49434abfa20cb81f4de4ce3a97688ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "600c18d24e807b5832edf92f0f02147d3a9992435e26d8d4d22c91ccabd72aae"
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
