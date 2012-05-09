require 'formula'

class Scythe < Formula
  homepage 'https://github.com/vsbuffalo/scythe'
  head 'https://github.com/vsbuffalo/scythe.git'

  def install
    system "make build"
    bin.install "scythe"
  end

  def test
    system "make test"
  end
end
