class Phyluce < Formula
  desc "Pipeline for UCE (and general) phylogenomics"
  homepage "https://phyluce.readthedocs.org/"
  url "https://github.com/faircloth-lab/phyluce/archive/v1.6.7.tar.gz"
  sha256 "98c213ab1610506722ad1440ffc93f9cbc78d8b3aaf3d9a47837e1231452cdb6"

  depends_on "brewsci/bio/muscle"
  depends_on "brewsci/bio/raxml"
  depends_on "jonchang/biology/illumiprocessor"
  depends_on "mafft"
  depends_on "pypy"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/f0/3c/ab5783b5d2cb4ed566abcd9335e90b13ff57c4fcc93fd08bda5dfded2fdc/biopython-1.72.tar.gz"
    sha256 "ab6b492443adb90c66267b3d24d602ae69a93c68f4b9f135ba01cb06d36ce5a2"
  end

  resource "bx-python" do
    url "https://files.pythonhosted.org/packages/7b/b9/fb458d37d89fa71ce39475d9a44d7830950c3cd6533879a2115a42ac122b/bx-python-0.8.2.tar.gz"
    sha256 "faeb0c7c9fcb2f95c4fc1995af4f45287641deee43a01659bd30fe95c5d37386"
  end

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/f5/21/17e4fbb1c2a68421eec43930b1e118660c7483229f1b28ba4402e8856884/DendroPy-4.4.0.tar.gz"
    sha256 "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d5/6e/f00492653d0fdf6497a181a1c1d46bbea5a2383e7faf4c8ca6d6f3d2581d/numpy-1.14.5.zip"
    sha256 "a4a433b3a264dbc9aa9c7c241e87c0358a503ea6394f8737df1683c7c9a102ac"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/e9/ad/5e92ba493eff96055a23b0a1323a9a803af71ec859ae3243ced86fcbd0a4/pandas-0.23.4.tar.gz"
    sha256 "5b24ca47acf69222e82530e89111dd9d14f9b970ab2cd3a1c2c78f0c4fbba4f4"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/f9/c4/f1b6963a05f415aa69c8efd64ebe460d56d03ecc75db70b0e8606b589ade/pysam-0.15.0.tar.gz"
    sha256 "51e7030bebff68502a69fabc601727f827cd6e7c08c5899b11ad8c6084ba4ba5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "PyVCF" do
    url "https://files.pythonhosted.org/packages/20/b6/36bfb1760f6983788d916096193fc14c83cce512c7787c93380e09458c09/PyVCF-0.6.8.tar.gz"
    sha256 "e9d872513d179d229ab61da47a33f42726e9613784d1cb2bac3f8e2642f6f9d9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    # Replicate virtualenv_install_with_resources but for pypy
    ENV.prepend_create_path "PYTHONPATH", libexec/"site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/site-packages"
    resources.each do |r|
      r.stage do
        system "pypy", *Language::Python.setup_install_args(libexec/"vendor"),
          "--install-scripts=#{libexec}/vendor/bin"
      end
    end
    system "pypy", *Language::Python.setup_install_args(libexec),
      "--install-scripts=#{libexec}/bin"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

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
    commands = %w[assembly_match_contigs_to_probes assembly_get_match_counts assembly_get_fastas_from_match_counts align_seqcap_align align_get_align_summary_data align_format_nexus_files_for_raxml]
    commands.each do |cmd|
      system "#{bin}/phyluce_#{cmd}", "--help"
    end
  end
end
