# RmDup_FASTA
A Bash script for removing duplicate sequences from FASTA files
## Execution
Run the following code with parameters specificied in the following order:
1. The first input parameter is your input FASTA file 
2. The second input parameter is the name of the new FASTA file with duplicates removed
3. The third input parameter is the minimum sequence length accepted. Lowering this parameter will result in more sequences being removed as duplicates.
```
sbatch RmDup_FASTA.sh input.fasta output.fasta 100
```
Note that if Sequence A is contained within Sequence B in the same input FASTA, Sequence B will be kept while Sequence A will be removed.
