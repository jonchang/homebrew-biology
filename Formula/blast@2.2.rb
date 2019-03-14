class BlastAT22 < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-src.tar.gz"
  version "2.2.31"
  sha256 "f0960e8af2a6021fde6f2513381493641f687453a804239a7e598649b432f8a5"

  keg_only :versioned_formula

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "lzo"
  depends_on "pcre"

  # Fix configure: error: Do not know how to build MT-safe with compiler g++-5 5.1.0
  fails_with :gcc => "5"

  # Build failure reported to toolbox@ncbi.nlm.nih.gov on 11 May 2015,
  # patch provided by developers; should be included in next release
  patch :p0, :DATA

  def install
    # Fix error:
    # /bin/sh: line 2: /usr/bin/basename: No such file or directory
    # See http://www.ncbi.nlm.nih.gov/viewvc/v1?view=revision&revision=65204
    inreplace "c++/src/build-system/Makefile.in.top", "/usr/bin/basename", "basename"

    # Move libraries to libexec. Libraries and headers conflict with ncbi-c++-toolkit.
    args = %W[--prefix=#{prefix} --libdir=#{libexec} --without-debug --with-mt]

    args << "--with-mysql"
    args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    args << "--with-png=#{Formula["libpng"].opt_prefix}"
    args << "--with-pcre=#{Formula["pcre"].opt_prefix}"
    args << "--with-hdf5=#{Formula["hdf5"].opt_prefix}"
    args << "--with-dll" << "--without-static" << "--without-static-exe"

    # Boost is used only for unit tests.
    args << "--without-boost"

    cd "c++" do
      system "./configure", *args
      system "make"
      system "make", "install"

      # Remove headers. Libraries and headers conflict with ncbi-c++-toolkit.
      rm_r include
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end

__END__
--- c++/include/corelib/ncbimtx.inl (revision 467211)
+++ c++/include/corelib/ncbimtx.inl (working copy)
@@ -388,7 +388,17 @@
     _ASSERT(m_Lock);

     m_ObjLock.Lock();
-    m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // The above gives strange errors about invalid operands to operator==
+    // with the Apple Developer Tools release containing Xcode 6.3.1 and
+    // "Apple LLVM version 6.1.0 (clang-602.0.49) (based on LLVM 3.6.0svn)".
+    // The below workaround should be equivalent.
+    TRWLockHolder_ListenerWeakRef ref(listener);
+    TListenersList::iterator it;
+    while ((it = find(m_Listeners.begin(), m_Listeners.end(), ref))
+           != m_Listeners.end()) {
+        m_Listeners.erase(it);
+    }
     m_ObjLock.Unlock();
 }
