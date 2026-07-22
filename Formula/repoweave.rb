class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.15.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "3ed43caea0dc572b7bc3bcf613a841f53a0928acaf14035609189b01a0d12e6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.15.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "e7da474a3512fdda7fd57926bd00a7b14cd78b20903a1bdc19a488d80cfb4345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.15.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f951dfeede7277f1f05f63214514a901b18f6e2389a1b534d8ff8a95a3ebf5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.15.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cad4d445f2c5c751c3122ac33cdd0594b4190c6ed400e07d75a99059b472899b"
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
