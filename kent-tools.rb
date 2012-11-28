require 'formula'

class KentTools < Formula
  homepage 'http://genome.ucsc.edu/'
  # HEAD-only because there are no stable tarballs
  head 'http://hgdownload.cse.ucsc.edu/admin/jksrc.zip'
  devel do
    url 'git://genome-source.cse.ucsc.edu/kent.git' # incredibly slow
  end

  fails_with :clang do
    build 421
  end

  depends_on :libpng
  depends_on 'mysql'

  def install
    # Set up build environment per src/product/README.building.source
    ENV['PNGLIB'] = "-L#{MacOS::X11.lib}"
    ENV['PNGINCL'] = "-I#{MacOS::X11.include}"

    mysql = Formula.factory 'mysql'
    ENV['MYSQLLIBS'] = "#{mysql.lib}/libmysqlclient.a -lz"
    ENV['MYSQLINC'] = mysql.include

    ENV['MACHTYPE'] = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    bin.mkdir
    ENV['BINDIR'] = ENV['SCRIPTS'] = bin

    system 'cd src; make userApps'
  end

  def caveats; <<-EOS.undent
    This formula will only install the standalone tools located at
      http://hgdownload.cse.ucsc.edu/admin/exe/
    EOS
  end
end
