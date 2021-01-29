#!/bin/bash
# Extract sites to directory for each chromosome.
cd /hpc/diaggen/users/noah/data
function extract(){
        args=$1
        ../tools/somalier extract -d perChr/$1 -s sites/sites.grch37_chr$1.vcf.gz -f /hpc/diaggen/projects/Genealogy/ref_genomes/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta /hpc/diaggen/projects/Genealogy/Trio_NICU_U203908/bam_files/per_chr/$1/U203908CO2020D15218_chr$1.bam
        ../tools/somalier extract -d perChr/$1 -s sites/sites.grch37_chr$1.vcf.gz -f /hpc/diaggen/projects/Genealogy/ref_genomes/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta /hpc/diaggen/projects/Genealogy/Trio_NICU_U203908/bam_files/per_chr/$1/U203908PM2020D15221_chr$1.bam
        ../tools/somalier extract -d perChr/$1 -s sites/sites.grch37_chr$1.vcf.gz -f /hpc/diaggen/projects/Genealogy/ref_genomes/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta /hpc/diaggen/projects/Genealogy/Trio_NICU_U203908/bam_files/per_chr/$1/U203908PF2020D15219_chr$1.bam
}
extract $1
