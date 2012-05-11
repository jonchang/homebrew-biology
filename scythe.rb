require 'formula'

class Scythe < Formula
  version '0.981'
  homepage 'https://github.com/vsbuffalo/scythe'
  head 'https://github.com/vsbuffalo/scythe.git'
  url 'https://github.com/vsbuffalo/scythe.git', :revision => '5cef1e9a0e3fce8ad9c5f084e88993fde6a3f361'

  def install
    system "make build"
    bin.install "scythe"
  end

  def test
    system "#{bin}/scythe --version"
  end
end
