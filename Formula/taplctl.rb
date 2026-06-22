class Taplctl < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness backed by repo-local SQLite state"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/0.6.4/taplctl-0.6.4-py3-none-any.whl"
  version "0.6.4"
  sha256 "0db60ae89468975e134a813e38d6eb522978a13397c0f8f2c27fd6a08b7c6ad1"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "python@3.12"

  conflicts_with "taplctl-semantic", because: "both install the taplctl executable"

  def install
    wheel = Pathname.glob("*.whl").first
    raise "Could not find taplctl wheel" unless wheel

    venv = virtualenv_create(libexec, "python3.12", system_site_packages: false)
    venv.pip_install_and_link wheel
  end

  service do
    run [opt_bin/"taplctl", "searchd", "run"]
    keep_alive true
  end

  def caveats
    <<~EOS
      Semantic search dependencies are not installed by this formula.
      Install qkdxorjs1002/tap/taplctl-semantic to enable embedding search.
    EOS
  end

  test do
    assert_match(/\Ataplctl \d+\.\d+\.\d+\z/, shell_output("#{bin}/taplctl --version").strip)
    system bin/"taplctl", "install", "repo", "--repo", testpath, "--taplctl-command", bin/"taplctl", "--json"
    assert_path_exists testpath/".codex/hooks.json"
    assert_path_exists testpath/".tapl/config.toml"
    assert_path_exists testpath/".tapl/tapl.db"
  end
end
