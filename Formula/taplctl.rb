class Taplctl < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness backed by repo-local SQLite state"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-2.27.0-py3-none-any.whl"
  version "2.27.0"
  sha256 "e4b8a247dc62f050144a9716627ba345dd5ae6fdbccbb2854b53b4b8f3dd648f"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "python@3.12"

  conflicts_with "taplctl-pre", because: "both install the taplctl executable"

  # taplctl-mcp-runtime-begin
  on_macos do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-mcp-runtime-2.27.0-macos-arm64.tar.gz"
        sha256 "f0929e7dcb10ec8b53bba656cdd39df5d94c61ef866f6b4c9fad3a34a185a4fd"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-semantic-runtime-2.27.0-macos-arm64.tar.gz"
        sha256 "4923fde9f35c1c2b9825b3ab2b8c99e003792934d20f34abc8868911679e1ef4"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-mcp-runtime-2.27.0-macos-x86_64.tar.gz"
        sha256 "d14ea18ab97b9bbb79e84ae4676f0ac46dd6a42ab56ce09ed32a410baa1184d7"
      end
    end
  end
  on_linux do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-mcp-runtime-2.27.0-linux-arm64.tar.gz"
        sha256 "0dbe6cbb1e586686ed11400ffb244556372c3189b90ada229e165a50084c7b71"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-semantic-runtime-2.27.0-linux-arm64.tar.gz"
        sha256 "c5d7079fa559092a4b0eeba4d74284a74c82cbdb1b99929d35f6fe0f543ce236"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-mcp-runtime-2.27.0-linux-x86_64.tar.gz"
        sha256 "232598060bd688ac247c27ac289610cf8216646194b9279734bec83cf31a8d43"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.0/taplctl-semantic-runtime-2.27.0-linux-x86_64.tar.gz"
        sha256 "d517f83f752e3f7198bd0d41ff839b38963022aa81ed643df387fd086656dd67"
      end
    end
  end

  def semantic_supported?
    return Hardware::CPU.arm? && MacOS.version >= :sonoma if OS.mac?

    quiet_system Formula["python@3.12"].opt_bin/"python3.12", "-c",
                 "import os, sys; v = os.confstr('CS_GNU_LIBC_VERSION').split()[1]; sys.exit(tuple(map(int, v.split('.'))) < (2, 28))"
  end
  # taplctl-mcp-runtime-end

  # Preserve the Developer ID signatures on runtime wheel dylibs.
  preserve_rpath

  def install
    wheel = Pathname.glob("*.whl").first
    raise "Could not find taplctl wheel" unless wheel

    wheelhouse = buildpath/"wheelhouse"
    wheelhouse.mkpath
    resource("mcp-runtime").stage { wheelhouse.install Dir["*.whl"] }
    if semantic_supported?
      resource("semantic-runtime").stage { wheelhouse.install Dir["*.whl"] }
    end

    dependency_wheels = wheelhouse.glob("*.whl")
    raise "Could not find dependency wheels" if dependency_wheels.empty?
    virtualenv_create(libexec, "python3.12", system_site_packages: false)
    system "python3.12", "-m", "pip", "--python=#{libexec}/bin/python", "install",
           "--no-index", "--no-deps", "--no-compile", *dependency_wheels
    system "python3.12", "-m", "pip", "--python=#{libexec}/bin/python", "install",
           "--no-index", "--no-deps", "--no-compile", wheel
    bin.install_symlink libexec/"bin/taplctl"
    bin.install_symlink libexec/"bin/tapl-mcp"
    bin.install_symlink libexec/"bin/tapl-hook"
  end

  # taplctl-service-restart-begin
  def post_install
    if OS.mac?
      quiet_system "/bin/launchctl", "kill", "SIGTERM", "gui/#{Process.uid}/#{plist_name}"
    elsif OS.linux?
      systemctl = which("systemctl")
      if systemctl
        quiet_system systemctl, "--user", "daemon-reload"
        quiet_system systemctl, "--user", "try-restart", service_name
      end
    end
  end
  # taplctl-service-restart-end

  service do
    run [opt_bin/"taplctl", "viewer"]
    keep_alive true
    restart_delay 5
    log_path var/"log/taplctl-viewer.log"
    error_log_path var/"log/taplctl-viewer.log"
  end

  test do
    # taplctl-mcp-smoke-begin
    assert_path_exists bin/"tapl-mcp"
    assert_path_exists bin/"tapl-hook"
    system libexec/"bin/python", "-c",
           "from mcp.server import MCPServer; from taplctl.mcp_server import create_server; assert create_server()"
    if semantic_supported?
      system libexec/"bin/python", "-c", "import numpy, onnxruntime, sqlite_vec, tokenizers"
    end
    # taplctl-mcp-smoke-end

    assert_match(/\Ataplctl \d+\.\d+\.\d+(?:(?:a|b|rc)\d+)?\z/, shell_output("#{bin}/taplctl --version").strip)
    system bin/"taplctl", "install", "repo", "--repo", testpath, "--taplctl-command", bin/"taplctl", "--json"
    assert_path_exists testpath/".codex/hooks.json"
    assert_path_exists testpath/".tapl/config.toml"
    assert_path_exists testpath/".tapl/tapl.db"
  end
end
