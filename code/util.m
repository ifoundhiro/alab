%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User: Hirotaka Miura
% Position: Doctoral Student
% Organization: MIT Sloan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/09/2022: Modified.
% 08/09/2022: Previously modified.
% 08/09/2022: Created.
% Description: 
%   - Program to define utility functions.
% Modifications:
%   08/09/2022:
%     - Duplicated from util.m in 
%       /nfs/sloanlab003/projects/malonephi1_proj/hiro/phi2/code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declare class.
classdef util
% Declare method.
methods

    % Function to show job information.
    function show_job_info(obj,progname,disp_packages)
      % Display job information.
      fprintf('***************************\n')
      fprintf('***** Job Information *****\n')
      fprintf('***************************\n')
      fprintf('***** Datetime:          %s\n',datetime)
      fprintf('***** LSF batch job ID:  %s\n',getenv('SLURM_JOB_ID'))
      fprintf('***** Number of core(s): %s\n',getenv('SLURM_JOB_CPUS_PER_NODE'))
      fprintf('***** User:              %s\n',getenv('SLURM_JOB_USER'))
      fprintf('***** Hostname:          %s\n',getenv('SLURMD_NODENAME'))
      fprintf('***** Working directory: %s\n',getenv('PWD'))
      fprintf('***** Program name       %s\n',progname)
      fprintf('***** CPU model name\n')
      [status,cmdout]=system('cat /proc/cpuinfo | grep "model name" | uniq');
      fprintf(cmdout)
      fprintf('***** Platform and software version:\n')
      % Display version info as specified.
      if disp_packages==1
        ver
      elseif disp_packages==0
        ver control
      end
    end
    
    % Function for defining relative paths.
    function preamble(obj)
      % Declare global variable.
      global rawdatapath
      global drvdatapath
      global logpath    
      global plotpath   
      global latexpath  
      global tablespath 
      global rawoutpath 
      global drvoutpath 
      global temppath   
      global docpath    
      global srcdatapath
      global testpath
      global shrrawdatapath
      global shrdrvdatapath
      % Set relative directory paths.
      rawdatapath     = '../data/raw/';
      drvdatapath     = '../data/derived/';
      logpath         = '../output/logs/';
      plotpath        = '../output/plots/';
      latexpath       = '../output/latex/';
      tablespath      = '../output/tables/';
      rawoutpath      = '../output/raw/';
      drvoutpath      = '../output/derived/';
      temppath        = '../temp/';
      docpath         = '../docs/';
      srcdatapath     = '../../data/';
      testpath        = '../test/';
      shrrawdatapath  = '../../share/data/raw/';
      shrdrvdatapath  = '../../share/data/derived/';
    end

  % Close method.
  end
  % Close class.
end
