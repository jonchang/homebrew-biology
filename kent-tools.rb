require 'formula'

class KentTools < Formula
  homepage 'http://genome.ucsc.edu/'
  url 'http://hgdownload.cse.ucsc.edu/admin/jksrc.v269.zip'
  head 'git://genome-source.cse.ucsc.edu/kent.git' # incredibly slow
  sha1 'd0920d5eb17d7a7b8428547c93c8170831f76b87'

  # don't install things that depend on mysql
  def patches
    DATA
  end

  def install
    # libpng needs special handling
    ENV.libpng
    ENV['PNGLIB'] = '-L/usr/X11/lib'
    ENV['PNGINCL'] = '-I/usr/X11/include'

    # set up build environment
    ENV['MACHTYPE'] = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    mkdir "#{bin}"
    ENV['BINDIR'] = ENV['SCRIPTS'] = "#{bin}"

    system 'cd kent/src/lib; make'
    system 'cd kent/src/jkOwnLib; make'
    system 'cd kent/src/utils; make all'
  end
end
__END__
diff --git a/kent/src/utils/makefile b/kent/src/utils/makefile
index 90b756a..3bd35f5 100644
--- a/kent/src/utils/makefile
+++ b/kent/src/utils/makefile
@@ -124,16 +124,13 @@ DIRS = \
 	nibSize \
 	nt4Frag \
 	paraFetch \
-	pslLiftSubrangeBlat \
 	pslToPslx \
 	pslToXa \
 	randomLines \
-	raSqlQuery \
 	raToTab \
 	raToLines \
 	rmFaDups \
 	rowsToCols \
-	scaffoldFaToAgp \
 	scrambleFa \
 	sizeof \
 	spacedToTab \
@@ -144,7 +141,6 @@ DIRS = \
 	subColumn \
 	subs \
 	tableSum \
-	tailLines \
 	textHist2 \
 	textHistogram \
 	tickToDate \
@@ -158,7 +154,6 @@ DIRS = \
 	upper \
 	venn \
 	verticalSplitSqlTable \
-	weedLines \
 	wigCorrelate \
 	wigToBigWig \
 	wigTestMaker \

