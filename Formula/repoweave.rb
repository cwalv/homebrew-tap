class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.24.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "f4d5697fcb6a515aab6a9b89fce13688c49950d24dc8cbb6b161ebd5d727516a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.24.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "d928ed986adebac22b1b39ac05e4f443fc5262b4c542e78b0d6e1dc73fff9561"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.24.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "320e769dd3eb72fc4af6e80e5a91448636f1f71afbc9e667238e757df3f3f742"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.24.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68d5e2a55dc624936ea777ff03d5e547bb6e601825e79cbcc552fca240598914"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "generate-explain", "rwv"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "generate-explain", "rwv"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "generate-explain", "rwv"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "generate-explain", "rwv"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
