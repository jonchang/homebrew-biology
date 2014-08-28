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
      bin.install ["rb", "rb-extended"]
    end
  end

  test do
    system "false"
  end
end

__END__
diff --git a/projects/cmake/regenerate.sh b/projects/cmake/regenerate.sh
index 0872688..b3840ce 100755
--- a/projects/cmake/regenerate.sh
+++ b/projects/cmake/regenerate.sh
@@ -112,7 +112,6 @@ set(PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/../../src)
 
 
 
-SET(BOOST_ROOT ../../boost_1_55_0)
 SET(Boost_USE_STATIC_RUNTIME true)
 #find_package(Boost 1.55.0 COMPONENTS filesystem regex signals context system thread date_time program_options iostreams serialization math_c99 math_c99f math_tr1f math_tr1l REQUIRED)
 find_package(Boost

