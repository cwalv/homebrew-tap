class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "fb3b5fecb59d633054fe73803c0f3a6e20b9eabfaf2d35151a232cfd54d6ef5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "872947cf90927128baea762504c5e4541f7a56aec97d9a5c48d1ab9c99b38ced"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a219a34fdafead1f397f3f84f4bd62818e9f8cc3a3df07bf747850872a7fe2b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.12.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3fbd69b19bea3e373ebc773f32b7dd36b01830bf8f4b8f6fd39e17dc2212e7f"
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
