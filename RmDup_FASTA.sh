#!/bin/bash
#SBATCH --mem 4000
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 1-00:00
#SBATCH -J rmdups
#SBATCH -e rmdups_%j.err
#SBATCH -o rmdups_%j.out

INPUT=$1
OUTPUT=$2
minlen=$3

numseq="$(grep -c ">" $INPUT)"
# Number of sequences in the FASTA

> lines2keep.txt

i=1
while [ $i -le $numseq ] 
do
sed -n $(( $i * 2 ))p $INPUT > fullseq.txt
# Output the queried sequence i as a separate text document
seqcount="$(wc -c fullseq.txt | cut -d" " -f1)"
# Calculate the sequence length

if [ $seqcount -ge $minlen ]
# Requires queried sequence to be greater than specified minimum sequence length
then
grep -n "$(cat fullseq.txt)" $INPUT | cut -d":" -f2 > dupseq.txt
grep -n "$(cat fullseq.txt)" $INPUT | cut -d":" -f1 > dupline.txt
# Extract the line numbers and sequences of the group of duplicates matching this sequence

highcount=1
j=1
for n in $(cat dupseq.txt)
do
currcount="$(echo $n | wc -c)"
# Calculate the sequence length of duplicate n
if [ $currcount -gt $highcount ]
# If this sequence is the longest so far...
then
highcount="$currcount"
# Update the length of the longest sequence
highline="$(sed -n ${j}p dupline.txt)"
fi
j="$(( $j + 1 ))"
done

echo $highline >> lines2keep.txt
fi
i="$(( $i + 1 ))"
done

cat lines2keep.txt | sort -n | uniq > uniq_lines2keep.txt
# Sorts and removes duplicates of lines to keep

for m in $(cat uniq_lines2keep.txt)
do
sed -n $(( $m - 1 ))p $INPUT >> $OUTPUT
# Select the FASTA header 
sed -n ${m}p $INPUT >> $OUTPUT
# Select the FASTA sequence
done

# rm dupseq.txt dupline.txt fullseq.txt lines2keep.txt uniq_lines2keep.txt
