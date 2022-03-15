=b
This Perl script helps you manipulate cfg files in sequence
=cut
use warnings;   
use strict;
use Cwd;
use POSIX;
use Data::Dumper;
############# You need to provide the following parent folder name having all set.XXX folders
my $cfg_folder = "HEA_compress";# the folder with all cfg files
my $data_template = "initial/noequal.data";# the data template
my $lmp = "/opt/lammps-mpich-3.4.2/lmp_20211104";# lammps executable
my $currentPath = getcwd();
my $out_folder = "$currentPath/output_cfg";# the folder for output cfg files
`rm -rf $out_folder`;# remove old one
`mkdir -p $out_folder`;#create an empty folder
my @temp = `find $currentPath/$cfg_folder -type f -name "*stress*.cfg"`;
chomp @temp;
my @allcfg = sort @temp; # dirs with all set.XXX folders
my $counter = 0;
for (@allcfg){
    my $timestep = `cat $_ |grep -A1 "ITEM: TIMESTEP"|grep -v "ITEM: TIMESTEP"`;
    chomp $timestep;
    `sed -i '/read_dump .*/d' ./read_cfg.in`;
    `sed -i '/#cfg_anchor/a read_dump $_ $timestep x y z box yes' ./read_cfg.in`;
    system("$lmp -in ./read_cfg.in"); #you need to modify it for mpi
    $counter++;
    system("mv $out_folder/stress.cfg $out_folder/stress_$counter.cfg"); #you need to modify it for mpi
}