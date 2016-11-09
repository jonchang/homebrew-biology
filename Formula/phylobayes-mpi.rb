class PhylobayesMpi < Formula
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/downloadmpi.html"
  head "https://github.com/bayesiancook/pbmpi.git"

  depends_on :mpi => :cxx

  def install
    cd "sources" do
      system "make"
    end

    bin.install Dir["data/*"]
    pkgshare.install "pb_mpiManual1.7.pdf"
  end

  def caveats; <<-EOS.undent
    The manual has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "false"
  end
end
