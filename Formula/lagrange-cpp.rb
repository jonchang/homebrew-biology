class LagrangeCpp < Formula
  desc "C++ version of lagrange"
  homepage "https://code.google.com/p/lagrange/"
  url "https://github.com/rhr/lagrange-cpp.git", :revision => "7d9eaa6322c59ac1283e976a37861a3101abb9cc"
  version "2018.05.15"
  head "https://github.com/rhr/lagrange-cpp.git"

  depends_on "armadillo"
  depends_on "gcc" # for gfortran and openMP
  depends_on "gsl"
  depends_on "nlopt"

  fails_with :clang # for openmp

  def install
    inreplace "src/Makefile" do |s|
      s.remove_make_var! "LINK_LIB_DIRS"
      s.change_make_var! "FC", "gfortran"
    end
    system "make", "-C", "src"
    bin.install "src/lagrange_cpp"
  end

  test do
    system "#{bin}/lagrange_cpp"
  end
end
