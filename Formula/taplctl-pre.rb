class TaplctlPre < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness backed by repo-local SQLite state"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/2.4.2/taplctl-2.4.2-py3-none-any.whl"
  version "2.4.2"
  sha256 "2210672cd0a6378c69459dd7facb24796c785a0dc5b85fb24ca86e3eb181657a"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "python@3.12"

  conflicts_with "taplctl", because: "both install the taplctl executable"
  conflicts_with "taplctl-semantic", because: "both install the taplctl executable"

  # taplctl-mcp-runtime-begin
  on_macos do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.4.2/taplctl-mcp-runtime-2.4.2-macos-arm64.tar.gz"
        sha256 "c2fb502005a367c691f29aa91b35df375a3cd50229603f20b05d6caf19518926"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.4.2/taplctl-mcp-runtime-2.4.2-macos-x86_64.tar.gz"
        sha256 "d12ade4be27d1b3af82af564e42db6993bee5f1cb01904184e67e461b530b631"
      end
    end
  end
  on_linux do
    on_arm do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.4.2/taplctl-mcp-runtime-2.4.2-linux-arm64.tar.gz"
        sha256 "4aee9040935f1ec3e178fd1b42d860c79fcaf78f280f97374918e67d4d6c0ef0"
      end
    end
    on_intel do
      resource "mcp-runtime" do
        url "https://github.com/qkdxorjs1002/tapl/releases/download/2.4.2/taplctl-mcp-runtime-2.4.2-linux-x86_64.tar.gz"
        sha256 "bb227321a282485fc823f6f21fb253f9339b8086f2d570b89f316d138b7d395c"
      end
    end
  end
  # taplctl-mcp-runtime-end

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
