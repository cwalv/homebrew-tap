class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.19.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.19.1/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "4b62e1960e02a6e8ec40ea9684202186992f12c2cf7799fa82b6b2f886003e23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.19.1/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "cd73a2e193413ebc6bfe5c6274e9ef955601aafe2223cdf481f44c9719294842"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.19.1/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88d2d78e9820e9fbab9f96a5704d6465a39cc37fb737b12f397a2afe67ad3ca5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.19.1/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d58d9c5a7c56a5ae083632158fa22c57b79b47f8ae0d73d891a5cfcb18b76d55"
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
