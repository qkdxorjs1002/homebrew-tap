cask "anisched" do
    version "3.0.2"
    sha256 "4df743085d050c4b6414f5f29381c55a259c6c701de072ef9b0394067f8b1758"
  
    url "https://github.com/qkdxorjs1002/AniSched-Desktop/releases/download/#{version}/AniSched.#{version}.dmg"
    name "AniSched"
    desc "Animation TimeTable app for macOS"
    homepage "https://github.com/qkdxorjs1002/AniSched-Desktop"
  
    livecheck do
      url :url
      strategy :github_latest
    end
  
    app "AniSched.app"
  
    zap trash: [
      "~/Library/Containers/kr.paragonnov.anisched"
    ]
end
