class TaplctlPre < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness backed by repo-local SQLite state"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-2.27.1-py3-none-any.whl"
  version "2.27.1"
  sha256 "9720cf637140aa8c1957529f89136e3a1e8a40bdeab9ad0e9d1f7c101ea048ae"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "python@3.12"

  conflicts_with "taplctl", because: "both install the taplctl executable"

  # taplctl-mcp-runtime-begin
  on_macos do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-mcp-runtime-2.27.1-macos-arm64.tar.gz"
        sha256 "22c583e9aa8ddf432581a66e27c4bfb008b10709fd176b0a7f52c10ba303ab09"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-semantic-runtime-2.27.1-macos-arm64.tar.gz"
        sha256 "89db99506ed25807920ece1ebc7d36f227dddaef1e256e4101a9a81320e87068"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-mcp-runtime-2.27.1-macos-x86_64.tar.gz"
        sha256 "9f7149edec802e4d170e14e34d461504d1c98402786a3b594a276bad2aa2ea50"
      end
    end
  end
  on_linux do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-mcp-runtime-2.27.1-linux-arm64.tar.gz"
        sha256 "0dbe6cbb1e586686ed11400ffb244556372c3189b90ada229e165a50084c7b71"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-semantic-runtime-2.27.1-linux-arm64.tar.gz"
        sha256 "c5d7079fa559092a4b0eeba4d74284a74c82cbdb1b99929d35f6fe0f543ce236"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-mcp-runtime-2.27.1-linux-x86_64.tar.gz"
        sha256 "232598060bd688ac247c27ac289610cf8216646194b9279734bec83cf31a8d43"
      end
      resource "semantic-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.27.1/taplctl-semantic-runtime-2.27.1-linux-x86_64.tar.gz"
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
