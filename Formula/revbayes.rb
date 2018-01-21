class Revbayes < Formula
  desc "Bayesian phylogenetic inference with graphical models"
  homepage "https://revbayes.github.io/"
  url "https://github.com/revbayes/revbayes/archive/v1.0.1-release.tar.gz"
  version "1.0.1"
  sha256 "38aa1879da8b886cbc66925ca593fa5d25b2e746f8163298623a1871dcec105f"
  head "https://github.com/revbayes/revbayes.git", :branch => "development"
  # tag "bioinformatics"
  # doi "10.1093/sysbio/syw021"

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "boost"

  patch :DATA

  def install
    cd "projects/cmake" do
      system "./regenerate.sh", "-boost", "false"
      system "cmake", ".", *std_cmake_args
      system "make"
      bin.install "rb"
    end

    pkgshare.install "examples", "tests"
  end

  def caveats
    <<-EOS.undent
    Example files are installed to:
      #{pkgshare}
    EOS
  end

  test do
    cp pkgshare/"examples/HKY.Rev", testpath
    cp pkgshare/"tests/data/Primates.nex", testpath
    mv "Primates.nex", "primates_cytb.nex"
    system "#{bin}/rb", "HKY.Rev"
  end
end
__END__
diff --git a/projects/cmake/regenerate.sh b/projects/cmake/regenerate.sh
index 46b128c..fe14211 100755
--- a/projects/cmake/regenerate.sh
+++ b/projects/cmake/regenerate.sh
@@ -161,7 +161,6 @@ set(PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/../../src)
 
 
 
-SET(BOOST_ROOT ../../boost_1_60_0)
 SET(Boost_USE_STATIC_RUNTIME true)
 SET(Boost_USE_STATIC_LIBS ON)
 #find_package(Boost 1.60.0 COMPONENTS filesystem regex signals system thread date_time program_options serialization math_c99 math_c99f math_tr1f math_tr1l REQUIRED)

