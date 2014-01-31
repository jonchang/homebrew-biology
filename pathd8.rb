require "formula"

class Pathd8 < Formula
  homepage "http://www2.math.su.se/PATHd8/"
  url "http://www2.math.su.se/PATHd8/PATHd8.zip"
  sha1 "c561b43c26a498ec809925010232f18e36209d26"

  def install
    # Build instructions per http://www2.math.su.se/PATHd8/compile.html
    system "cc", "PATHd8.c", "-O3", "-lm", "-o", "PATHd8"
    bin.install "PATHd8"
  end
end
