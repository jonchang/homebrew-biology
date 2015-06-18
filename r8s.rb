class R8s < Formula
  desc "estimate rates and divergence times on phylogenetic trees"
  homepage "http://loco.biosci.arizona.edu/r8s/"
  url "http://loco.biosci.arizona.edu/r8s/r8s.dist.tgz"
  version "1.8"
  sha256 "a388d70275abfabf73a84a4346175ae94b3a3b2f1f399a4d3657bb430a22f903"

  depends_on :fortran

  def install
    fortranlibs = File.dirname `gfortran --print-file-name libgfortran.dylib`
    inreplace "makefile" do |s|
      s.change_make_var! "LPATH", "-L#{fortranlibs}"
    end
    system "make"
    bin.install "r8s"
    share.install Dir["SAMPLE_*", "*.pdf"]
  end

  def caveats; <<-EOS.undent
    The manual and example files were installed to
      #{opt_prefix}/share
    EOS
  end

  test do
    assert_match(/r8s version #{version}/, shell_output("#{bin}/r8s -v -b", 1))
  end
end
