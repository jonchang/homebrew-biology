class Illumiprocessor < Formula
  include Language::Python::Virtualenv
  desc "Pre-process Illumina reads"
  homepage "https://github.com/faircloth-lab/illumiprocessor"
  url "https://github.com/faircloth-lab/illumiprocessor/archive/v2.0.9.tar.gz"
  sha256 "81a70360e43622d7ec73068d5d0fe79f7c82d7a8c50099b07e703431f220b1fd"

  depends_on :java
  depends_on "pypy"

  resource "trimmomatic-0.32" do
    url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.32.zip"
    sha256 "8bffed8228a125adac14ab5f9e45ecd7c853f22446bf08c612cf72cc25a7f6ef"
  end

  def install
    venv = virtualenv_create(libexec)
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
    false
  end
end
