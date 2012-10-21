require 'formula'

class Velvet < Formula
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.08.tgz'
  sha1 'cef486759fa577d86ff67d70898ff330f5d0403c'
  head 'https://github.com/dzerbino/velvet.git'

  # patch per comment in Makefile
  def patches
    DATA
  end

  def install
    # don't make docs because it requires pdflatex
    system "make velveth velvetg MAXKMERLENGTH=96"
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
