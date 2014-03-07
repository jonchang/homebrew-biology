require "formula"

class Bamm < Formula
  homepage "http://bamm-project.org/"
  head "https://github.com/macroevolution/bamm.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    share.install "doc", "examples"
  end

  def caveats; <<-EOS.undent
  Documentation and examples have been installed to:

    #{opt_prefix}/share/docs
    #{opt_prefix}/share/examples

  To install the R package, start R then:

    install.packges("BAMMtools")
  EOS
  end
end
