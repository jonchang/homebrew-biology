require "formula"
require "requirement"

class RRequirement < Requirement
  fatal true
  satisfy { which "R" and which "Rscript" }
  def message; "Install R with: brew install homebrew/science/r"; end
end

class ApeRequirement < Requirement
  fatal true
  satisfy { system "Rscript", "-e", "library(ape)" }
  def message; %q{Install ape with: Rscript -e 'install.packages("ape")'}; end
end

class Bamm < Formula
  homepage "http://bamm-project.org/"

  option "without-bammtools", "don't install bammtools (requires R)"
  depends_on RRequirement if build.with? "bammtools"
  depends_on ApeRequirement if build.with? "bammtools"

  stable do
    url "http://www-personal.umich.edu/~carlosja/bamm-1.0.0.tar.gz"
    sha1 "1f14901a40931d6de208d3b17b0031b165c87de8"

    resource "examples" do
      url "http://www-personal.umich.edu/~carlosja/bamm-examples.tar.gz"
      sha1 "b26777e04bad5a17426c453278bfae75e74ee6e4"
    end

    resource "bammtools" do
      url "http://www-personal.umich.edu/~carlosja/BAMMtools_1.0.1.tar.gz"
      sha1 "dcf506982245414ed5f2f2c98e9572304d122ca1"
    end
  end

  head do
    url "https://github.com/macroevolution/bamm.git"

    resource "bammtools" do
      url "https://github.com/macroevolution/bammtools.git"
    end
  end

  depends_on "cmake" => :build

  def install
    # None should work fine, so this needs to be fixed upstream
    args = *std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}
    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"

    if build.head?
      resource("bammtools").stage { system "R", "CMD", "INSTALL", "BAMMtools" } if build.with? 'bammtools'
      share.install Dir["examples/*"]
    else
      resource("bammtools").stage { system "R", "CMD", "INSTALL", "." } if build.with? 'bammtools'
      resource("examples").stage { share.install Dir['*'] }
    end
  end

  def caveats; <<-EOS.undent
    Examples have been installed to:
      #{share}
  EOS
  end

  test do
    cp Dir[share + "diversification/anoles/*"], testpath
    system bin/"bamm", "-c", "divcontrol.txt"
  end
end
