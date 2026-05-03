class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.1/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "e4fb1159a615ab828f8e807ea00fdf0cd84ca2459a80927d69835cc9ffeeb36b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.1/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "eb78d1ad6b3c2724548e7c52982e91ccd936535d6a4dac1070abb43e752ad799"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.1/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "78036dbdb9d3a0e3a834f4ea6092f008b498a9ad674c62a152efd07246036c73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.1/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "97282eabfed350ac3c9ebf677590d13ea3ef0fb323b48eb603bfa9d78d48aeb8"
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
