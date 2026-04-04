# typed: false
# frozen_string_literal: true

class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://github.com/cwalv/repoweave"
  license "MIT"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "d2ee9b773fdf0b5b94ad6734dc4293e713a58bb38d8100082b51a9bf4f9a1f0f"
    end

    on_intel do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "af1434b08577036364ad5dbdacd0a8f20259eb44c603598706fbad3eef5c4ac3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0d5b045e29f2131997ff0a375dbc15a7793c6ba61ee81f5dc756be6282b23d8"
    end

    on_intel do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e96cd7240c28bf362a18c46d5505787662a63d8e1163ca8f20512a330d6e1009"
    end
  end

  def install
    # cargo-dist archives contain a directory named repoweave-<target>/
    # with the binary inside. Find the rwv binary regardless of directory name.
    binary = Dir["**/rwv"].first
    if binary
      bin.install binary
    else
      odie "Could not find rwv binary in archive"
    end
  end

  test do
    assert_match "repoweave", shell_output("#{bin}/rwv --version")
  end
end
