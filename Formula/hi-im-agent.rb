# frozen_string_literal: true

# Homebrew package for the hi-im-agent CLI.
class HiImAgent < Formula
  desc "Personal MCP-to-A2A bridge for collaborating coding agents"
  homepage "https://github.com/qkdxorjs1002/hi-im-agent"
  version "0.1.0-alpha1"

  depends_on "node@22"

  on_macos do
    on_arm do
      url "https://github.com/qkdxorjs1002/hi-im-agent/releases/download/0.1.0-alpha1/hi-im-agent-0.1.0-alpha1-macos-arm64.tar.gz"
      sha256 "ed88afc68b3007a880ae693fdb90218c971a7338c19e3099b9efbbf62e6295a5"
    end
    on_intel do
      url "https://github.com/qkdxorjs1002/hi-im-agent/releases/download/0.1.0-alpha1/hi-im-agent-0.1.0-alpha1-macos-x86_64.tar.gz"
      sha256 "54fc01c373842ecff0031e995fe8a3c461b5ec1ffe46cb533965c21185720813"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qkdxorjs1002/hi-im-agent/releases/download/0.1.0-alpha1/hi-im-agent-0.1.0-alpha1-linux-arm64.tar.gz"
      sha256 "33c5c9f74ad1c59cb409e869cde2a77ff2eac51062ff328429da67c566f26fbd"
    end
    on_intel do
      url "https://github.com/qkdxorjs1002/hi-im-agent/releases/download/0.1.0-alpha1/hi-im-agent-0.1.0-alpha1-linux-x86_64.tar.gz"
      sha256 "fa9b5687742865718488fede53908ccbd904edecfd636f9c9078be640344dc83"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"hiim").write_env_script formula_opt_bin("node@22")/"node", [libexec/"dist/cli/index.js"], {}
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hiim --version")
  end
end
