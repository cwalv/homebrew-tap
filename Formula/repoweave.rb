class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.1/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "f628e4f9a3c600f585047d25103f25c1bdbc261ccbfd9f99b3ef5daa887267d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.1/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "eb576f033e39057dd075846e5c3e6acaa32de7039da050d9e8b54d8ec43c10f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.1/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6389c413f5784c780f8f8f2d0e1395945a204d8ef746ecc4fc7db05abba960c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.1/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9723f5cee1691f0ac84cd6d6a7b2ff5a36e02999609478aa22616ce103fac53"
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
