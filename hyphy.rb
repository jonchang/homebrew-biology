require 'formula'

class Hyphy < Formula
  homepage 'http://www.hyphy.org/'
  url 'https://github.com/veg/hyphy/tarball/2.1.2'
  sha1 'eff06ff6f217c6625f41cf1083b9f5c8a8f2b901'

  depends_on 'cmake' => :build

  def patches
    # allow single-threaded builds
    DATA
  end

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make SP;make install"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2f32bb8..4755fb5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -216,6 +216,21 @@ install(
 )
 add_custom_target(MP2 DEPENDS HYPHYMP)
 
+#-------------------------------------------------------------------------------
+# hyphy sp target
+#-------------------------------------------------------------------------------
+add_executable(
+    HYPHYSP
+    EXCLUDE_FROM_ALL
+    ${SRC_COMMON} ${SRC_UNIXMAIN}
+)
+target_link_libraries(HYPHYSP ${DEFAULT_LIBRARIES})
+install(
+    TARGETS HYPHYSP
+    RUNTIME DESTINATION bin
+    OPTIONAL
+)
+add_custom_target(SP DEPENDS HYPHYSP)
 
 #-------------------------------------------------------------------------------
 # hyphy OpenCL target
@@ -395,7 +410,7 @@ endif((${GTK2_FOUND}))
 #-------------------------------------------------------------------------------
 if(UNIX)
     set_property(
-        TARGET HYPHYMP hyphy_mp HYPHYGTEST HYPHYDEBUG
+        TARGET HYPHYMP hyphy_mp HYPHYGTEST HYPHYDEBUG HYPHYSP
         APPEND PROPERTY COMPILE_DEFINITIONS __UNIX__
     )
 endif(UNIX)
@@ -406,7 +421,7 @@ set_property(
 )
 
 set_property(
-    TARGET hyphy_mp HYPHYMP HYPHYGTEST HYPHYDEBUG
+    TARGET hyphy_mp HYPHYMP HYPHYGTEST HYPHYDEBUG HYPHYSP
     APPEND PROPERTY COMPILE_DEFINITIONS _HYPHY_LIBDIRECTORY_="${CMAKE_INSTALL_PREFIX}/lib/hyphy"
 )
 
@@ -416,6 +431,13 @@ set_property(
 )
 
 set_target_properties(
+    HYPHYSP
+    PROPERTIES
+    COMPILE_FLAGS "${DEFAULT_COMPILE_FLAGS}"
+    LINK_FLAGS "${DEFAULT_LINK_FLAGS}"
+)
+
+set_target_properties(
     hyphy_mp HYPHYMP
     PROPERTIES
     COMPILE_FLAGS "${DEFAULT_COMPILE_FLAGS} ${OpenMP_CXX_FLAGS}"

