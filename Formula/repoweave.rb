class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "8b052f8fed4bbd86c439f6390e87ca2ad847fb8ab552a2c886b1b15bc69874a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "1c6b47a0b34a5c6beb06e431c232546e47c8c9278542d5dd1c37330b0d0bcf4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f791bde4a7a222ef4d9cd9e06f01752e2d572e8fab616c2c26416c6f0c74b99d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3e1de841382dce73fce00371eb616acbe7f49fe6730d5e961d007ead247acd1"
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
    bin.install "rwv" if OS.mac? && Hardware::CPU.arm?
    bin.install "rwv" if OS.mac? && Hardware::CPU.intel?
    bin.install "rwv" if OS.linux? && Hardware::CPU.arm?
    bin.install "rwv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
