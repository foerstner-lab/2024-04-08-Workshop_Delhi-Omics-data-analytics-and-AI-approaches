#!/bin/bash

#
# A script to run an READmeption analysis

set -e

main(){
	echo "Starting READemption analysis"
        set_variables
	create_folders
	get_ref_seq
	get_annotation_files
	get_reads
	run_alignment
	run_coverage
	run_gene_quanti
	run_deseq
	run_viz
}


set_variables(){
	echo "Setting variables"
	FTP_SOURCE=ftp://ftp.ncbi.nih.gov/genomes/archive/old_refseq/Bacteria/Salmonella_enterica_serovar_Typhimurium_SL1344_uid86645/

}

create_folders(){
	reademption create --project_path READemption_analysis --species salmonella="Salmonella Typhimurium"
}

get_ref_seq(){
	wget -O READemption_analysis/input/salmonella_reference_sequences/NC_016810.fa $FTP_SOURCE/NC_016810.fna
	wget -O READemption_analysis/input/salmonella_reference_sequences/NC_017718.fa $FTP_SOURCE/NC_017718.fna
	wget -O READemption_analysis/input/salmonella_reference_sequences/NC_017719.fa $FTP_SOURCE/NC_017719.fna
	wget -O READemption_analysis/input/salmonella_reference_sequences/NC_017720.fa $FTP_SOURCE/NC_017720.fna

	sed -i "s/>/>NC_016810.1 /" READemption_analysis/input/salmonella_reference_sequences/NC_016810.fa
	sed -i "s/>/>NC_017718.1 /" READemption_analysis/input/salmonella_reference_sequences/NC_017718.fa
	sed -i "s/>/>NC_017719.1 /" READemption_analysis/input/salmonella_reference_sequences/NC_017719.fa
	sed -i "s/>/>NC_017720.1 /" READemption_analysis/input/salmonella_reference_sequences/NC_017720.fa
}

get_annotation_files(){
	wget -P READemption_analysis/input/salmonella_annotations https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/210/855/GCF_000210855.2_ASM21085v2/GCF_000210855.2_ASM21085v2_genomic.gff.gz
	gunzip READemption_analysis/input/salmonella_annotations/GCF_000210855.2_ASM21085v2_genomic.gff.gz
}

get_reads(){
	wget -P READemption_analysis/input/reads http://reademptiondata.imib-zinf.net/InSPI2_R1.fa.bz2
	wget -P READemption_analysis/input/reads http://reademptiondata.imib-zinf.net/InSPI2_R2.fa.bz2
	wget -P READemption_analysis/input/reads http://reademptiondata.imib-zinf.net/LSP_R1.fa.bz2
	wget -P READemption_analysis/input/reads http://reademptiondata.imib-zinf.net/LSP_R2.fa.bz2
}

run_alignment(){
	reademption align -p 4 --poly_a_clipping --project_path READemption_analysis
}

run_coverage(){
	reademption coverage -p 4 --project_path READemption_analysis
}

run_gene_quanti(){
	reademption gene_quanti -p 4 --features CDS,tRNA,rRNA --project_path READemption_analysis
}

run_deseq(){
	reademption deseq -l InSPI2_R1.fa.bz2,InSPI2_R2.fa.bz2,LSP_R1.fa.bz2,LSP_R2.fa.bz2 -c InSPI2,InSPI2,LSP,LSP -r 1,2,1,2 --libs_by_species salmonella=InSPI2_R1,InSPI2_R2,LSP_R1,LSP_R2 --project_path READemption_analysis
}

run_viz(){
	reademption viz_align --project_path READemption_analysis
	reademption viz_gene_quanti --project_path READemption_analysis
	reademption viz_deseq --project_path READemption_analysis
}

main
