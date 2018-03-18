# Latin Square Task
Matlab code for the Latin Square Task
This repository contains Matlab scripts to present a computerized, serial response version of the Latin Square Task (Birney et al., 2006). This code was in “The Latin Square Task as a measure of relational reasoning: a replication and assessment of reliability”. Similar versions of this task have been used in other fMRI experiments (Hearne et al., 2017).

The code requires **PsychToolBox 3** and has been tested in Matlab 2013b,2014b and 2017b.

For further correspondence regarding the design of the original Latin Square Task you can [contact Damian Birney](http://damian.birney@sydney.edu.au) – the lead author on the initial papers designing the LST.
For questions regarding this specific implementation you can [contact me](l.hearne@uq.edu.au).

Files included:
-	LST_main
-	Seq.mat – Matlab variable that contains the randomized complexity sequence we used in Hearne et al., 2018
-	present_jitter & setup_LST_stimuli – functions used in LST_main
-	taskData.mat: a 144 (trial) by 17 gridspace (16) + answer (1) matrix. These items were forwarded to me from Graeme Halford (author in Birney et al). There are 12 items in the original LST, however here they are flipped three times + 36 'null' trials. Every third row is an original LST [1 4 7…], while the two after it are the LST trial flipped 90 and 180 degrees. So, 12 trials become 36 in each condition. 

## References
Birney DP, Halford GS, Andrews G (2006) Measuring the Influence of Complexity on Relational Reasoning: The Development of the Latin Square Task. Educ Psychol Meas 66:146–171.
Hearne LJ, Cocchi L, Zalesky A, Mattingley JB (2017) Reconfiguration of brain network architectures between resting-state and complexity-dependent cognitive reasoning. J Neurosci 37:0485–17.

