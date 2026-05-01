class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.5/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "aa638a047d998138b11ce41994bfbd8b8e31ae4a5b7e152c36c7db0108ba25bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.5/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "4009ec6bb752c708de8f8a4543d612c886ab281fc50bfa2591eb94525e9c01d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.5/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ab47889780089ebf87b1165154aca362ecb43792f409a1fa51f059084e323bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.5/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a38c3185af5f3aa4d61589a8e41184bd30edda0dbdb0c27e1b3ca93cb4c554fd"
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
