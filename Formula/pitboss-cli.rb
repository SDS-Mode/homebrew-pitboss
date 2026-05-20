class PitbossCli < Formula
  desc "Dispatcher for running and observing parallel Claude Code sessions."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.16.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-cli-aarch64-apple-darwin.tar.xz"
    sha256 "93443f55c21c55e4d6df6fe47dd50d83d1f99700ce391a68c62866549ba6defe"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fae44110a906a28870e4125f80eb742f5d141ed73fde2bd2c2a9e59dd7d62aba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a837606f744f8160bcb05beebedaee6f5e4a52636143fa09b0d4a8681f844582"
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
