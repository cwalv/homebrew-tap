class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.21.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.21.1/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "b561beddd973234abd76b0031ef7e041d64dfcdb13eba9e63cfbb14adc2a4f24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.21.1/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "38d7a38f43d2ff522878ff0a8b708c42e6a7af4280df67263dae4df7b79548b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.21.1/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b63f8f0f4966360990145cdc09ccbe39cbd4d78a123879856e66a486b70d260"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.21.1/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "daf8f705e90739a2fea0f86b6fb2513756459963dd6d2ef5459af3fea0f5cf8e"
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
