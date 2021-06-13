class Illumiprocessor < Formula
  include Language::Python::Virtualenv
  desc "Pre-process Illumina reads"
  homepage "https://github.com/faircloth-lab/illumiprocessor"
  url "https://github.com/faircloth-lab/illumiprocessor/archive/v2.0.9.tar.gz"
  sha256 "81a70360e43622d7ec73068d5d0fe79f7c82d7a8c50099b07e703431f220b1fd"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "05cb5c899a119bf4b24fb4fb056350b54837b3ed9ed6285b2addf3f12cb7950c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63e89e7d6b34682c03c1211b9b4dcd27718b918c0eb77e15fab4debdbab1de50"
  end

  depends_on "openjdk"
  depends_on "python@3.9"

  resource "trimmomatic-0.32" do
    url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.32.zip"
    sha256 "8bffed8228a125adac14ab5f9e45ecd7c853f22446bf08c612cf72cc25a7f6ef"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install_and_link buildpath
    resource("trimmomatic-0.32").stage do
      libexec.install "trimmomatic-0.32.jar"
      libexec.write_jar_script libexec/"trimmomatic-0.32.jar", "trimmomatic"
      chmod 0555, libexec/"trimmomatic"
    end
  end

  def post_install
    inreplace libexec/"config/illumiprocessor.conf",
      "$CONDA_PREFIX/bin/trimmomatic", libexec/"trimmomatic"
  end

  test do
    nil
  end
end
