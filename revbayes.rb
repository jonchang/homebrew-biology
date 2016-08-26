require "formula"

class Revbayes < Formula
  homepage "https://github.com/revbayes/revbayes"
  head "https://github.com/revbayes/revbayes.git", :branch => "development"

  depends_on "cmake" => :build
  depends_on "boost"

  patch :DATA

  def install
    cd "projects/cmake" do
      system "./regenerate.sh", "-boost", "false"
      system "cmake", ".", *std_cmake_args
      system "make"
      bin.install "rb"
    end
  end

  test do
    system "false"
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

