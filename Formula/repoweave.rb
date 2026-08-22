class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.23.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "134124c7dc226427231c791293a9a12df294472e8e95730773ecbc4188248ad1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.23.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "9249be39434d038430782edf944b8bd5d1f1a3985cb68b62d6a930b3200685cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.23.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "405b584c8f89a460061db9d7638676c6740759ceb7839ffc5b87013fe90c4d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.23.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f950b278753527158c1b57b4f24e9273867d9265c1b34614993d559ce5d202ad"
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
