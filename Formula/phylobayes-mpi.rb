class PhylobayesMpi < Formula
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/downloadmpi.html"
  url "https://github.com/bayesiancook/pbmpi.git", :revision => "c509b221f9dd29a456efe2ec74dea316f4dd3200"
  version "2018.03.08"

  depends_on "open-mpi"

  conflicts_with "phylobayes"

  def install
    cd "sources" do
      system "make"
    end

    bin.install Dir["data/*"]
    pkgshare.install "pb_mpiManual1.7.pdf"
  end

  def caveats; <<~EOS
    The manual has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "false"
  end
end
