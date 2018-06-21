class LagrangeCpp < Formula
  desc "the c++ version of lagrange"
  homepage "http://code.google.com/p/lagrange"
  url "https://github.com/rhr/lagrange-cpp.git", :revision => "7d9eaa6322c59ac1283e976a37861a3101abb9cc"
  version "2018.05.15"
  head "https://github.com/rhr/lagrange-cpp.git"

  depends_on "armadillo"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "gmp"
  depends_on "mpfr"

  needs :cxx14
  fails_with :clang

  def install
    system "make", "-C", "src", "FC=gfortran"
    bin.install "src/lagrange_cpp"
  end

  test do
    system "false"
  end
end
