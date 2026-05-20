class PitbossTui < Formula
  desc "TUI companion for pitboss — live tile grid, log tailing, budget counters."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.16.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-tui-aarch64-apple-darwin.tar.xz"
    sha256 "4076df7b1bfb7db81c209ed3906ca25c4e141f5e289da355f60629689d5ee089"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a17fa42a0fa50e220db22ae546689ffaf84fd125a041cf5798a20eb4139028f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.16.0/pitboss-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2dfe4d9f567d578d4966e945066c38b13940e7987e60856a17ee1edd92a8137b"
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
