class PitbossWeb < Formula
  desc "Web operational console for the Pitboss dispatcher"
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.13.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-web-aarch64-apple-darwin.tar.xz"
    sha256 "e494acf0479fb95c6268f163f72ff82282b93f3d74c7a4a14facb247ed09ff47"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-web-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49c8cffa10c7818b5101cd5ce02346a5b40a79fe9e38b4a94b9692491892cfe6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.13.0/pitboss-web-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "97338cef6f19c7e6f9132b6d0dac7171fb6e3175a4a757a9fc0c359f1a1fc4e0"
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
