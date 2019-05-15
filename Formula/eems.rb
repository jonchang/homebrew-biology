class Eems < Formula
  desc "Estimating Effective Migration Surfaces"
  homepage "https://github.com/dipetkov/eems"
  url "https://github.com/dipetkov/eems.git", :revision => "42bc6c7379295b91f38eedf0a3723e1bf3cf4264"
  version "2018.09.17"
  head stable.url

  depends_on "boost"
  depends_on "eigen"

  def fix_makevars!
    boost = Formula["boost"]
    eigen = Formula["eigen"]
    inreplace "Makefile" do |s|
      s.change_make_var! "BOOST_LIB", boost.opt_lib
      s.change_make_var! "BOOST_INC", boost.opt_include
      s.change_make_var! "EIGEN_INC", eigen.opt_include/"eigen3"
    end
  end

  def install
    cd "runeems_sats" do
      cd "src" do
        fix_makevars!
        system "make", "darwin"
        bin.install "runeems_sats"
      end
      (pkgshare/"sats").install Dir["data/*"]
    end

    cd "runeems_snps" do
      cd "src" do
        fix_makevars!
        system "make", "darwin"
        bin.install "runeems_snps"
      end
      (pkgshare/"snps").install Dir["data/*"]
    end
  end

  test do
    cp Dir["#{pkgshare}/snps/barrier-schemeZ-nIndiv300-nSites3000*"], testpath
    (testpath/"params.ini").write <<~EOS
      datapath = ./barrier-schemeZ-nIndiv300-nSites3000
      mcmcpath = chain1
      nIndiv = 300
      nSites = 3000
      nDemes = 200
      diploid = false
      numMCMCIter = 1000
      numBurnIter = 10
      numThinIter = 10
    EOS
    system "#{bin}/runeems_snps", "--params", "params.ini"
  end
end
