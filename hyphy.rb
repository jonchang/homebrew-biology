require 'formula'

class Hyphy < Formula
  homepage 'http://www.hyphy.org/'
  url 'https://github.com/veg/hyphy/tarball/2.1.2'
  sha1 'eff06ff6f217c6625f41cf1083b9f5c8a8f2b901'
  head 'https://github.com/veg/hyphy.git'

  depends_on 'cmake' => :build

  def patches
    # Single-threaded builds
    'https://github.com/veg/hyphy/commit/c90bf9b93218a38e4c9f12150ffe36eb65ec3a50.diff'
  end

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make SP; make install"
  end

  def caveats; <<-EOS.undent
    This formula builds a single-threaded version of HyPhy.
    EOS
  end
end
