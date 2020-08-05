class Eems < Formula
  desc "Estimating Effective Migration Surfaces"
  homepage "https://github.com/dipetkov/eems"
  url "https://github.com/dipetkov/eems.git", revision: "42bc6c7379295b91f38eedf0a3723e1bf3cf4264"
  version "2018.09.17"
  revision 2
  head stable.url

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "e9f69c5adabbb3c14b2c0bfa2a6e6d3ddff63c6b2f982d97444a0f40471a9e48" => :catalina
    sha256 "4d9684b5873e9d4d5fc29f3262c209275c4400d81ef1a988de6268447b00db7a" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "eigen" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  resource "libplinkio" do
    url "https://github.com/mfranberg/libplinkio/releases/download/0.3.1/libplinkio-0.3.1.tar.gz"
    sha256 "fa82d31dc1499126a8a1ab9af2ab64cc709c69ee811fe8c581ed5d9fe8ea1576"
    patch :DATA # disables Python bindings
  end

  def install
    # Build libplinkio, needed for bed2diffs_v*
    resource("libplinkio").stage do
      # Hack at autotools to avoid building Python deps
      inreplace "Makefile.am", "py-plinkio", ""
      inreplace "Makefile.in", "py-plinkio", ""
      system "autoreconf", "-fvi"

      mkdir "build" do
        system "../configure", "--prefix=#{libexec}",
                               "--disable-dependency-tracking",
                               "--disable-debug",
                               "--disable-silent-rules",
                               "--disable-tests"
        system "make", "install"
      end
    end

    # Set up Make variables
    boost = Formula["boost"]
    makevars = %W[BOOST_LIB=#{boost.opt_lib}
                  BOOST_INC=#{boost.opt_include}
                  EIGEN_INC=#{Formula["eigen"].opt_include}/eigen3
                  PLINKIO=#{libexec}]
    target = OS.mac? ? "darwin" : "linux"

    cd "bed2diffs" do
      # libplinkio doesn't seem to support gcc-based builds on macOS
      src = OS.mac? ? "src-wout-openmp" : "src"
      cd src do
        # Fix incorrect include location
        cxxflags = "CXXFLAGS=-I${PLINKIO}/include -O3"
        cxxflags += " -fopenmp" unless OS.mac?
        system "make", target, *makevars, cxxflags
        # Because it's too difficult to just define both in one Makefile...
        inreplace "Makefile", "bed2diffs_v1", "bed2diffs_v2"
        system "make", target, *makevars, cxxflags
        bin.install Dir["bed2diffs_v{1,2}"]
      end
    end

    cd "runeems_sats" do
      cd "src" do
        system "make", target, *makevars
        bin.install "runeems_sats"
      end
      (pkgshare/"sats").install Dir["data/*"]
    end

    cd "runeems_snps" do
      cd "src" do
        system "make", target, *makevars
        bin.install "runeems_snps"
      end
      (pkgshare/"snps").install Dir["data/*"]
    end
  end

  test do
    cp Dir["#{pkgshare}/snps/barrier-schemeZ-nIndiv300-nSites3000*"], testpath
    (testpath/"params.ini").write <<~EOS
      datapath = ./barrier-schemeZ-nIndiv300-nSites3000
      mcmcpath = chain1
      nIndiv = 300
      nSites = 3000
      nDemes = 200
      diploid = false
      numMCMCIter = 1000
      numBurnIter = 10
      numThinIter = 10
    EOS
    system "#{bin}/runeems_snps", "--params", "params.ini"
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index 2c2175f..5d31b31 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@

 AC_PREREQ(2.61)
 AC_INIT([libplinkio], [0.3.1], [mattias.franberg@googlemail.com])
-AM_INIT_AUTOMAKE([foreign -Wall -Werror])
+AM_INIT_AUTOMAKE([foreign -Wall subdir-objects])
 AC_CONFIG_SRCDIR([src/fam.c])
 AC_CONFIG_MACRO_DIR([m4])

@@ -15,23 +15,6 @@ AM_CONDITIONAL(GCC, test "$GCC" = yes)
 # Checks for libraries.
 LT_INIT

-# Python 
-AM_PATH_PYTHON([2.7])
-AC_ARG_VAR([PYTHON_INCLUDE], [Include flags for python, bypassing python-config])
-AC_ARG_VAR([PYTHON_CONFIG], [Path to python-config])
-AS_IF([test -z "$PYTHON_INCLUDE"], [
-    AS_IF([test -z "$PYTHON_CONFIG"], [
-        AC_PATH_PROGS([PYTHON_CONFIG],
-                      [python$PYTHON_VERSION-config python-config],
-                      [no],
-                      [`dirname $PYTHON`])
-        AS_IF([test "$PYTHON_CONFIG" = no], [AC_MSG_ERROR([cannot find python-config for $PYTHON.])])
-    ])
-    AC_MSG_CHECKING([python include flags])
-    PYTHON_INCLUDE=`$PYTHON_CONFIG --includes`
-    AC_MSG_RESULT([$PYTHON_INCLUDE])
-])
-

 # Checks for header files.
 AC_HEADER_STDC
@@ -60,7 +43,7 @@ if test "$WITH_TESTS" = "yes"; then
     AC_CONFIG_SUBDIRS([libs/cmockery])
 fi

-AC_CONFIG_FILES([Makefile src/Makefile libs/libcsv/Makefile tests/Makefile py-plinkio/Makefile])
+AC_CONFIG_FILES([Makefile src/Makefile libs/libcsv/Makefile tests/Makefile])

 AC_OUTPUT
