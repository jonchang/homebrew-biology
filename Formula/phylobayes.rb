class Phylobayes < Formula
  desc "phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "http://megasun.bch.umontreal.ca/People/lartillot/www/phylobayes4.1c.tar.gz"
  version "4.1c"
  sha256 "3ab7e853d720537aeeae5c50605abb8559e24221dbc36d97aa02a31753ace943"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btp368"

  conflicts_with "phylobayes-mpi"

  patch :DATA

  def install
    system "make", "-C", "sources"
    bin.install Dir["data/*"]
  end

  test do
    system "false"
  end
end

__END__
diff --git a/sources/PolyNode.cpp b/sources/PolyNode.cpp
index f168515..523c636 100644
--- a/sources/PolyNode.cpp
+++ b/sources/PolyNode.cpp
@@ -470,7 +470,7 @@ string PolyNode::SortLeavesAlphabetical()	{
 			node = node->next;
 			degree++;
 		}	while(node!=down);
-		string retval[degree];
+		string *retval = new string[degree];
 		PolyNode* nodelist[degree];
 		int k = 0;
 		do	{
@@ -500,7 +500,9 @@ string PolyNode::SortLeavesAlphabetical()	{
 		}
 		nodelist[0]->prev = nodelist[degree-1];
 		down = nodelist[0];
-		return retval[0];
+		string new_retval = retval[0];
+		delete [] retval;
+		return new_retval;
 	}	
 	return "";
 }

