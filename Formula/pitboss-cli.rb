class PitbossCli < Formula
  desc "Dispatcher for running and observing parallel Claude Code sessions."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-aarch64-apple-darwin.tar.xz"
    sha256 "dae085a9156caea53ac0ded013a9fdcb1f8d9c30bbb382ebd95fb3907c7c998c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d515ee9fd500a4b478c2ca1482ec8932d8ba946e66824358368ea4843783610"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.8.0/pitboss-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e415dd6ddee1117b19a07b18da760e4a190200887611c35679535956adb10ff"
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
