require "formula"

class Beast2 < Formula
  homepage "http://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.1.1.tar.gz"
  sha1 "6b97d7bfd1428c4024cf3ddd5a2d62f63b50f721"
  head "https://github.com/CompEvol/beast2.git"

  depends_on :ant => :build

  def patches
    # Homebrew renames the unpacked source folder, but build.xml
    # assumes that  it won't be renamed.
    DATA
  end

  def install
    system "ant", "linux"
    cd 'release/Linux/BEAST' do
      inreplace Dir["bin/*"] do |s|
        s['$BEAST/lib'] = '$BEAST/libexec'
      end

      Dir['bin/*'].each do |f|
        mv f, f + "-2"
      end

      mv 'lib', 'libexec'
      prefix.install Dir["*"]
    end
  end

  def caveats; <<-EOS.undent
    This installation can coexist with other installs of BEAST.
    All scripts are suffixed with '-2':

        beast-2 -help
  EOS
  end

  test do
    system "beast-2", "-help"
  end
end
__END__
diff --git a/build.xml b/build.xml
index 1940dcc..efde88b 100644
--- a/build.xml
+++ b/build.xml
@@ -8,11 +8,11 @@
 	</description>
 
 	<!-- set global properties for this build -->
-	<property name="src" location="../beast2/src" />
-	<property name="build" location="../beast2/build" />
-	<property name="lib" location="../beast2/lib" />
-	<property name="doc" location="../beast2/doc" />
-	<property name="dist" location="../beast2/build/dist" />
+	<property name="src" location="src" />
+	<property name="build" location="build" />
+	<property name="lib" location="lib" />
+	<property name="doc" location="doc" />
+	<property name="dist" location="build/dist" />
 
 	<property name="main_class_BEAST" value="beast.app.beastapp.BeastMain" />
 	<property name="report" value="build/junitreport" />
