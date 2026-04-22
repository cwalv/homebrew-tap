class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.4/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "a69d7fd92abfcc40ce50738176d34a65ee4101fe0d395b044237a8c8be541b46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.4/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "f272f5d81612989a2ed9f533a19efc24991dc13e3258cd7a3324005a36184e0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.4/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3b61595eb435bb5e927fa58e388705a9350b5ade2a274a7aeb420f1db5340ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.3.4/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42aba3276a4e48e0642a9f0a88cfa72051daab91a102441c2583caf31fd7e55f"
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
