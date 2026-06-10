class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.7.2/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "c41527ced2c0d2eb76eeed5d0ed6802ac5bcbdfba7d5f7de81d4ad8a1d4bd5dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.7.2/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "810236534d7844b7c270720c66825016c9ac66e27a35aa347fd33326d3c8e8d4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.7.2/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfb5e28162aa8d9408fd9c934001cc89708650a11f567f07a20e992f8ed9e540"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.7.2/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "123672bfdf37f35b693bc1b2b2b2e341960f7fd74380921f0b25fa1a35e13741"
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
    bin.install "generate-explain", "rwv" if OS.mac? && Hardware::CPU.arm?
    bin.install "generate-explain", "rwv" if OS.mac? && Hardware::CPU.intel?
    bin.install "generate-explain", "rwv" if OS.linux? && Hardware::CPU.arm?
    bin.install "generate-explain", "rwv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
