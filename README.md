# Hyb2
***Easily Generate RNA structures of short- and long-range intra/intermolecular interactions, and homodimers with an Interactive Graphical User Interface.***

A ***streamlined*** program for analyzing RNA proximity ligation experiments from mapped files in the fastq/SAM format to: 
1. Generate a list of chimeric interactions with their coordinates, sequence, and folding energy, 
2. Plot contact density map of selected genes and viewpoint graphs, 
3. Generate intra-/intermolecular RNA structure of any selected regions.

**Additionally, creates an interactive GUI, and plots differences and similarities between experiments.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/fde2431b-f942-4a3e-90c5-f5e11f222d85" height="500" width="700">
</p>

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Running the Program](#running-the-program)
- [How To Read Outputs](#how-to-read-outputs)

## Introduction
RNA adopts ensemble of structures essential for life such as splicing, gene expression, and virus replication. 
It adopts complex secondary structures supported by short-, long-range base-pairing interactions and tertiary structures supported by long-range interactions, pseudoknots, base triples, and RBPs. 
RNA proximity ligation techniques such as CLASH, PARIS, and COMRADES directly detect RNA-RNA interactions and produces a list of chimeric interactions. 
However, it is difficult to identify long-range base-pairings as it is often misidentified by minimum folding energy algorithms, and the interpretation of proximity ligation data is challenging as there is a lack of integrated analytical tools.

Hyb2 is a bioinformatics pipeline for the analysis of RNA proximity ligation experiments in high resolution. 

It **generates RNA structures with experimental support** for short- and long-range intramolecular interactions, intermolecular interactions, and RNA homodimers. 

It **supports commonly used data formats (SAM)** and integrates with a variety of mapping and analysis tools. 

The Hyb2 pipeline is **streamlined** to receive input of fastq/SAM files and generates a hyb file with information on RNA-RNA interactions, and various visualizations of data: contact density map, viewpoint graph, and RNA structure as **outputs in a single command on the Linux command line**. 

Creates a **GUI to easily select and visualize RNA-RNA interactions** from contact density maps, with styling options using VARNA. GUI allows selection of specific interactions directly from the contact density maps, and **generating the corresponding colour-coded RNA secondary structure** in a VARNA GUI pop-up.

## Prerequisites
Linux/ Mac Operating System with Miniconda Installed

1. **Miniconda**, if not installed, read based on your operating system (OS):

> https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
> 
> https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html

2. **Java** or **Java Development Kit (JDK)**:

Download the appropriate version based on your OS, locate the file, then install by double-clicking:
> https://www.oracle.com/java/technologies/downloads

#
Hyb2 can be used on **Windows** with Windows Subsystem for Linux (**WSL**) Installed, Guide Found Here:
> https://github.com/Jylau14/hyb2/blob/main/README_WSL.txt

## Installation
Hyb2 can be downloaded and installed with:

```bash
git clone https://github.com/Jylau14/hyb2.git

# Install Hyb2 on Linux:
cd hyb2/
bin/hyb2_install

# On MacOS, install using:
cd hyb2/
bin/hyb2_install_macOS

# On MacOS-ARM, use:
cd hyb2/
bin/hyb2_install_macOS-arm
```

## Getting Started
To run hyb2 using SAM input file, type in the command line:
```bash
# Linux:
conda activate hyb2

# MacOS:
conda activate hyb2_macOS

# MacOS-ARM:
conda activate hyb2_macOS-arm
```
After activating environment:
```bash
# Hyb2 is an alias added during installation that points towards the directory of installation.
hyb2 -i Hyb2/data/testData.sam -d Hyb2/data/Zika_18S.fasta -o test -a Zika_virusRNA -x 1001 -l 500 
```
To run the program, the first thing to have is the sequence alignment map (SAM) file or a fastq file. Here, we've provided only the SAM file.

If the fastq files from RNA proximity ligation experiments are not mapped to reference sequences, this program contain a function to generate a SAM file using bowtie2.

The second file needed will contain the reference fasta sequences.

**VARNA** is used to visualize the RNA structures. 

### Reference Fasta Files
The following ID format is provided to be more informative:

> \>Gene stable ID version, Transcript stable ID version, Gene name, Gene type
> 
> \>ENSG00000007372.25_ENST00000638963.1_PAX6_mRNA

Or see:
> https://github.com/Jylau14/hyb2/blob/main/data/Zika_18S_formatted.fasta

## Running the Program
Hyb2 environment needs to be activated for essential softwares.

```bash
# Linux:
conda activate hyb2

# MacOS:
conda activate hyb2_macOS

# MacOS-ARM:
conda activate hyb2_macOS-arm
```
**Hyb2**

To get familiar with the command line arguements, it could be broadly explained in 3 parts:

### Converting Input to Hyb Format
-i input_file (fastq/sam)

-d reference_sequences.fasta used for mapping

-o output_prefix

-v blast_threshold (default value: 0.1)

-m max_overlap (default value: 4)

-h max_hits_per_sequence (default value: 10)

-e folding_energy_prediction (default=1 (on)

### Plotting Contact Density Map
-a gene_ID_of_interest

-b 2nd_gene_ID_of_interest

-q upperlimit_for_heatmap_chimeric_count (default value: 0.95 (%) )

### RNA Structure Folding
-x start_coord_of_Arm1 (cannot be longer than nucleotide length of specified gene)

-y start_coord_of_Arm2 (cannot be longer than nucleotide length of specified gene)

-l lengths_of_fragments

-j location of VARNAcmd.jar

-r select preferred RNA folding algorithm (default=1 (ViennaRNA), 0 for UNAFold (software not allowed to be distributed here))

## 
### Analysis of short-range intramolecular interactions:
RNA Structure Folding from 1001-1500nt positions of Zika virus (ZIKV).
```bash
hyb2 -i Hyb2/data/testData.sam -d Hyb2/data/Zika_18S.fasta -o test -a Zika_virusRNA -x 1001 -l 500
```
### Analysis of long-range intramolecular interactions:
RNA Structure Folding of 1001-1500nt positions with 5001-5500nt positions of ZIKV.
```bash
hyb2 -i Hyb2/data/testData.sam -d Hyb2/data/Zika_18S.fasta -o test -a Zika_virusRNA -x 1001 -y 5001 -l 500
```
### Analysis of intermolecular interactions:
RNA Structure Folding of 7501-8000nt positions of ZIKV with 501-550nt positions of 18S rRNA.
```bash
hyb2 -i Hyb2/data/testData.sam -d Hyb2/data/Zika_18S.fasta -o test -a Zika_virusRNA -b 18S_rRNA -x 7501 -y 501 -l 500 
```
### Analysis of homodimer interactions:
RNA Structure Folding of 3501-3700nt positions of ZIKV with 3501-3700nt positions of a second strand of ZIKV. 
```bash
hyb2 -i Hyb2/data/testData.sam -d Hyb2/data/Zika_18S.fasta -o test -a Zika_virusRNA -b Zika_virusRNA -x 3501 -y 3501 -l 200 
```

##
### Contact Density Maps and RNA Folding
Running hyb2 already generates Contact Density Maps and RNA Structures, however, to skip the processing of a fastq/SAM to hyb file and go directly into plotting contact density maps:
```bash
hyb2 -i test.hyb -a 18S_rRNA

# Or
hyb2_coverage -i test.hyb -a 18S_rRNA 
```
To also zoom-in on certain regions on the Contact Density Map:
```bash
hyb2 -i test.hyb -a 18S_rRNA -x 201 -y 201 -l 1200

# Or -w -x -y -z corresponds to x1 x2 y1 and y2
hyb2_coverage -i test.hyb -a 18S_rRNA -w 201 -x 1400 -y 201 -z 1400
```
To plot RNA structures directly using hyb file as input:
```bash
hyb2_fold -i test.hyb -d Hyb2/data/Zika_18S.fasta -a Zika_virusRNA -x 1 -y 1001 -l 200
```

## 
### Randomized Parallel RNA Structure Folding
To perform randomized parellel RNA structure folding, which folds the RNA 1,000 times, and subsequently scoring each structure, a computer cluster that runs **qsub** is required.

Taking the analysis of intermolecular interactions as an example:
```bash
qsub comradesFold2 -c test_Zika_virusRNA-7501-8000_18S_rRNA-501-1000.1-1100_folding_constraints.txt -i Zika_virusRNA-7501-8000_18S_rRNA-501-1000_1-1100.fasta -s 1

comradesScore -i test_Zika_virusRNA-7501-8000_18S_rRNA-501-1000.basepair_scores.txt -f Zika_virusRNA-7501-8000_18S_rRNA-501-1000_1-1100.fasta 
```
##
### Graphical User Interface
To create an interactive GUI pop-up window:
```bash
hyb2_app -i test.hyb -a Zika_virusRNA -d Hyb2/data/Zika_18S.hyb.fasta
```
##
### Differential Coverage Map and Similarity Heatmap
To compare between 2 different proximity ligation experiments, the program incorporates DESeq2 to identify the differential chimeras, and produces a differential coverage map.

To find the conservations between 2 experiments, we look for overlapping interactions.

A minimum of 2 replicates needed for each experiment to be used as input. 

The input files for **hyb2_compare** comes from outputs of the main hyb2 pipeline, a **tab-delimited table needs to be made manually** in the format shown here:
> https://github.com/Jylau14/hyb2/blob/main/data/hyb2_compare_input.table

**MacOS-ARM cannot use hyb2_compare. Several packages in DESeq2 not supported in ARM architecture.**

For example, to identify the differences and similarities between control and experimental conditions:
```bash
hyb2_compare -i input.table -a Zika_virusRNA -d Hyb2/data/Zika_18S.hyb.fasta 
```

## How To Read Outputs
### Hyb files
The first output is a **hyb** file, that contains sequence identifiers, read sequences, 1-based mapping coordinates, and annotation information for each chimera.

There's 17 columns per read:

Column 1: Unique Sequence Identifier

Column 2: Read Sequence

Column 3: Predicted binding energy in kcal/mol.

Columns 4–9: Mapping information for first fragment of read: name of matched transcript, coordinates in read, coordinates in transcript, mapping score.

Columns 10–15: Mapping information for second fragment of read.

Column 16: Overlap Score

Column 17: **Type of Chimera** (See chim_types for a visualization of the types of chimera)
> https://github.com/Jylau14/hyb2/blob/main/bin/chim_types
##
### Contact Density Maps
<p align="middle">
  <img src="https://user-images.githubusercontent.com/110675091/185672361-a9c49db9-9c93-4dff-aa3e-0545a70d36e8.png" height="330" width="330" />
  <img src="https://user-images.githubusercontent.com/110675091/185672386-7175cf64-733e-485e-9639-365df5ce8240.png" height="330" width="330" />
  <img src="https://user-images.githubusercontent.com/110675091/185671422-c84c289c-4b14-4505-847e-1bb869d99e89.png" height="330" width="330" />
</p>

The axis are the genome lengths with each spot representing chimeras. 

Chimeras ligated in 5'-3' and 3'-5' orientations are plotted above and below the diagonal respectively. 

Spots close to the diagonal are short-ranged interactions that can be easily folded into structures, while spots further away are long-ranged interactions. 

The contrast of the spots corresponds to the chimeric counts, with darker spots representing a higher count. 

Although the contrast is capped at an upper quantile limit (default 95%).

If 2 genes were input in the command line, the  nuclotide positions of the first gene will be plotted as the x-axis, and the other on y-axis.
##
### Viewpoint Graphs
<p align="center">
  <img src="https://user-images.githubusercontent.com/110675091/184885181-90b10327-67e6-44ed-87f6-81b896b8defc.png" height="200" width="350">
</p>

The x-axis represents the nucleotide positions and y-axis represents the frequency of chimeric interactions. 

The graph shows the abundance of interactions and its positions along the RNA.


### RNA Structures
<p align="center">
  <img src="https://user-images.githubusercontent.com/110675091/184883583-d92dcdff-803a-4720-bbeb-d6085be9d30f.png" height="150" width="900">
</p>

To understand the secondary structures, read: 
> https://varna.lri.fr/

The structures are colour coded based on log2 of supporting reads, with red being the most supported, blue the least, and blank for none. 

(VARNA instructions)
##
### Hyb2 GUI 
<p align="middle">
  <img src="https://github.com/Jylau14/hyb2/assets/110675091/b9105f5d-8d47-4ca3-9adb-e51e62012fd9" height="350" width="500" />
  <img src="https://github.com/Jylau14/hyb2/assets/110675091/c0dc4f6d-db8a-492b-85fb-272656882b66" height="300" width="450" />
</p>

The GUI shows 3 contact density maps. Highlighting the first contact density map (left) will zoom into the region (plotted in the middle). Highlighting an interaction on the second plot will generate a zoomed-in version of the interaction in the third contact density map (right).

The tables show the coordinates of each interaction, with chimeric counts shown. Uncapped counts refer to the actual chimeric counts, and count refer to counts capped at 95% percentile.

There's options to select what types of RNA-RNA interaction to generate, the start X (and Y) coordinates, and length of RNA to fold. X (and Y) coordinates are automatically inputted based on the highlighted interaction, but can also be entered manually.

Clicking the "Fold RNA" button creates a VARNA GUI pop-up with the colour-coded RNA structure generated.
##
### Differential Coverage Maps & Similarity Heatmap
<p align="center">
  <img src="https://github.com/Jylau14/hyb2/assets/110675091/a7b32e9d-4a4e-46c5-a141-d4df142bc9a1" height="300" width="600">
</p>

Read similarly to **Contact Density Maps**.

However, differential coverage maps are plotted in two colours, with red being interactions enriched in one condition and blue for the other.

Also, instead of the contrast reflecting chimeric counts, here, it represents significance (p-value) for significanyly differential interactions.

Similarity heatmaps plot the conserved interactions between datasets.
