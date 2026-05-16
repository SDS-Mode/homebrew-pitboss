class PitbossTui < Formula
  desc "TUI companion for pitboss — live tile grid, log tailing, budget counters."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.15.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-tui-aarch64-apple-darwin.tar.xz"
    sha256 "fd4ab35cb06e104613bda94d792bd9da6af6c8babc54f087d1d25c06f003ae3b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a2ff1297c0beb328756b087dd2df2b06bee26c56e28a3db0dd0e57b760028a8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6af31296f7930e515f2e502df2da343b0f159537cb5702aa79f0ef4b0e73ba5"
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
