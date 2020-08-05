class Revbayes < Formula
  # cite Hohna_2016: "https://doi.org/10.1093/sysbio/syw021"
  desc "Bayesian phylogenetic inference with graphical models"
  homepage "https://revbayes.github.io/"
  url "https://github.com/revbayes/revbayes.archive/archive/v1.0.13.tar.gz"
  sha256 "e85e2e1fe182fe9f504900150d936a06d252a362c591b9d3d8272dd085aa85d9"
  head "https://github.com/revbayes/revbayes.git", branch: "development"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "82cec4e0172463fa35d076e4202c64fca5ecb0401bc6e5def305771babd427f4" => :catalina
    sha256 "1b5ac34d369809ec0a34ffb6c6764bcd2ce42b05ae68a403a074e0a4f606e317" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "open-mpi"

  def install
    cd "projects/meson" do
      system "./generate.sh"
    end
    mkdir "build" do
      ENV["BOOST_ROOT"] = Formula["boost"].prefix
      system "meson", "--prefix=#{prefix}", "-Dmpi=true", ".."
      system "ninja", "-v"
      system "ninja", "-v", "install"
    end
  end

  test do
    system "#{bin}/rb", "--version"
  end
end
