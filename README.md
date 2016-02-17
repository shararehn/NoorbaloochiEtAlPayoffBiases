README file for archived data and code for fitting the fast-guess LBA model described in:

Noorbaloochi, S. Sharon, D. and McClelland, J. L. (under review), Payoff information biases a fast-guess process in perceptual decision making under deadline pressure: Evidence from behavior, evoked potentials, and quantitative model comparison. Journal of Neuroscience.

This directory contains data files in MATLAB .mat format as well as a subdirectory containing the code used in fitting the fast-guess LBA model to the data.

1)	Details of superEventMatrix_LRPandGripForce_rewLocked.mat

Loading this file will open the following data matrices:

1) LRPMatrix_grand (74165 trials x 2407 variables)
	- Contains the following columns:

1.	subjectID (1:13 subjects)
2.	sessionID 
3.	trialID 
4.	rewCol (-1:reward cue points L, 0: neutral, 1: R)  
5.	stimCol 
6.	respCol (-1: L, 1: R)
7.	rtCol
8.	LRP_allTrials (2400 time pts)
a.	From 400 msec prior to reward(payoff) cue onset to 500 msec after stimulus onset
In stimulus-locked terms: -1900:500 msec
In reward-locked terms: -400:2000 msec
b.	Contain reward locked differential activity from electrodes c3 and c4 used to compute LRP
i.	C3-C4 when response = Right
ii.	C4-c3 when response = Left

2) invalidTrials 
1’s for trials that lack stimulus, reward, or response triggers

3) artifactCol_rewEpoch = 1s for trials with detected artifact in the reward epoch (not used in the paper)

4) gripMatrix_grand (74165 x 2408)
contains the following columns
1.	subjectID
2.	sessionID 
3.	rewCol (-1 Left hi; 0 neutral, 1 right hi)
4.	stimCol (-5 -2 2 or 5 for shifts l or r)
5.	respCol (-1 left, 1 right)
6.	rt 
7.	Lch(1x1200) 
8.	Rch(1x1200)
9.	LforceThresh 
10.	RForceThresh

5) LRPMatrix_grand_col
list of variable column orders

6) gripMatrix_grand_col 
list of variable column orders

2)	Details of stimulusLocked_info.mat
Contains:

1.	noStimTrig: 1 for trials where the stimulus
trigger was not recorded properly (transmission failure between matlab and EEG acquisition computer)

2.	artifactCol_stimEpoch: 1 for trials with detected artifacts in the stimulus epoch (600 msec before stimulus presentation to 400 msec after)

The following matlab code was used to read the data and extract the columns.  This code is available in the file readData.m.

load superEventMatrix_LRPandGripForce_rewLocked
% This will load
% - LRPMatrix_grand (74165 trials x 2409)
% - LRPMatrix_grand_col = subjectID sessionID trialID rewCol stimCol respCol
% consistentCol rtCol areaLRP_200ms_preStim LRP_allTrials (2400 time pts)
% - invalidTrials= trial with no stim, rew, response or onset resp triggers
% - artifactCol_rewEpoch = 1s for trials with detected artifact in the reward
% epoch
% - gripMatrix_grand (74165 x 2410)
% - gripMatrix_grand_col = subjectID sessionID rewCol stimCol onsetRespCol
%         respCol rtOnset rt Lch(1x1200) Rch(1x1200) LforceThresh RForceThresh
time = -400:1999;

load 'stimulusLocked_info_Dec2011.mat' % noStimTrig artifactCol_stimEpoch
 
% deleting trials with no triggers and trials with artifacts detected in
% the [-600, 400] stimulus-locked epoch
numOfSubjects = 13;
LRPMatrix_grand(invalidTrials  | artifactCol_stimEpoch,:)=[];
gripMatrix_grand(invalidTrials  | artifactCol_stimEpoch,:)=[];
subjID = LRPMatrix_grand(:,1);
sessID = LRPMatrix_grand(:,2);
rewCol = LRPMatrix_grand(:,4);
stimCol = LRPMatrix_grand(:,5);
respCol = LRPMatrix_grand(:,6);
rtCol = LRPMatrix_grand(:,8);
conditionInd = sign(rewCol.*stimCol);
correctID = stimCol.*respCol >0;
%% Dynamometer data
tPerSample = 2.358; % this is an approximate time interval between two consecutive samples for the squeezing sensor data
samplePts = [0:tPerSample:1199*tPerSample]-1500;
Lch = gripMatrix_grand(:,9:9+1199);
Rch = gripMatrix_grand(:,9+1200:end-2);
LforceThresh = gripMatrix_grand(:,end-1);
RforceThresh = gripMatrix_grand(:,end);
% baseline for channel defined as 20 samples after reward onset
baseLch = mean(Lch(:,1:20),2);
baseRch = mean(Rch(:,1:20),2);


3)	Details of trialdata.mat.

This data file was used to fit the models in the paper. It contains the following data structure:

trialdata = 

     subjID: [70785x1 double]
     sessID: [70785x1 double]
     rewCol: [70785x1 double](-1 lft hi, 0 neut, 1 rt hi)
    stimCol: [70785x1 double](shift in pixels -5 -2 2 5)
    respCol: [70785x1 double](-1 lft, 1 rt)
      rtCol: [70785x1 double]

Fast-Guess LBA 
This directory contains the MATLAB code for the Fast-guess LBA model, along with its dependent codes.
