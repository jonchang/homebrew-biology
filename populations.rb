require 'formula'

class Populations < Formula
  homepage 'http://bioinformatics.org/~tryphon/populations/'
  url 'http://www.bioinformatics.org/download/populations/populations-1.2.30.tar.gz'
  sha1 'f7a5afdeebb55bee4fad9c6fa0f21b3128b39ee7'

  depends_on 'gettext'

  def install
    gettext = Formula.factory 'gettext'
    ENV.append 'CPPFLAGS', "-I#{gettext.include}"
    ENV.append 'LDFLAGS', "-I#{gettext.lib} -lintl"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "echo 0 | #{bin}/populations"
  end
end
