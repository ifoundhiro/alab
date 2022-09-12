#!/bin/bash
#SBATCH -a 1-11601:1000
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=sched_mit_sloan_batch
#SBATCH --time=1-00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# IMPORTANT NOTES:
#   1) Set array to 1-7751:25
#   2) Set endidx to SLURM_ARRAY_TASK_ID + 24
#   1a) Set array to 7776
#   2a) Set endidx to SLURM_ARRAY_TASK_ID + 16
#   1b) Set array to 1-7776:25
#   2b) Set endidx to SLURM_ARRAY_TASK_ID + 24
#   1c) Set array to 1-7701:100
#   2c) Set endidx to SLURM_ARRAY_TASK_ID + 99
#   1d) Set array to 1-11601:100
#   2d) Set endidx to SLURM_ARRAY_TASK_ID + 99
#   1d) Set array to 1-11601:250
#   2d) Set endidx to SLURM_ARRAY_TASK_ID + 249
#   1d) Set array to 1-11601:500
#   2d) Set endidx to SLURM_ARRAY_TASK_ID + 499
#   1e) Set array to 1-11601:1000
#   2e) Set endidx to SLURM_ARRAY_TASK_ID + 999
#   1f) Set array to 1-3991:10, 4000-7991:10, 8000-11991:10, 7001-11681:20
#   2f) Set endidx to SLURM_ARRAY_TASK_ID + 9
#   1g) Set array to 1-1981:20, 7001-11681:20
#   2g) Set endidx to SLURM_ARRAY_TASK_ID + 19
#   1h) Set array to 1-11676:25
#   2h) Set endidx to SLURM_ARRAY_TASK_ID + 24
#   1i) Set array to 2-11672:30
#   2i) Set endidx to SLURM_ARRAY_TASK_ID
#   1j) Set array to 1-11651:50
#   2j) Set endidx to SLURM_ARRAY_TASK_ID + 49
#
#   interactive nodes with 1 core: --nodelist=node1319,node1295

# Set bash program name.
program="phi2_"
version="p1a5"
# Get current datetime.
datetime="$(date +'%Y%m%d_%H%M%S_%Z')"
# Activate environment.
source activate ../envs/scrphipy39env

# Set input parameters.
test=0
#phitoolboxpath='../../PhiToolbox'
phitoolboxpath='../../phi1/code/PhiToolbox-hiro'
#baseprogname='phi2_p1a4a1'   # With goalkeepers, 0.1 second timesteps.
baseprogname='phi2_p1a4a1a1' # With goalkeepers, 1 second timesteps.
#baseprogname='phi2_p1a4a1b1'  # With goalkeepers, varying timesteps.
#baseprogname='phi2_p1a4b1'   # Without goalkeepers, 0.1 second timesteps.
#baseprogname='phi2_p1a4b1a1' # Without goalkeepers, 1 second timesteps.
type_of_phis="{'star'}"
cutoff_start=0
cutoff_end=0
tau_start=3
tau_end=3
zipfilestart=${SLURM_ARRAY_TASK_ID}
#zipfileend=${SLURM_ARRAY_TASK_ID}
#zipfileend=${SLURM_ARRAY_TASK_ID}+4
#zipfileend=${SLURM_ARRAY_TASK_ID}+9
#zipfileend=${SLURM_ARRAY_TASK_ID}+19
#zipfileend=${SLURM_ARRAY_TASK_ID}+16
#zipfileend=${SLURM_ARRAY_TASK_ID}+24
#zipfileend=${SLURM_ARRAY_TASK_ID}+29
#zipfileend=${SLURM_ARRAY_TASK_ID}+49
#zipfileend=${SLURM_ARRAY_TASK_ID}+99
#zipfileend=${SLURM_ARRAY_TASK_ID}+249
#zipfileend=${SLURM_ARRAY_TASK_ID}+499
zipfileend=${SLURM_ARRAY_TASK_ID}+999
#max_dis_exh=12
max_dis_atm=15
max_gau_exh=17
max_dis_exh=0
#max_dis_atm=0
#max_gau_exh=0
addval=1
#zipfilename_include_patterns='["matchperiod_1H.","matchperiod_2H."]'
#zipfilename_include_patterns='["matchperiod_1H."]'
#zipfilename_include_patterns='["matchperiod_2H."]'
#zipfilename_include_patterns='["matchperiod_"]'
zipfilename_include_patterns='["matchperiod_1H2H.","matchperiod_1H2HE1E2."]'
#zipfilename_include_patterns='["matchperiod_1H2H."]'

# Start/end time to data time step conversion factor.
conversion_factor=60    # For 1 second time steps.
#conversion_factor=600  # For 0.1 second time steps.
# Starting and ending times.  Ending time exclusive.
start_time=70
end_time=120
#end_time=120
#start_time=-9999
#end_time=-9999
# Get converted values.
let start_time_converted=${start_time}*${conversion_factor}
let end_time_converted=${end_time}*${conversion_factor}-1

# Create output folder for outputs.
newoutpath="../output/raw/${program}${version}/${baseprogname}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newoutpath}
# Create output folder for logs.
newpath="../output/logs/${program}${version}/${baseprogname}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newpath}
# Load matlab module.
module load mit/matlab/2019a
# Execute script.
matlab -nodisplay -nodesktop -nosplash -r \
"test=${test};  baseprogname='${baseprogname}'; cutoff_start=${cutoff_start}; cutoff_end=${cutoff_end}; tau_start=${tau_start}; tau_end=${tau_end}; zipfilestart=${zipfilestart}; zipfileend=${zipfileend}; addval=${addval}; phitoolboxpath='${phitoolboxpath}'; type_of_phis="${type_of_phis}"; max_dis_exh=${max_dis_exh}; max_dis_atm=${max_dis_atm}; max_gau_exh=${max_gau_exh}; zipfilename_include_patterns="${zipfilename_include_patterns}"; start_time_converted=${start_time_converted}; end_time_converted=${end_time_converted}; ${program}${version}" \
> ${newpath}/${program}${version}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log 2>&1
