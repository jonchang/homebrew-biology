class Genomescope < Formula
  desc "Fast genome analysis from unassembled short reads"
  homepage "http://qb.cshl.edu/genomescope/"
  url "https://github.com/schatzlab/genomescope/archive/v1.0.0.tar.gz"
  sha256 "bafb8ed84ff6aef759783da4dd58176a0c2bd1e3084c0f78390d6e5a4d52600e"

  # Actually needed for run, but put it as CI-only so
  # we can use R from the environment
  depends_on "r" if ENV["CI"]

  def install
    bin.install "genomescope.R" => "genomescope"
  end

  test do
    system "#{bin}/genomescope"
  end
end
