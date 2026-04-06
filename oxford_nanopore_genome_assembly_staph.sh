# Install (conda/mamba)
mamba create -n staph_phylogeny -c bioconda -c conda-forge snippy raxml-ng snp-dists prokka abricate mash bcftools samtools
mamba activate staph_phylogeny

# 2. download a reference file which is close to Gambia staph genome
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/925/GCF_000013925.1_ASM1392v1_genomic.fna.gz
gunzip GCF_000013925.1_ASM1392v1_genomic.fna.gz
mv GCF_000013925.1_ASM1392v1_genomic.fna USA300.fna
samtools index USA300.fna

module load minimap2
#minimap for alignment of long reads to reference genome
#samtools sort -o aligned.bam 
samtools index reference.fna
#CLAIR3=/mnt/nas2/mdibbasey/structure/clair3_v2.0.0.sif # to generate vcf
# https://github.com/HKU-BAL/Clair3?tab=readme-ov-file#option-1-build-an-environment-with-mambaconda >information about the tool
# https://elifesciences.org/reviewed-preprints/98300 > paper for evidence

# run clair3 like this afterward
INPUT_DIR="[YOUR_INPUT_FOLDER]"        # e.g. /home/user1/input (absolute path needed)
OUTPUT_DIR="[YOUR_OUTPUT_FOLDER]"      # e.g. /home/user1/output (absolute path needed)
THREADS="[MAXIMUM_THREADS]"            # e.g. 8
MODEL_NAME="[r1041_e82_400bps_sup_v430_bacteria_finetuned]"         # singularity exec clair3.sif ls /opt/models/

singularity exec clair3_latest.sif run_clair3.sh \
    -B ${INPUT_DIR},${OUTPUT_DIR} \
    --bam_fn=${INPUT_DIR}/input.bam \    ## change your bam file name here
    --ref_fn=${INPUT_DIR}/ref.fa \       ## change your reference file name here
    --threads=${THREADS} \               ## maximum threads to be used
    --platform="ont" \                   ## options: {ont,hifi,ilmn}
    --model_path="/opt/models/${MODEL_NAME}" \
    --output=${OUTPUT_DIR}

# singularity pull docker pre-built image
#singularity pull docker://hkubal/clair3:latest
module load manimap2
minimap2 -ax map-ont reference.fasta reads.fastq.gz aligned.bam
samtools sort aligned.bam -o aligned_sorted.bam
samtools index aligned_sorted.bam
samtools index bacterial_reference.fasta

# Clair3 calling (ONT bacterial)
singularity exec clair3_v2.0.0.sif run_clair3.sh  \
  --bam_fn aligned_sorted.bam \
  --ref_fn bacterial_reference.fasta \
  --threads 16 \
  --platform ont \
  --model_path r10_minotaur_5mC_v2 \
  --output staph_variants 


for fq in barcode*.fastq.gz; do
  ID=$(basename $fq .fastq.gz)
  echo "Processing $ID..."
  singularity exec clair3_v2.0.0.sif run_clair3.sh \
    --outdir ${ID}_clair3 \
    --se $fq \
    --cpus 16 \
    --reference reference.fna \
    --mincov 10 \
    --minfrac 0.9
done
######################################################################################################################################
# NB: this information below are very important for meta data construction and downstream analysis, make sure to keep track of the sample names and their corresponding barcodes
starterd with 32
[mdibbasey@mrc.gm@topato mecA]$ mv b11_19/ barcode33/
[mdibbasey@mrc.gm@topato mecA]$ mv b11_70/ barcode34/
[mdibbasey@mrc.gm@topato mecA]$ mv b11_95/ barcode35/
[mdibbasey@mrc.gm@topato mecA]$ mv b12_60/ barcode36/
[mdibbasey@mrc.gm@topato mecA]$ mv b2_9_26/ barcode37/
# barcode15 (barcode15.fastq.gz) of MRSA was renamed to barcode75_merged.fastq.gz
# Barcode17 is staph epidermis, hence removed from the analysis

# variant calling using clair3 pipeline for each sample
#!/bin/bash
#SBATCH --job-name=clair3_staph
#SBATCH --output=clair3_staph_%j.out
#SBATCH --error=clair3_staph_%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00
#SBATCH --partition=main
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mdibbasey@mrc.gm

SAMPLE="barcode*_merged"
REF="/mnt/nas2/mdibbasey/staph_phylogentic_analysis/mecA/reference.fna"
THREADS=16
MODEL_PATH="/opt/models/r1041_e82_400bps_sup_v430_bacteria_finetuned"  # adjust after checking above

# Step 1: Align with minimap2
module load minimap2 samtools
#samtools faidx $REF
minimap2 -ax map-ont -t $THREADS $REF ${SAMPLE}.fastq.gz \
  | samtools sort -o ${SAMPLE}.sorted.bam
samtools index ${SAMPLE}.sorted.bam

# Run Clair3 via Singularity
module load singularity
singularity exec /mnt/nas2/mdibbasey/staph_phylogentic_analysis/clair3.sif run_clair3.sh \
  --bam_fn=${SAMPLE}.sorted.bam \
  --ref_fn=$REF \
  --threads=$THREADS \
  --platform=ont \
  --model_path=$MODEL_PATH \
  --output=/mnt/nas2/mdibbasey/staph_phylogentic_analysis/mecA/${SAMPLE}_clair3_output/
  --include_all_ctgs \        # to include all contigs in the output, adjust if you want only specific regions
  --no_phasing_for_fa \
  --haploid_precise 

# extract high quality snp
bcftools view -v snps clair3_output/merge_output.vcf.gz | \
bcftools filter -e 'QUAL<30 || DP<20' > filtered_snps.vcf
# install IQ_tree= done, 
iqtree 
# use ggtree using R or figtree to visualise the phylogenrtic
# 7. Visualization using tools like iTOL or FigTree to visualize the generated phylogenetic tree.

# Inputs: fastq.gz (ONT reads, >30x coverage, ~300Mb for bacteria)

######################################################################################################################################

# post vcf processing of clair3 output for downstream analysis, such as phylogenetic tree construction and population structure analysis
# per-isolate QC filtering
bcftools norm -f reference.fna -Oz -o filtered_snps.norm.vcf.gz filtered_snps.vcf
bcftools index filtered_snps.norm.vcf.gz
# generate a multi-sample vcf for all the isolates, then perform phylogenetic tree construction using iqtree or raxml-ng, and population structure analysis using faststructure or admixture
# for multi-sample vcf generation, you can use bcftools merge or GATK CombineVariants, or you can use a reference-based approach to generate a consensus sequence for each isolate and then perform multiple sequence alignment using tools like MAFFT or Clustal Omega, followed by tree

bcftools filter -e 'QUAL<30 || DP<20' filtered_snps.norm.vcf.gz  -Oz -o sample.filtered.vcf.gz 
# keep snps only for phylogeny
bcftools view -v snps sample.filtered.vcf.gz -Oz -o sample.filtered.snps.vcf.gz
bctools index sample.filtered.snps.vcf.gz
# generate a multi-sample vcf for all the isolates, then perform phylogenetic tree construction using iqtree or raxml-ng, and population structure analysis using faststructure or admixture
# for multi-sample vcf generation, you can use bcftools merge or GA

# merge all the filtered snps vcf into a multi-sample vcf
ls *.filtered.snps.vcf.gz > vcf_list.txt
bcftools merge -m all -Oz -o merged_snps.vcf.gz -l vcf_list.txt 
bcftools index merged_snps.vcf.gz

# generate a core snp alignment for phylogenetic tree construction using iqtree or raxml-ng
# using snp-sites to generate a core snp alignment in fasta format
snp-sites -o -c core_snps.fasta merged_snps.vcf.gz
# then use iqtree or raxml-ng to construct the phylogenetic tree
iqtree -s core_snps.fasta -m GTR+G -nt AUTO -bb 1000 -alrt 1000


# quick check of the vcf
samtools flagstat barcode*_merged.sorted.bam
bcftools view -v snps barcode*_merged_clair3_output/merge_output.vcf.gz | grep -v "^#" | wc -l

for bam in barcode*_merged.sorted.bam; do
    echo "$(basename $bam .sorted.bam): $(samtools flagstat $bam | grep 'primary mapped' | cut -f1 -d'(' | sed 's/%//')"
done | sort -k2 -nr

# using actual sample names instead of barcode names for downstream analysis, make sure to keep track of the sample names and their corresponding barcodes

# For each barcode folder, extract true sample ID
# Fixed loop for your actual files
for fq in barcode*_merged.fastq.gz; do
    SAMPLE=$(basename $fq _merged.fastq.gz)
    echo -n "$SAMPLE: "
    zcat $fq | head -n1 | grep -o 'sample_id=[^ ]*' | head -1
done

barcode01: sample_id=saureus240925batch10
barcode02: sample_id=saureus240925batch10
barcode03: sample_id=saureus240925batch10
barcode04: sample_id=saureus240925batch10
barcode05: sample_id=saureus240925batch10
barcode06: sample_id=saureus240925batch10
barcode07: sample_id=saureus240925batch10
barcode08: sample_id=saureus240925batch10
barcode09: sample_id=saureus240925batch10
barcode10: sample_id=saureus240925batch10
barcode11: sample_id=saureus240925batch10
barcode12: sample_id=saureus240925batch10
barcode13: sample_id=saureus240925batch10
barcode14: sample_id=saureus240925batch10
barcode15: sample_id=saureus240925batch10
barcode16: sample_id=saureus240925batch10
barcode18: sample_id=saureus240925batch10
barcode19: sample_id=saureus240925batch10
barcode20: sample_id=saureus240925batch10
barcode21: sample_id=saureus240925batch10
barcode22: sample_id=saureus240925batch10
barcode23: sample_id=saureus240925batch10
barcode24: sample_id=saureus240925batch10
barcode25: sample_id=saureus240925batch10
barcode26: sample_id=saureus240925batch10
barcode27: sample_id=saureus240925batch10
barcode28: sample_id=saureus240925batch10
barcode29: sample_id=saureus240925batch10
barcode30: sample_id=saureus240925batch10
barcode31: sample_id=saureus240925batch10
barcode53: sample_id=Saureusprojectbatch2_9_3042025
barcode54: sample_id=saureus240925batch10
barcode56: sample_id=Saureusprojectbatch2_9_3042025
barcode57: sample_id=Saureusprojectbatch2_9_3042025
barcode60: sample_id=Saureusprojectbatch2_9_3042025
barcode66: sample_id=Saureusprojectbatch2_9_3042025
barcode67: sample_id=Saureusprojectbatch2_9_3042025
barcode74: sample_id=saureus240925batch10
barcode75: sample_id=SaureusProjectBatch7_8_03042025


#!/bin/bash
REF="/mnt/nas2/mdibbasey/staph_phylogentic_analysis/mecA/reference.fna"
OUTDIR="staph_phylogeny"

mkdir -p $OUTDIR

# Process each isolate
for vcfdir in barcode*_merged_clair3_output; do
    SAMPLE=$(basename $vcfdir _merged_clair3_output)
    
    echo "Processing $SAMPLE..."
    
    # Normalize + filter
    bcftools norm -f $REF -m-any \
        ${vcfdir}/merge_output.vcf.gz -Oz -o ${OUTDIR}/${SAMPLE}.norm.vcf.gz
    
    #bcftools filter -i 'FILTER="PASS" && QUAL>=15 && DP>=30 && FORMAT/DP>=20 && GQ>=20 && AF>=0.80 && AF<=0.99' \
    #-Oz -o ${OUTDIR}/${SAMPLE}.filt.vcf.gz ${OUTDIR}/${SAMPLE}.norm.vcf.gz && \
    #bcftools index ${OUTDIR}/${SAMPLE}.filt.vcf.gz

    bcftools filter -i 'FILTER="PASS" -Oz -o ${OUTDIR}/${SAMPLE}.filt.vcf.gz ${OUTDIR}/${SAMPLE}.norm.vcf.gz && \
    bcftools index ${OUTDIR}/${SAMPLE}.filt.vcf.gz
    
    # SNPs only
    bcftools view -v snps ${OUTDIR}/${SAMPLE}.filt.vcf.gz -Oz -o ${OUTDIR}/${SAMPLE}.snps.vcf.gz
    tabix -p vcf ${OUTDIR}/${SAMPLE}.snps.vcf.gz
done

# Merge all samples
ls ${OUTDIR}/*.snps.vcf.gz > ${OUTDIR}/vcf_list.txt

#rename the sample names in the vcf header to actual sample names instead of barcode names for downstream analysis, 
# make sure to keep track of the sample names and their corresponding barcodes
# for v in ${OUTDIR}/*.snps.vcf.gz; do
#     SAMPLE=$(basename $v .snps.vcf.gz)
#     ACTUAL_NAME=$(zcat ${SAMPLE}_merged.fastq.gz | head -n1 | grep -o 'sample_id=[^ ]*' | head -1 | cut -d= -f2)
#     bcftools annotate -x ID -Oz -o ${OUTDIR}/${ACTUAL_NAME}.snps.vcf.gz $v && \
#     tabix -p vcf ${OUTDIR}/${ACTUAL_NAME}.snps.vcf.gz
# done

#OR

#mkdir -p staph_phylogeny/renamed_vcfs
for vcf in staph_phylogeny/*.snps.vcf.gz
do
    sample=$(basename $vcf .snps.vcf.gz)
    echo $sample > sample_name.txt
    bcftools reheader \
        -s sample_name.txt \
        -o staph_phylogeny/renamed_vcfs/${sample}.vcf.gz \
        $vcf

    tabix -p vcf staph_phylogeny/renamed_vcfs/${sample}.vcf.gz
done

bcftools merge -m all -Oz -o ${OUTDIR}/all_isolates.snps.merged.vcf.gz -l ${OUTDIR}/vcf_list.txt
tabix -p vcf ${OUTDIR}/all_isolates.snps.merged.vcf.gz

# Core SNP alignment
snp-sites -c -o ${OUTDIR }/core_snps.aln.fa ${OUTDIR}/all_isolates.snps.merged.vcf.gz

python vcf2phylip.py -i all_isolates.snps.merged.vcf.gz -o all_isolates.snps.merged.core.phy --min-samples 20

# Quick stats
echo "Core SNPs: $(grep -v '>' ${OUTDIR}/core_snps.aln.fa | tr -d '\n' | grep -o . | sort | uniq -c | wc -l)"

# Phylogenetic tree construction using IQ-TREE
iqtree -s core_snps.aln.fa \
        -m GTR+F+I+G4 \
        -T AUTO \
        -B 1000 \
        --prefix staph_tree \
        --seed 123 \
        -fconst 1,1,1,1




(Dibbasey) [mdibbasey@mrc.gm@topato mecA]$ 
for v in barcode*_merged_clair3_output/merge_output.vcf.gz; do
    echo $v
    bcftools view -v snps $v | grep -v "^#" | wc -l
done

barcode01_merged_clair3_output/merge_output.vcf.gz
77562
barcode02_merged_clair3_output/merge_output.vcf.gz
30564
barcode03_merged_clair3_output/merge_output.vcf.gz
28253
barcode04_merged_clair3_output/merge_output.vcf.gz
29036
barcode05_merged_clair3_output/merge_output.vcf.gz
29429
barcode06_merged_clair3_output/merge_output.vcf.gz
27162
barcode07_merged_clair3_output/merge_output.vcf.gz
28610
barcode08_merged_clair3_output/merge_output.vcf.gz
29521
barcode09_merged_clair3_output/merge_output.vcf.gz
29629
barcode10_merged_clair3_output/merge_output.vcf.gz
54533
barcode11_merged_clair3_output/merge_output.vcf.gz
23958
barcode12_merged_clair3_output/merge_output.vcf.gz
52632
barcode13_merged_clair3_output/merge_output.vcf.gz
29609
barcode14_merged_clair3_output/merge_output.vcf.gz
26405
barcode15_merged_clair3_output/merge_output.vcf.gz
51786
barcode16_merged_clair3_output/merge_output.vcf.gz
28362
barcode17_merged_clair3_output/merge_output.vcf.gz=328033
barcode18_merged_clair3_output/merge_output.vcf.gz=64143
barcode19_merged_clair3_output/merge_output.vcf.gz=76626
barcode20_merged_clair3_output/merge_output.vcf.gz
29791
barcode21_merged_clair3_output/merge_output.vcf.gz
30225
barcode22_merged_clair3_output/merge_output.vcf.gz=76244
barcode23_merged_clair3_output/merge_output.vcf.gz
27349
barcode24_merged_clair3_output/merge_output.vcf.gz
29369
barcode25_merged_clair3_output/merge_output.vcf.gz
28727
barcode26_merged_clair3_output/merge_output.vcf.gz
28913
barcode27_merged_clair3_output/merge_output.vcf.gz=66300
barcode28_merged_clair3_output/merge_output.vcf.gz
28884
barcode29_merged_clair3_output/merge_output.vcf.gz
30255
barcode30_merged_clair3_output/merge_output.vcf.gz
29288
barcode31_merged_clair3_output/merge_output.vcf.gz
28741
barcode32_merged_clair3_output/merge_output.vcf.gz
29520
barcode33_merged_clair3_output/merge_output.vcf.gz
29330
barcode34_merged_clair3_output/merge_output.vcf.gz
29135
barcode35_merged_clair3_output/merge_output.vcf.gz=287481
barcode36_merged_clair3_output/merge_output.vcf.gz=33280
barcode37_merged_clair3_output/merge_output.vcf.gz=318711
barcode38_merged_clair3_output/merge_output.vcf.gz=327895
barcode39_merged_clair3_output/merge_output.vcf.gz
31268
barcode40_merged_clair3_output/merge_output.vcf.gz
29744
barcode41_merged_clair3_output/merge_output.vcf.gz
11046
barcode42_merged_clair3_output/merge_output.vcf.gz
30602
barcode51_merged_clair3_output/merge_output.vcf.gz
31268
barcode53_merged_clair3_output/merge_output.vcf.gz
30289
barcode54_merged_clair3_output/merge_output.vcf.gz
37955
barcode56_merged_clair3_output/merge_output.vcf.gz
5634
barcode57_merged_clair3_output/merge_output.vcf.gz
5813
barcode60_merged_clair3_output/merge_output.vcf.gz
30431
barcode66_merged_clair3_output/merge_output.vcf.gz
5834
barcode67_merged_clair3_output/merge_output.vcf.gz
28401
barcode74_merged_clair3_output/merge_output.vcf.gz
29369
barcode75_merged_clair3_output/merge_output.vcf.gz
29616
(Dibbasey) [mdibbasey@mrc.gm@topato mecA]$ samtools flagstat barcode17.bam
[E::hts_open_format] Failed to open file "barcode17.bam" : No such file or directory
samtools flagstat: Cannot open input file "barcode17.bam": No such file or directory
(Dibbasey) [mdibbasey@mrc.gm@topato mecA]$ ls -lh



claude.sh
#!/bin/bash
# =============================================================================
# Staph aureus phylogeny pipeline — Clair3 VCFs (mecA focus)
# Uses vcf2phylip.py for VCF → alignment conversion (direct, no consensus step)
# =============================================================================
set -euo pipefail

REF="/mnt/nas2/mdibbasey/staph_phylogentic_analysis/mecA/reference.fna"
OUTDIR="staph_phylogeny"
RENAMED="${OUTDIR}/renamed_vcfs"
THREADS=16
MIN_SNPS=10          # isolates with fewer SNPs are skipped
SKIP_LIST=()
VCF2PHYLIP="${OUTDIR}/vcf2phylip.py"

# Confirm vcf2phylip.py is present and executable
if [[ ! -f "${VCF2PHYLIP}" ]]; then
    echo "ERROR: vcf2phylip.py not found at ${VCF2PHYLIP}"
    echo "       Place it in the working directory or update the VCF2PHYLIP variable."
    exit 1
fi

mkdir -p "${OUTDIR}" "${RENAMED}"

echo "=== Staph aureus phylogeny pipeline ==="
echo "Reference:   ${REF}"
echo "Output:      ${OUTDIR}"
echo "vcf2phylip:  ${VCF2PHYLIP}"
echo ""

# =============================================================================
# 1. Per-isolate VCF processing (Clair3 PASS SNPs only)
# =============================================================================
echo "--- Step 1: Per-isolate VCF filtering ---"

for vcfdir in barcode*_merged_clair3_output; do
    [[ -d "$vcfdir" ]] || { echo "  No barcode directories found."; break; }
    SAMPLE=$(basename "${vcfdir}" _merged_clair3_output)
    echo "Processing ${SAMPLE}..."

    # Normalize: left-align indels, split multi-allelic sites
    bcftools norm \
        --fasta-ref "${REF}" \
        --multiallelics - \
        "${vcfdir}/merge_output.vcf.gz" \
        --output-type z \
        --output "${OUTDIR}/${SAMPLE}.norm.vcf.gz"
    bcftools index --csi "${OUTDIR}/${SAMPLE}.norm.vcf.gz"

    # Filter: PASS SNPs only (single call — no redundant double-filter)
    bcftools view \
        --apply-filters PASS \
        --types snps \
        --output-type z \
        --output "${OUTDIR}/${SAMPLE}.snps.vcf.gz" \
        "${OUTDIR}/${SAMPLE}.norm.vcf.gz"
    bcftools index --csi "${OUTDIR}/${SAMPLE}.snps.vcf.gz"

    # Guard: skip isolates with too few SNPs
    COUNT=$(bcftools view -H "${OUTDIR}/${SAMPLE}.snps.vcf.gz" | wc -l)
    if [[ "$COUNT" -lt "$MIN_SNPS" ]]; then
        echo "  WARNING: ${SAMPLE} has only ${COUNT} PASS SNPs (< ${MIN_SNPS}), skipping."
        SKIP_LIST+=("${SAMPLE}")
        continue
    fi

    echo "  -> ${SAMPLE}: ${COUNT} PASS SNPs"
done

if [[ ${#SKIP_LIST[@]} -gt 0 ]]; then
    echo ""
    echo "Skipped isolates (insufficient SNPs): ${SKIP_LIST[*]}"
fi
echo ""

# =============================================================================
# 2. Rename VCF sample headers (barcode IDs → clean names)
# =============================================================================
echo "--- Step 2: Renaming VCF headers ---"

for vcf in "${OUTDIR}"/*.snps.vcf.gz; do
    sample=$(basename "${vcf}" .snps.vcf.gz)
    echo "${sample}" > "${OUTDIR}/tmp_samples.txt"
    bcftools reheader \
        --samples "${OUTDIR}/tmp_samples.txt" \
        "${vcf}" \
        --output "${RENAMED}/${sample}.vcf.gz"
    bcftools index --csi "${RENAMED}/${sample}.vcf.gz"
done
rm -f "${OUTDIR}/tmp_samples.txt"

N_ISOLATES=$(ls "${RENAMED}"/*.vcf.gz 2>/dev/null | wc -l)
echo "Renamed ${N_ISOLATES} isolates."
echo ""

# =============================================================================
# 3. Merge all isolates into a single multi-sample VCF
#    --missing-to-ref: absent calls become REF (not ./.)
#    Prevents core SNP sites from being silently discarded downstream
# =============================================================================
echo "--- Step 3: Merging ${N_ISOLATES} isolates ---"

ls "${RENAMED}"/*.vcf.gz > "${OUTDIR}/vcf_list.txt"

bcftools merge \
    --file-list "${OUTDIR}/vcf_list.txt" \
    --missing-to-ref \
    --merge snps \
    --threads "${THREADS}" \
    --output-type z \
    --output "${OUTDIR}/merged.snps.vcf.gz"
bcftools index --csi "${OUTDIR}/merged.snps.vcf.gz"

TOTAL_SITES=$(bcftools view -H "${OUTDIR}/merged.snps.vcf.gz" | wc -l)
echo "Merged VCF: ${TOTAL_SITES} SNP sites across ${N_ISOLATES} samples."
echo ""

# =============================================================================
# 4. VCF → PHYLIP alignment using vcf2phylip.py
#    vcf2phylip.py takes the merged multi-sample VCF directly —
#    no per-sample consensus FASTA step needed.
#
#    Key flags used:
#      -i  : input VCF (gzipped OK)
#      -o  : output directory
#      -m 1: minimum number of samples that must have data at a site (1 = all)
#             increase to e.g. -m 2 to tolerate 1 missing sample per site
#      --output-folder: where to write the .phy and .fasta outputs
#
#    vcf2phylip outputs:
#      *.min1.phy       — PHYLIP format (for IQ-TREE)
#      *.min1.fasta     — FASTA format  (for snp-sites or inspection)
# =============================================================================
echo "--- Step 4: VCF → alignment with vcf2phylip.py ---"

python3 "${VCF2PHYLIP}" \
    --input "${OUTDIR}/merged.snps.vcf.gz" \
    --output-folder "${OUTDIR}" \
    --min-samples-locus 1 \
    --fasta

# vcf2phylip names outputs based on the input filename — locate them
PHYLIP_FILE=$(ls "${OUTDIR}"/merged.snps*.phy 2>/dev/null | head -1)
FASTA_FILE=$(ls "${OUTDIR}"/merged.snps*.fasta 2>/dev/null | head -1)

if [[ -z "${PHYLIP_FILE}" ]]; then
    echo "ERROR: vcf2phylip.py did not produce a .phy file in ${OUTDIR}"
    echo "       Check vcf2phylip output above for errors."
    exit 1
fi

echo "  PHYLIP alignment: ${PHYLIP_FILE}"
echo "  FASTA alignment:  ${FASTA_FILE}"

# Parse alignment dimensions from PHYLIP header (line 1: "N_samples  N_sites")
NSAMPLES=$(head -1 "${PHYLIP_FILE}" | awk '{print $1}')
NSITES=$(head -1 "${PHYLIP_FILE}" | awk '{print $2}')
echo "  Samples: ${NSAMPLES},  SNP sites: ${NSITES}"
echo ""

if [[ "$NSITES" -lt 1 ]]; then
    echo "ERROR: No variable sites in alignment."
    echo "       Try --min-samples-locus 2 or review merged VCF site count."
    exit 1
fi

# =============================================================================
# 5. Quality checks
# =============================================================================
echo "--- Step 5: Quality checks ---"

bcftools stats "${OUTDIR}/merged.snps.vcf.gz" > "${OUTDIR}/vcf_stats.txt"

# Ti/Tv from bcftools stats — correct method
TITV=$(grep  "^TSTV" "${OUTDIR}/vcf_stats.txt" | awk '{printf "%.2f", $5}')
NTRANS=$(grep "^TSTV" "${OUTDIR}/vcf_stats.txt" | awk '{print $3}')
NTRV=$(grep   "^TSTV" "${OUTDIR}/vcf_stats.txt" | awk '{print $4}')

echo "  Ti/Tv ratio:   ${TITV}  (Ts: ${NTRANS}, Tv: ${NTRV})"
echo "  Expected range for bacterial SNPs: 1.0–2.5"

# Warn if Ti/Tv is suspicious (compare integer part)
TITV_INT=${TITV%.*}
if (( TITV_INT < 1 || TITV_INT > 4 )); then
    echo "  WARNING: Ti/Tv ${TITV} outside expected range — review variant calls."
fi

# Per-sample SNP counts
echo ""
echo "  Per-sample SNP counts:"
bcftools stats -s - "${OUTDIR}/merged.snps.vcf.gz" \
    | grep "^PSC" \
    | awk '{printf "    %-25s  SNPs: %s\n", $3, $5}'
echo ""

# Missing data summary from vcf2phylip (it prints a locus summary — capture it)
echo "  Alignment missing data: see ${OUTDIR}/vcf_stats.txt for full stats."
echo ""

# =============================================================================
# 6. iqtree phylogeny
#    Input: PHYLIP alignment from vcf2phylip (IQ-TREE natively reads PHYLIP)
#    GTR+G4:   appropriate for SNP-only alignments
#    GTR+I+G4: use instead if alignment includes invariant sites
#    -bb 1000: ultrafast bootstrap (UFBoot)
#    -alrt 1000: SH-aLRT branch support
#    --redo:   overwrite existing run (safe for re-runs)
#    +ASC:     ascertainment bias correction — add if alignment is SNPs-only
#              and you want to correct for only seeing variable sites.
#              Use: -m GTR+ASC+G4
#              Note: ASC requires no invariant columns — vcf2phylip output
#              is SNP-only so ASC is appropriate here.
# =============================================================================
echo "--- Step 6: IQ-TREE2 phylogeny ---"

mkdir -p "${OUTDIR}/iqtree"

iqtree3 \
    -s "${PHYLIP_FILE}" \
    -m GTR+F+G4 \
    -T "${THREADS}" \
    -bb 1000 \
    -alrt 1000 \
    --seed 12345 \
    --redo \
    --prefix "${OUTDIR}/iqtree/staph_tree"

echo ""

# =============================================================================
# 7. Summary
# =============================================================================
echo "========================================"
echo "         PIPELINE COMPLETE"
echo "========================================"
echo ""
echo "  Isolates processed:  ${N_ISOLATES}"
if [[ ${#SKIP_LIST[@]} -gt 0 ]]; then
echo "  Isolates skipped:    ${#SKIP_LIST[@]}  (${SKIP_LIST[*]})"
fi
echo "  SNP sites (merged):  ${TOTAL_SITES}"
echo "  Alignment sites:     ${NSITES}"
echo "  Samples in tree:     ${NSAMPLES}"
echo "  Ti/Tv ratio:         ${TITV}"
echo ""
echo "  Key outputs:"
echo "    Merged VCF:        ${OUTDIR}/merged.snps.vcf.gz"
echo "    PHYLIP alignment:  ${PHYLIP_FILE}"
echo "    FASTA alignment:   ${FASTA_FILE}"
echo "    Tree (Newick):     ${OUTDIR}/iqtree/staph_tree.treefile"
echo "    VCF stats:         ${OUTDIR}/vcf_stats.txt"
echo "    IQ-TREE log:       ${OUTDIR}/iqtree/staph_tree.log"
echo ""
echo "  Node support format: SH-aLRT / UFBoot (e.g. 95/99 = well-supported)"
echo "  Visualize tree:      iTOL (https://itol.embl.de) or FigTree"
echo "========================================"