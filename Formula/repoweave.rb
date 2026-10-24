class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://cwalv.github.io/repoweave/"
  version "0.25.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.25.0/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "54de0ccebc27d149e626067bdd4e3bc9e480a4718eebc8542230d309997db477"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.25.0/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "6d192a5136a9453f49177e4e61051213dc4be36bc731ac34051e10a3b84fe316"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cwalv/repoweave/releases/download/v0.25.0/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d3af57b51fbf76ee162728d0e64c3fe3862e480306a93454e2a87ecaba02e47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cwalv/repoweave/releases/download/v0.25.0/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb93eb4cce53d074ee7be5aac85eac85b81a95645b947f90e6a803b581c9e98c"
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
      bin.install "rwv", "rwv-each"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rwv", "rwv-each"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rwv", "rwv-each"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rwv", "rwv-each"
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
