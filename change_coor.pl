#!/usr/bin/perl
use strict;



my @files=glob("*/coord*.txt");
for my $file(@files)
{
        $file =~ /(\S+)\/.*txt/;
        my $Dir = $1;
        open In,"<",$file;
	my $Npts;
	my $Centerpos;
        while(<In>){
        	chomp;
        	if(/Center/){
			my $pos = $_;
			$pos =~ s/Center x y z: //;
			$pos =~ s/ //g;
			$pos =~ s/\r//;
			$Centerpos = $pos;
                 }elsif(/x npt/){
			my $npt = $_;
			$npt =~ s/\r//;
			$npt =~ /x npt: (\d+), y npt: (\d+), z npt: (\d+)/;
                        $Npts = $1.",".$2.",".$3;
                 }
        }
        #close In;
	open Script,"<",$Dir."/bin/1_Prepare_Lig-Rec.sh";
	open Out,">",$Dir."/bin/1_Prepare_Lig-Rec_new.sh";
        while(<Script>)
        {
		if(/npts/){
			$_ =~ s/npts=\S+ /npts="$Npts" /;
			$_ =~ s/gridcenter=\S+ /gridcenter="$Centerpos" /;
		}
	print Out $_;
        }
	
        close Script;
        close Out;
}


