class PitbossCli < Formula
  desc "Dispatcher for running and observing parallel Claude Code sessions."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-aarch64-apple-darwin.tar.xz"
    sha256 "ba762ee54b38462310268846097eb52d6ec04ff32d201cae37dcb1c2e32e4e9e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fcb99dd50989f9a07cb29a2b6cf6b7b8b620824ec4e5f357991132d83f62f324"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a4557899fb37a7b10910877ba083b5c8cec2a892f5ccddcc9ee5213673a1ea65"
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
