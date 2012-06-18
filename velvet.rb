require 'formula'

class Velvet < Formula
  version '1.2.05'
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  # doesn't seem to have stable tarballs
  url 'https://github.com/dzerbino/velvet.git', :revision => 'aeb11f8058e4ea794a6ec425c168ffcbbfd1bbbc'
  head 'https://github.com/dzerbino/velvet.git'

  # patch per comment in Makefile
  def patches
    DATA
  end

  def install
    # don't make docs because it requires pdflatex
    system "make cleanobj zlib obj velveth velvetg MAXKMERLENGTH=96"
    bin.install 'velveth', 'velvetg'
  end

  def test
    system "#{bin}/velveth"
  end
end
__END__
diff --git a/Makefile b/Makefile
index 5d91631..640cdca 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ CATEGORIES=2
 DEF = -D MAXKMERLENGTH=$(MAXKMERLENGTH) -D CATEGORIES=$(CATEGORIES)
 
 # Mac OS users: uncomment the following lines
-# CFLAGS = -Wall -m64
+CFLAGS = -Wall -m64
 
 # Sparc/Solaris users: uncomment the following line
 # CFLAGS = -Wall -m64
