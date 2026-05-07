class PitbossWeb < Formula
  desc "Web operational console for the Pitboss dispatcher"
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.11.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-web-aarch64-apple-darwin.tar.xz"
    sha256 "dbdeb21710268b225fa21b31859a147060baaf347a983aa3bdb00125ee54d3b1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-web-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1563e7cd6f83a4761d7ba615cba4e3a52bf4e0449ee23219ac9a2bb18bb7387a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.11.0/pitboss-web-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "115e4cef11fbb31f4b19c0e48174b7052769121b7adf622dbd21b9f61673af26"
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
    bin.install "pitboss-web" if OS.mac? && Hardware::CPU.arm?
    bin.install "pitboss-web" if OS.linux? && Hardware::CPU.arm?
    bin.install "pitboss-web" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
