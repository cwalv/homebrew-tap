class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.6.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "519afa8b1ac2b430829001c53718e274c13e76dfc802d8f83d190755dc26e6f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.6.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "26884f59f3b412068e765ae591c3de293bd3680e6f1911bfe6c5061b5fe67fb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.6.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00dc5b0f89c7b1281492909828f46d90d300f16caa6905c18380944504b418ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.6.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3de9a540047f83a0f19da789156ba7ce69e321addc8e3a317805832360ba42e0"
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
