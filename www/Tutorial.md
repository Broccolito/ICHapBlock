## Phase whole genome files in VCF format



<blockquote>
Wanjun Gu <br>
Simonson Lab <br>
May 23rd 2020 <br>
</blockquote>



### Getting ready

#### Acquire the whole genome files



- Download the whole genome file in VCF format.

  Some sample VCF files from online sources include:

  [Thousand Genome Project]https://www.internationalgenome.org/data/

  [Ensembl FTP Download]https://uswest.ensembl.org/info/data/ftp/index.html

- VCF format is best described by:

  [VCF Specs]https://samtools.github.io/hts-specs/VCFv4.2.pdf



#### Install Linux 



- Install VirtualBox

  [Download VirtualBox]https://www.virtualbox.org/wiki/Downloads

- Download a Linux distribution. Since there are numerous distributions of Linux, I recommend Kubuntu, a community release of ubuntu Linux distribution using the KDE desktop environment. 

- Kubuntu ISO can be easily downloaded at:

  ```plain text
  https://kubuntu.org/getkubuntu/
  ```

- Install Kubuntu or other Linux distribution of your interest onto VirtualBox. Online tutorial about this can be found at:

  ```plain text
  https://www.youtube.com/watch?v=hvkJv71PsCs
  ```

- The Kubuntu ISO is approximately 2.5 GB in size and the VirutalBox installation will at minimum take more than 20GB of storage space of the computer. In order to process whole genome files, 50GB of storage on the VirtualBox is recommended.

- Downloading of the ISO file will likely take 20 to 60 minutes dependent on the internet bandwidth. Installing Kubuntu linux onto the VirtualBox will likely take another 20 to 30 minutes 

  

#### Install VCFtools



- Before installing VCFtools, although it is optional, but installation of a prettier terminal command line tools is recommended. Specifically, Tilix is recommended.

- Open the start menu > search Konsole (Kubuntu) > Open Konsole

- Update and sync all repositories

  ```bash
  sudo apt-get update
  sudo apt-get upgrade
  ```

- Install Tilix, the prettier command line tool.

  ```bash
  sudo apt-get install tilix
  ```

- Fire up Tilix: Open the start menu > search Tilix > Open Tilix

- Install Git, a version control tool

  ```bash
  sudo apt-get install git
  ```

- Install [VCFtools]https://vcftools.github.io/ From github (Latest Release)

  Run the following commands line by line:

  ```bash
  git clone https://github.com/vcftools/vcftools.git
  cd vcftools
  ./autogen.sh
  ./configure
  make
  make install
  ```

- After installing VCFtools, the manual can be viewed by:

  ```bash
  man vcftools
  ```

  Type in ```vcftools``` in the command line and you should see something like:

  ```bash
  User@user-kubuntu:~$ vcftools
  
  VCFtools (0.1.16)
  © Adam Auton and Anthony Marcketta 2009
  
  Process Variant Call Format files
  
  For a list of options, please go to:
  	https://vcftools.github.io/man_latest.html
  
  Alternatively, a man page is available, type:
  	man vcftools
  
  Questions, comments, and suggestions should be emailed to:
  	vcftools-help@lists.sourceforge.net
  
  ```



#### Install shapeit



- Shapeit is a commonly used genome phasing tool. It can be downloaded from:

  [Shapeit]https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html#download

- Once you have downloaded Shapeit as a ```tar.gz``` file, pivot the system directory to find the zipped folder and then run

  ```bash
  tar -zxvf shapeit.v2.r900.glibcv2.17.linux.tar.gz
  ```

  to unzip the file.

- If you happen to not have ```tar``` installed, install ```tar``` using:

  ```bash
  sudo apt-get install tar
  ```

  whereas for most distributions, ```tar``` should be already installed.

- Navigate into the unzipped shapeit folder named like ```shapeit.v2.904.2.6.32-696.18.7.el6.x86_64```. Specific name of the fold may differ due to different versions of shapeit.

- Once you are in shapeit folder, navigate into the bin folder:

  ```bash
  User@user-kubuntu:~/shapeit.v2.904.2.6.32-696.18.7.el6.x86_64$ ls
  bin  example  LICENCE
  
  User@user-kubuntu:~/shapeit.v2.904.2.6.32-696.18.7.el6.x86_64$ cd bin/
  
  User@user-kubuntu:~/shapeit.v2.904.2.6.32-696.18.7.el6.x86_64/bin$ ls
  shapeit
  
  User@user-kubuntu:~/shapeit.v2.904.2.6.32-696.18.7.el6.x86_64/bin$ ./shapeit 
  
  ```

- The last command ```./shapeit``` is to execute the program. Input files should be stored under the same directory (bin).



### Data Preprocessing

#### Split the whole genome files by chromosome



- Using the newly installed VCFtools:

  ```bash
  vcftools -vcf <whole_genome_vcf_input.vcf> --plink --chr 2 --out whole_genome_vcf_chr2
  ```

  This command not only splits the whole genome file by chromosome, but it also output the file in a format more receivable by shapeit, making the next step, phasing easier.

  ```--chr 2``` refers to the second chromosome. If one wants to acquire the whole genome in plink format by chromosome, this command can be repeated for all chromosomes.

  ```bash
  vcftools -vcf <whole_genome_vcf_input.vcf> --plink --chr 1 --out whole_genome_vcf_chr2
  vcftools -vcf <whole_genome_vcf_input.vcf> --plink --chr 2 --out whole_genome_vcf_chr2
  vcftools -vcf <whole_genome_vcf_input.vcf> --plink --chr 3 --out whole_genome_vcf_chr2
  ......
  ......
  ```

- The output files for the script are in ```.ped``` and ```.map```. Save the files for the shapeit program.



### Data Input

#### Input the data into shapeit



- Move the ```.ped``` and ```.map``` to the ```bin``` folder of shapeit.

- Run the command:

  ```bash
  ./shapeit --input-ped whole_genome_vcf_chr2.ped whole_genome_vcf_chr2.map \
          -M genetic_map.txt \
          -O gwas.phased
  ```

  ```whole_genome_vcf_chr2.ped``` and ```whole_genome_vcf_chr2.map``` should be changed according to the generated files.

- This process may take up to three to four hours. Enabling multithreading can speed up the process. To add multithreading, the command should look like:

  ```bash
  ./shapeit --input-ped whole_genome_vcf_chr2.ped whole_genome_vcf_chr2.map \
          -M genetic_map.txt \
          -O gwas.phased \ 
          --thread 4
  ```

- For further questions and more customizable parameters of shapeit, you can visit the manual for shapeit.

  [shapeit]https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html





























