class Beast2 < Formula
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "http://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.4.3.tar.gz"
  sha256 "aa684f57ec38b51a00dcf20c16a0835de0e3920e55ba811e126ed98f6b182df1"
  head "https://github.com/CompEvol/beast2.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1003537"

  depends_on :ant => :build
  depends_on :java => "1.8+"

  def patches
    # Homebrew renames the unpacked source folder, but build.xml
    # assumes that it won't be renamed.
    DATA
  end

  def install
    system "ant", "linux"
    cd "release/Linux/beast" do
      inreplace Dir["bin/*"] do |s|
        s["$BEAST/lib"] = "$BEAST/libexec"
      end

      Dir["bin/*"].each do |f|
        mv f, f + "-2"
      end

      mv "lib", "libexec"
      prefix.install Dir["*"]
    end
  end

  def caveats; <<-EOS.undent
    This install coexists with BEASTv1 as all scripts are suffixed with '-2':

        beast-2 -help
  EOS
  end

  test do
    system "beast-2", "-help"
  end
end
__END__
diff --git a/build.xml b/build.xml
index 420fe49..64b8bc5 100644
--- a/build.xml
+++ b/build.xml
@@ -8,12 +8,12 @@
     </description>
 
     <!-- set global properties for this build -->
-    <property name="src" location="../beast2/src" />
-    <property name="build" location="../beast2/build" />
-    <property name="lib" location="../beast2/lib" />
-    <property name="doc" location="../beast2/doc" />
-    <property name="dist" location="../beast2/build/dist" />
-    <property name="test" location="../beast2/test" />
+    <property name="src" location="src" />
+    <property name="build" location="build" />
+    <property name="lib" location="lib" />
+    <property name="doc" location="doc" />
+    <property name="dist" location="build/dist" />
+    <property name="test" location="test" />
 
     <property name="main_class_BEAST" value="beast.app.beastapp.BeastMain" />
     <property name="report" value="build/junitreport" />
@@ -161,7 +161,7 @@
         <mkdir dir="${release_dir}/package/lib" />
         <copy file="${dist}/beast.src.jar" todir="${release_dir}/package/"/>
         <copy file="${dist}/beast.jar" todir="${release_dir}/package/lib/"/>
-        <copy file="../beast2/version.xml" todir="${release_dir}/package/"/>
+        <copy file="version.xml" todir="${release_dir}/package/"/>
 
         <jar jarfile="${release_dir}/package/BEAST.addon.v${version}.zip">
             <fileset dir="${release_dir}/package">
@@ -465,11 +465,10 @@
         
         <echo message="cd release/Linux"/>
         <echo message="tar fcz BEAST.v${version}.tgz beast"/>
-        <echo message="cp BEAST.v${version}.tgz ~/tmp"/>
     </target>
 
     <!-- Define the appbundler task -->
-    <taskdef name="bundleapp" classname="com.oracle.appbundler.AppBundlerTask" classpath="../beast2/lib/bundler/appbundler-1.0.jar"/>
+    <taskdef name="bundleapp" classname="com.oracle.appbundler.AppBundlerTask" classpath="lib/bundler/appbundler-1.0.jar"/>
 
     <!--property name="AppleSigner" value="Developer ID Application: Alexei Drummond (6M6Y6L7RUP)" /-->
     <property name="AppleSigner" value="Developer ID Application: Remco Bouckaert (LHFJWE5U63)" />    
