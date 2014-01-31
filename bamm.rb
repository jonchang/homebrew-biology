require "formula"

class Bamm < Formula
  homepage "http://bamm-project.org/"
  head "https://github.com/macroevolution/bamm.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    share.install "skeleton/BAMMtools", "doc", "examples"
  end

  def caveats; <<-EOS.undent
  Documentation has been installed to:
    #{opt_prefix}/share/docs
    #{opt_prefix}/share/examples

  Install the R package with:
    brew sh
    R CMD install #{opt_prefix}/share/BAMMtools && exit
  EOS
  end
end
