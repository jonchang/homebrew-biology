class Phylobayes < Formula
  # cite Lartillot_2009: "https://doi.org/10.1093/bioinformatics/btp368"
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "http://megasun.bch.umontreal.ca/People/lartillot/www/phylobayes4.1c.tar.gz"
  version "4.1c"
  sha256 "3ab7e853d720537aeeae5c50605abb8559e24221dbc36d97aa02a31753ace943"
  revision 1

  conflicts_with "phylobayes-mpi"

  patch :DATA

  def install
    pkgshare.install Dir["data/*"]
    system "make", "-C", "sources"
    bin.install Dir["data/*"]
  end

  test do
    cp Dir[pkgshare/"brpo/*"], testpath
    system "#{bin}/pb", "-t", "brpo.tree", "-d", "brpo.ali", "-x", "1", "10", "test"
  end
end

__END__
diff --git a/sources/PB.cpp b/sources/PB.cpp
index d431f5f..c8f249a 100644
--- a/sources/PB.cpp
+++ b/sources/PB.cpp
@@ -1093,7 +1093,7 @@ int main(int argc, char* argv[])	{
 	}
 
 	if (randomseed)	{
-		Random::Random(1001);
+		Random::InitRandom(1001);
 	}
 	/*
 	else	{
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

