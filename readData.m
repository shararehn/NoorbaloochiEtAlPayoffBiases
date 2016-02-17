
load superEventMatrix_LRPandGripForce_rewLocked

% This will load
% - LRPMatrix_grand (74165 trials x 2407)
% - LRPMatrix_grand_col = subjectID sessionID trialID rewCol stimCol respCol
%  rtCol LRP_allTrials (2400 time pts)
% - invalidTrials= trial with no stim, rew, response triggers 
%   (transmission failure between matlab and EEG acquisition computer during the experiment)
% - artifactCol_rewEpoch = 1s for trials with detected artifact in the reward
% epoch
% - gripMatrix_grand (74165 x 2408)
% - gripMatrix_grand_col = subjectID sessionID rewCol stimCol
%         respCol rt Lch(1x1200) Rch(1x1200) LforceThresh RForceThresh

load stimulusLocked_info
% This will load indicators of trials with artifacts detected in
% the [-600, 400] stimulus-locked epoch which was used in the analyses of the paper
% it will also load "noStimTrig" =1 when there was no recorded stimulus
% trigger detected in the EEG data (transmission failure between matlab and
% EEG acquisition computer)


% deleting trials with no triggers and trials with artifacts detected in
% the [-600, 400] stimulus-locked epoch
time = -400:1999;
numOfSubjects = 13;
LRPMatrix_grand(invalidTrials  | artifactCol_stimEpoch,:)=[];
gripMatrix_grand(invalidTrials  | artifactCol_stimEpoch,:)=[];
subjID = LRPMatrix_grand(:,1);
sessID = LRPMatrix_grand(:,2);
rewCol = LRPMatrix_grand(:,4);
stimCol = LRPMatrix_grand(:,5);
respCol = LRPMatrix_grand(:,6);
rtCol = LRPMatrix_grand(:,7);
conditionInd = sign(rewCol.*stimCol);
correctID = stimCol.*respCol >0;
%% Dynamometer data
tPerSample = 2.358; % this is an approximate time interval between two consecutive samples for the squeezing sensor data
samplePts = [0:tPerSample:1199*tPerSample]-1500;
Lch = gripMatrix_grand(:,7:7+1199);
Rch = gripMatrix_grand(:,7+1200:end-2);
LforceThresh = gripMatrix_grand(:,end-1);
RforceThresh = gripMatrix_grand(:,end);
% baseline for channel defined as 20 samples after reward onset
baseLch = mean(Lch(:,1:20),2);
baseRch = mean(Rch(:,1:20),2);
