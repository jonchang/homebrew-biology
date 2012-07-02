require 'formula'

class Hyphy < Formula
  homepage 'http://www.hyphy.org/'
  url 'https://github.com/veg/hyphy/tarball/2.1.2'
  sha1 'eff06ff6f217c6625f41cf1083b9f5c8a8f2b901'
  head 'https://github.com/veg/hyphy.git'

  depends_on 'cmake' => :build

  def patches
    # allow single-threaded builds
    "https://github.com/jonchang/hyphy/commit/2747d1526ea6d4c90537b4b343fc5849e7d82d59.diff"
  end

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make SP;make install"
  end
end
