require "formula"

class R8s < Formula
  homepage "http://loco.biosci.arizona.edu/r8s/"
  version "1.8"
  url "http://loco.biosci.arizona.edu/r8s/r8s.dist.tgz"
  sha1 "c909c1e83ad2a0fbd683db4e8c42caa0868f18fd"

  depends_on :fortran

  def install
    inreplace "makefile" do |s|
      s.change_make_var! "LPATH", "-L#{Formula['gfortran'].opt_prefix}/gfortran/lib"
    end
    system "make"
    bin.install "r8s"
  end

  def caveats
    'This formula requires a brewed gfortran.'
  end
end
