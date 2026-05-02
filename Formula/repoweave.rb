class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "c906cba4ddc1164cecb602f9e240ba3a5064673aaeb92579c17b5e38353802e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "17a50fb68f1c00915a2d513f0aadf2438c8ed90ebbac14af7a91810bc8ede484"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51c57fead6e431b8fab270ba52f1b32704790a962e0f4b70fa59af196d45ebdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.4.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8791e1817276b19fa04af157947486d3acdf0c49a24aec5f9b0268f491c8d9ad"
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
