class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.18.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "0ff49da34af05ee95d00385d6c7c8fb707df627aff0ff4407f1b3a06b747d776"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.18.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "6a964a3bea3e51342d704023b5b25a5645d41fdaef731bb2b82c25c83304137e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.18.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8121279dd8546c0c412df500a1acf3e76ab1579c675d96e3f108f0295a3166c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.18.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "474937aac62db1c3f6ea069543bf5fd524aeffb6d180678aea9d2fdb2e55c705"
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
