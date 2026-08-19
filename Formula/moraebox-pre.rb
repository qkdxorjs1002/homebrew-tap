class MoraeboxPre < Formula
  desc "Disposable microVM sandbox for coding agents"
  homepage "https://github.com/qkdxorjs1002/moraebox"
  url "https://github.com/qkdxorjs1002/moraebox/releases/download/0.1.0-alpha3/moraebox-0.1.0-alpha3.tar.gz"
  sha256 "88ca6b98c4fb6d4d6b8f0a4953415e12797cdfb70d5b81bea16ab1275a17e9e7"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on "e2fsprogs"
  depends_on "libkrun"
  depends_on "libkrunfw"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/moraebox-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/moraebox-mcp")
    system "cargo", "install", *std_cargo_args(path: "crates/moraebox-vmm-helper")

    helper = bin/"morae-vmm-helper"
    helper.chmod 0755
    system "/usr/bin/codesign", "--force", "--sign", "-",
           "--entitlements", "assets/moraebox-vmm.entitlements", helper
    system "/usr/bin/codesign", "--verify", "--strict", helper
  end

  def caveats
    <<~EOS
      Homebrew builds moraebox on this Mac and ad-hoc signs the VMM helper
      with its Hypervisor entitlement. The signature does not identify a
      developer and the locally built executable is not Apple-notarized.

      This formula also installs the pinned libkrun 1.19.4 and libkrunfw
      5.5.0 runtime dependencies from this tap. moraebox automatically
      discovers the signed helper and these libraries, so native execution
      requires no shell configuration:

        morae run --image alpine@latest -- /bin/uname -a

      Run `morae doctor --json` to inspect the exact paths and signing gate.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/morae --version")
    assert_equal "morae\n",
                 shell_output("#{bin}/morae run --backend process -- /bin/echo morae")
    assert_match "stdio MCP server", shell_output("#{bin}/morae-mcp --help")
    doctor = JSON.parse(shell_output("#{bin}/morae doctor --json"))
    assert doctor.dig("libkrun", "found")
    assert doctor.dig("libkrunfw", "found")
    assert doctor["native_backend_ready"]
    native_error = shell_output(
      "#{bin}/morae run --backend libkrun -- /bin/true 2>&1", 1
    )
    assert_match "--rootfs, --image, or MORAE_ROOTFS", native_error
    entitlements = shell_output(
      "/usr/bin/codesign -d --entitlements - #{bin}/morae-vmm-helper 2>&1",
    )
    assert_match "com.apple.security.hypervisor", entitlements
  end
end
