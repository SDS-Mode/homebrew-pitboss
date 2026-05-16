class PitbossWeb < Formula
  desc "Web operational console for the Pitboss dispatcher"
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.15.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-web-aarch64-apple-darwin.tar.xz"
    sha256 "e2ae7c87972b928cdb57e8758053fc83ab9b7e9c196253b00c7e89c7304b7738"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-web-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf844172e9459034be5e59e8ca40967a5e608394bcc157f7949e4b3cead532a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.15.0/pitboss-web-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76289b13c9c53331ae404aa9dd17488b8b2fa5bcebb8e1ec40dc4874af2620ea"
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
