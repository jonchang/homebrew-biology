require "formula"

class Phlawd < Formula
  homepage "http://phlawd.net/"
  sha1 "cc55ffe988e55f5cf35d5619819a1e2a29997e5e"
  head "https://github.com/chinchliff/phlawd.git"

  depends_on "sqlite"
  depends_on "homebrew/science/quicktree"
  depends_on "homebrew/science/mafft"
  depends_on "homebrew/science/muscle"

  fails_with :clang do
    cause "phlawd requires openMP support"
  end

  def patches
    # Enable daily updates
    "https://github.com/chinchliff/phlawd/pull/8.diff"
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.MAC"
      bin.install "PHLAWD"
    end
  end

  def caveats; <<-EOS.undent
    phlawd is HEAD-only because the last release version is many years
    out of date.
    EOS
  end

  test do
    system "#{bin}/PHLAWD"
  end
end
