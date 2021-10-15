#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=smriprep_sub-4262024.job
#SBATCH --output=/scratch/fnadeau/cima-q/1633992344/smriprep_sub-4262024.out
#SBATCH --error=/scratch/fnadeau/cima-q/1633992344/smriprep_sub-4262024.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4096M
#SBATCH --mail-user=francois.nadeau.1@umontreal.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

export SINGULARITYENV_FS_LICENSE=$HOME/.freesurfer.txt
export SINGULARITYENV_TEMPLATEFLOW_HOME=/templateflow

module load singularity/3.8

#copying input dataset into local scratch space
rsync -rltv --info=progress2 --exclude="sub*" --exclude="derivatives" /project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q $SLURM_TMPDIR
rsync -rltv --info=progress2 /project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q/sub-4262024 $SLURM_TMPDIR/cima-q

singularity run --cleanenv -B $SLURM_TMPDIR:/DATA -B /home/fnadeau/.cache/templateflow:/templateflow -B /etc/pki:/etc/pki/ -B /scratch/fnadeau/cima-q/1633992344:/OUTPUT /lustre03/project/6003287/containers/fmriprep-20.2.1lts.sif -w /DATA/fmriprep_work --participant-label 4262024  --bids-database-dir /DATA/cima-q/.pybids_cache  --bids-filter-file /OUTPUT/bids_filters.json   --output-spaces MNI152NLin2009cAsym MNI152NLin6Asym fsnative anat --output-layout bids --notrack --skip_bids_validation --write-graph --omp-nthreads 8 --nprocs 16 --mem_mb 65536 --resource-monitor /DATA/cima-q /project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q/derivatives participant 
fmriprep_exitcode=$?
if [ $fmriprep_exitcode -ne 0 ] ; then cp -R $SLURM_TMPDIR/fmriprep_work /scratch/fnadeau/cima-q/1633992344/smriprep_sub-4262024.workdir ; fi 
if [ $fmriprep_exitcode -eq 0 ] ; then cp $SLURM_TMPDIR/fmriprep_work/fmriprep_wf/resource_monitor.json /scratch/fnadeau/cima-q/1633992344/smriprep_sub-4262024_resource_monitor.json ; fi 
if [ $fmriprep_exitcode -eq 0 ] ; then mkdir -p /scratch/fnadeau/cima-q/1633992344//project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q/derivatives-cima-q ; fi 
if [ $fmriprep_exitcode -eq 0 ] ; then cp -R /project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q/derivatives/* /scratch/fnadeau/cima-q/1633992344//project/rrg-pbellec/fnadeau/fnadeau_cimaq_preproc/data/cima-q/derivatives-cima-q/ ; fi 
exit $fmriprep_exitcode 
