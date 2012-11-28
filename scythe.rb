require 'formula'

class Scythe < Formula
  version '0.981'
  homepage 'https://github.com/vsbuffalo/scythe'
  url 'https://github.com/vsbuffalo/scythe.git',
      :revision => '872a54c996a1a9f5b3f5210d92bcbd8d7efcaa04'
  head 'https://github.com/vsbuffalo/scythe.git'

  def install
    system 'make build'
    bin.install 'scythe'
  end

  def test
    system "#{bin}/scythe --version"
  end
end
