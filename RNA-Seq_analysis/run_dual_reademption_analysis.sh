main(){
    create_analysis_folder
    download_staph_genome
    download_staph_annotation
    download_human_genome
    extract_chromosome_20_from_genome
    remove_entire_human_genome
    get_human_annotation
    extract_chromosome_20_from_annotation
    remove_entire_annotation
    download_reads
    align
    coverage
    gene_quanti
    deseq
    viz

}

create_analysis_folder(){
    reademption create --project_path READemption_analysis --species human="Homo sapiens" staphylococcus="Staphylococcus aureus"
}


download_staph_genome(){
    wget -O READemption_analysis/input/staphylococcus_reference_sequences/staphylococcus_genome.fa.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.fna.gz

    gunzip READemption_analysis/input/staphylococcus_reference_sequences/staphylococcus_genome.fa.gz

}

download_staph_annotation(){
    wget -O READemption_analysis/input/staphylococcus_annotations/staphylococcus_annotation.gff.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.gff.gz

    gunzip READemption_analysis/input/staphylococcus_annotations/staphylococcus_annotation.gff.gz
    #rm READemption_analysis/input/staphylococcus_annotations/staphylococcus_annotation.gff.gz

}

download_human_genome(){
    wget -O READemption_analysis/input/human_reference_sequences/human_genome.fa.gz ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/GRCh38.p10.genome.fa.gz

    gunzip READemption_analysis/input/human_reference_sequences/human_genome.fa.gz
    #rm READemption_analysis/input/human_reference_sequences/human_genome.fa.gz
}

extract_chromosome_20_from_genome(){
    start_line=$(grep -n ">chr20" READemption_analysis/input/human_reference_sequences/human_genome.fa | cut -d ":" -f 1)
    end_line=$(grep -n ">chr21" READemption_analysis/input/human_reference_sequences/human_genome.fa | cut -d ":" -f 1)
    ((end_line--))  # Decrement end_line by 1 to exclude ">chr21" line
    head -n $end_line READemption_analysis/input/human_reference_sequences/human_genome.fa | tail -n +$start_line > READemption_analysis/input/human_reference_sequences/human_chromosome_20.fa

}


remove_entire_human_genome(){
    rm READemption_analysis/input/human_reference_sequences/human_genome.fa
}


get_human_annotation(){
    wget -O READemption_analysis/input/human_annotations/human_annotation.gff.gz ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.annotation.gff3.gz
    gunzip READemption_analysis/input/human_annotations/human_annotation.gff.gz
}


extract_chromosome_20_from_annotation(){
    grep "chr20" READemption_analysis/input/human_annotations/human_annotation.gff > READemption_analysis/input/human_annotations/human_annotation_chromosome_20.gff
}

remove_entire_annotation(){
    rm READemption_analysis/input/human_annotations/human_annotation.gff
}

download_reads(){
    wget https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Infected_replicate_1.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Infected_replicate_2.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Infected_replicate_3.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Steady_state_replicate_1.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Steady_state_replicate_2.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Steady_state_replicate_3.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Uninfected_replicate_1.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Uninfected_replicate_2.fq https://raw.githubusercontent.com/Tillsa/Tillsa-2022-06-15-READemption_tutorial_data/main/Uninfected_replicate_3.fq -P READemption_analysis/input/reads
}


align(){
    reademption align -p 20 --poly_a_clipping --fastq --project_path READemption_analysis
}

coverage(){
    reademption coverage -p 4 --project_path READemption_analysis

}

gene_quanti(){
    reademption gene_quanti -p 4 --features gene --project_path READemption_analysis
}

deseq(){
    reademption deseq -l Infected_replicate_1,Infected_replicate_2,Infected_replicate_3,Steady_state_replicate_1,Steady_state_replicate_2,Steady_state_replicate_3,Uninfected_replicate_1,Uninfected_replicate_2,Uninfected_replicate_3 -c infected,infected,infected,steady_state,steady_state,steady_state,uninfected,uninfected,uninfected -r 1,2,3,1,2,3,1,2,3 --libs_by_species human="Infected_replicate_1,Infected_replicate_2,Infected_replicate_3,Uninfected_replicate_1,Uninfected_replicate_2,Uninfected_replicate_3" staphylococcus="Infected_replicate_1,Infected_replicate_2,Infected_replicate_3,Steady_state_replicate_1,Steady_state_replicate_2,Steady_state_replicate_3" --size_factor=species --project_path READemption_analysis
}

viz(){
    reademption viz_align --project_path READemption_analysis
    reademption viz_gene_quanti --project_path READemption_analysis
    reademption viz_deseq --project_path READemption_analysis

}

main
