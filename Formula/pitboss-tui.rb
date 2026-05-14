class PitbossTui < Formula
  desc "TUI companion for pitboss — live tile grid, log tailing, budget counters."
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.14.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.14.0/pitboss-tui-aarch64-apple-darwin.tar.xz"
    sha256 "0b9fb132818ece32518b338f3e45e8d46bab47e75e70e6e27fafca069a638855"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.14.0/pitboss-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "495b233b48872142d24dbe78b5f2313b676ad9e70e6b4729ad1e5b9fba7abe20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.14.0/pitboss-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "df61c7e5474cd1a97ec75ce77c422ca1356c5493555569da861a23b8c09b5cf9"
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
