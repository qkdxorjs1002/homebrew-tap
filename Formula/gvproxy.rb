class Gvproxy < Formula
  desc "User-mode network stack for virtual machines"
  homepage "https://github.com/containers/gvisor-tap-vsock"
  url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "6cbcb7959a5d90b59253ea6d8bdf0285e2cfbc3b301398704b41e3069293f4fb"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "gvproxy", "GIT_VERSION=v#{version}"
    bin.install "bin/gvproxy"
  end

  test do
    assert_match "gvproxy version v#{version}",
                 shell_output("#{bin}/gvproxy --version")
  end
end
