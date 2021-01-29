#!/bin/bash
function createBai(){
        args=$1
        echo $1
        cd /hpc/diaggen/users/noah/data/sites/
        bcftools view sites.GRCh37.vcf.gz --regions $1 > sites.grch37_chr$1.vcf   # Create vcf with 1 chr
        bgzip sites.grch37_chr$1.vcf
        tabix -p vcf sites.grch37_chr$1.vcf.gz
        cd /hpc/diaggen/projects/Genealogy/Trio_NICU_U203908/bam_files/per_chr
        mkdir $1
        samtools view -b ../U203908CO2020D15218.bam $1 > $1/U203908CO2020D15218_chr$1.bam
        samtools view -b ../U203908PM2020D15221.bam $1 > $1/U203908PM2020D15221_chr$1.bam
        samtools view -b ../U203908PF2020D15219.bam $1 > $1/U203908PF2020D15219_chr$1.bam
        cd per_chr/$1
        cd $1
        samtools index U203908CO2020D15218_chr$1.bam    # Creating bam.bai files
        samtools index U203908PF2020D15219_chr$1.bam
        samtools index U203908PM2020D15221_chr$1.bam
}
createBai $1
