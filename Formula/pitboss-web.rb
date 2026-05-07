class PitbossWeb < Formula
  desc "Web operational console for the Pitboss dispatcher"
  homepage "https://github.com/SDS-Mode/pitboss"
  version "0.12.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/SDS-Mode/pitboss/releases/download/v0.12.0/pitboss-web-aarch64-apple-darwin.tar.xz"
    sha256 "4a57ddf8c477685dc6bbfa3797b834896dad938e660327935085c37bbe2a699f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.12.0/pitboss-web-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c7983ee5497470c5bf2529b139b8a8024fcdd95cbc12da7bb394d5e101a882c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SDS-Mode/pitboss/releases/download/v0.12.0/pitboss-web-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69b8aca9395e101d7df75c24241a9ac994a0a47e8f6a7f4fd8d1de1dc0c38912"
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
