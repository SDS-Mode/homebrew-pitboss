class PitbossWeb < Formula
  desc "Web operational console for the Pitboss dispatcher"
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.9.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-web-aarch64-apple-darwin.tar.xz"
    sha256 "9dd1a9c1be88b2846d2e8c7af1a1271f4781287ecc2d3878efc3247f1b084c3b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-web-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b418deaf7f8b740df9784468ef1402a089e9e0e41cceb55478cdb11d042bd1ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.9.1/pitboss-web-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e893198a8de198847008b3718d50d66dff8bc5ef2b2329ef445b14b92bd9c9b8"
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
