class Phyluce < Formula
  include Language::Python::Virtualenv

  desc "Pipeline for UCE (and general) phylogenomics"
  homepage "https://phyluce.readthedocs.io/"
  url "https://github.com/faircloth-lab/phyluce/archive/v1.6.7.tar.gz"
  sha256 "98c213ab1610506722ad1440ffc93f9cbc78d8b3aaf3d9a47837e1231452cdb6"

  depends_on "brewsci/bio/muscle"
  depends_on "brewsci/bio/raxml"
  depends_on "gcc" # for gfortran
  depends_on "jonchang/biology/illumiprocessor"
  depends_on "mafft"
  depends_on "pypy"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/source/b/biopython/biopython-1.73.tar.gz"
    sha256 "70c5cc27dc61c23d18bb33b6d38d70edc4b926033aea3b7434737c731c94a5e0"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/source/n/numpy/numpy-1.16.2.zip"
    sha256 "6c692e3879dde0b67a9dc78f9bfb6f61c666b4562fd8619632d7043fb5b691b0"
  end

  resource "bx-python" do
    url "https://files.pythonhosted.org/packages/source/b/bx-python/bx-python-0.8.2.tar.gz"
    sha256 "faeb0c7c9fcb2f95c4fc1995af4f45287641deee43a01659bd30fe95c5d37386"
  end

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/source/D/DendroPy/DendroPy-4.4.0.tar.gz"
    sha256 "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/source/p/pandas/pandas-0.24.1.tar.gz"
    sha256 "435821cb2501eabbcee7e83614bd710940dc0cf28b5afbc4bdb816c31cec71af"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/source/p/pysam/pysam-0.15.2.tar.gz"
    sha256 "d049efd91ed5b1af515aa30280bc9cb46a92ddd15d546c9b21ee68a6ed4055d9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/source/p/python-dateutil/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/source/p/pytz/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "PyVCF" do
    url "https://files.pythonhosted.org/packages/source/P/PyVCF/PyVCF-0.6.8.tar.gz"
    sha256 "e9d872513d179d229ab61da47a33f42726e9613784d1cb2bac3f8e2642f6f9d9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/source/s/six/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?
    virtualenv_install_with_resources

    # Correct phyluce's misguided attempts to protect me from Trinity
    %w[phyluce_assembly_assemblo_trinity
       phyluce_assembly_get_trinity_coverage_for_uce_loci
       phyluce_assembly_get_trinity_coverage].each do |script|
      inreplace libexec/"bin"/script, 'platform.system() == "Darwin"', "False"
    end
  end

  def post_install
    inreplace libexec/"site-packages/phyluce/pth.py",
      "os.path.join(sys.prefix, 'config/phyluce.conf')",
      "'#{opt_libexec}/config/phyluce.conf'"
  end

  test do
    cmds = %w[assembly_match_contigs_to_probes
              assembly_get_match_counts
              assembly_get_fastas_from_match_counts
              align_seqcap_align
              align_get_align_summary_data
              align_format_nexus_files_for_raxml]
    cmds.each do |cmd|
      system "#{bin}/phyluce_#{cmd}", "--help"
    end
  end
end
