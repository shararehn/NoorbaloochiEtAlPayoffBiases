function [ higivenhl, logivenhl] = dataHist_perSubj( trialdata,subjNum, step)
% compute the histogram of the data for each subject
% [ higivenhl, logivenhl] = dataHist_perSubj( trialdata,subjNum, step)
% higivenhl(1,:): # of trials where response is toward the higher reward for the cong
% higivenhl(2,:) same as above for incongruent
% higivenhl(3,:) num of correct trials/bin in the neutral condition

load(trialdata)

conditionInd = sign(trialdata.rewCol.*trialdata.stimCol);
correctID = trialdata.stimCol.*trialdata.respCol >0;
thisSubj = trialdata.subjID ==subjNum;
rtCol = 1000*trialdata.rtCol; % convert to msec

nBins = [ 1:step:700];

[yycc,xxcc]=hist(rtCol(conditionInd == 1 & correctID & thisSubj ),nBins);
[yyic,xxic]=hist(rtCol(conditionInd == -1 & correctID & thisSubj),nBins);
[yyce,xxce]=hist(rtCol(conditionInd == 1 & ~correctID & thisSubj),nBins);
[yyie,xxie]=hist(rtCol(conditionInd == -1 & ~correctID & thisSubj),nBins);
[yync,xxnc]=hist(rtCol(conditionInd == 0 & correctID & thisSubj),nBins);
[yyne,xxne]=hist(rtCol(conditionInd == 0 & ~correctID & thisSubj),nBins);

higivenhl(1,:)= yycc;
higivenhl(2,:) = yyie;
logivenhl(1,:) = yyce;
logivenhl(2,:)= yyic;
higivenhl(3,:) = yync;
logivenhl(3,:)= yyne;
end
