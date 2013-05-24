require 'formula'

class KentTools < Formula
  homepage 'http://genome.ucsc.edu/'
  version '283'
  # No stable tarballs, so using tags instead
  url 'git://genome-source.cse.ucsc.edu/kent.git', :tag => 'v283_base'
  head 'git://genome-source.cse.ucsc.edu/kent.git'

# fails_with :clang do
#    build 421
#  end

  depends_on :libpng
  depends_on :mysql

  def install
    ENV.deparallelize
    # Set up build environment per src/product/README.building.source
    ENV['PNGLIB'] = "-L#{MacOS::X11.lib}"
    ENV['PNGINCL'] = "-I#{MacOS::X11.include}"

    # Need to use mysql_config --variable=xyz because the various Makefiles
    # prepend -I, -L flags to these environment variables.
    mysql = Formula.factory 'mysql'
    mysql_config = which 'mysql_config' || "#{mysql.bin}/mysql_config"
    ENV['MYSQLLIBS'] = "-lmysqlclient -lz"
    ENV['MYSQLINC'] = `#{mysql_config} --variable=pkgincludedir`.strip

    bin.mkdir
    ENV['MACHTYPE'] = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    ENV['BINDIR'] = ENV['SCRIPTS'] = bin

    system 'cd src; make userApps'
  end

  def caveats; <<-EOS.undent
    This formula will only install the standalone tools located at
      http://hgdownload.cse.ucsc.edu/admin/exe/
    EOS
  end

  def test
    mktemp do
      Pathname.new('test.fa').write <<-EOF.undent
        >test
        ACTG
      EOF
      system "#{bin}/faOneRecord test.fa test > out.fa"
      compare_file 'test.fa', 'out.fa'
    end
  end
end
