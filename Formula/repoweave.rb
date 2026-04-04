# typed: false
# frozen_string_literal: true

class Repoweave < Formula
  desc "A cross-repo workspace manager"
  homepage "https://github.com/cwalv/repoweave"
  license "MIT"
  version "0.1.0"

  # TODO: Replace placeholder SHAs with real values from the first release.
  # Run: shasum -a 256 repoweave-<target>.tar.xz
  # for each downloaded archive to obtain the correct digests.

  on_macos do
    on_arm do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-aarch64-apple-darwin.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # placeholder
    end

    on_intel do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-x86_64-apple-darwin.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # placeholder
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # placeholder
    end

    on_intel do
      url "https://github.com/cwalv/repoweave/releases/download/v#{version}/repoweave-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # placeholder
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
