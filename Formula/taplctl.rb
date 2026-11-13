class Taplctl < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness backed by repo-local SQLite state"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/2.21.2/taplctl-2.21.2-py3-none-any.whl"
  version "2.21.2"
  sha256 "46305e9b6d09c368169cff8ec98f4063c9383e8fdb6d72d439135e1298dc246a"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "python@3.12"

  conflicts_with "taplctl-semantic", because: "both install the taplctl executable"
  conflicts_with "taplctl-pre", because: "both install the taplctl executable"

  # taplctl-mcp-runtime-begin
  on_macos do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.21.2/taplctl-mcp-runtime-2.21.2-macos-arm64.tar.gz"
        sha256 "3d7e397b1ad5016a7aef32b804bc3f17c3e25f8066bbf9109364d408034c0f03"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.21.2/taplctl-mcp-runtime-2.21.2-macos-x86_64.tar.gz"
        sha256 "a5acb778f4778e13d2093e9421b286b28fa6aa02edfe9515ff22a04cade1be47"
      end
    end
  end
  on_linux do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.21.2/taplctl-mcp-runtime-2.21.2-linux-arm64.tar.gz"
        sha256 "5f2924b427540de1ae3f6ea28a0ab0c69fd809a42a41caa9fbac96cc91129f79"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.21.2/taplctl-mcp-runtime-2.21.2-linux-x86_64.tar.gz"
        sha256 "eec0a56b1e0bc74f387f1d33d450f9a314bab60408ec7e584e1e0086c08659d4"
      end
    end
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
    runtime_packages = wheelhouse.glob("*.whl").map do |runtime_wheel|
      runtime_wheel.basename.to_s.split("-", 2).first.tr("_", "-").downcase
    end
    resources.each do |resource|
      next if resource.name == "mcp-runtime"
      next if runtime_packages.include?(resource.name.tr("_", "-").downcase)

      resource.stage { wheelhouse.install Dir["*.whl"] }
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

  def caveats
    <<~EOS
      Semantic search dependencies are not installed by this formula.
      Install qkdxorjs1002/tap/taplctl-semantic to enable embedding search.
    EOS
  end

  test do
    # taplctl-mcp-smoke-begin
    assert_path_exists bin/"tapl-mcp"
    assert_path_exists bin/"tapl-hook"
    system libexec/"bin/python", "-c",
           "from mcp.server import MCPServer; from taplctl.mcp_server import create_server; assert create_server()"
    # taplctl-mcp-smoke-end

    assert_match(/\Ataplctl \d+\.\d+\.\d+(?:(?:a|b|rc)\d+)?\z/, shell_output("#{bin}/taplctl --version").strip)
    system bin/"taplctl", "install", "repo", "--repo", testpath, "--taplctl-command", bin/"taplctl", "--json"
    assert_path_exists testpath/".codex/hooks.json"
    assert_path_exists testpath/".tapl/config.toml"
    assert_path_exists testpath/".tapl/tapl.db"
  end
end
