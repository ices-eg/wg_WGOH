% ICES WGOH IROC red-blue divergent scheme convention 
% for standardised anomalies - set to range -3.5 to 3.5.  
% Central part would be +/- 0.5 in grey shade
% code developed by B. Berx

tmp = cbrewer('div','PiYG',3);
rbc = cat(1,flipud(cbrewer('seq','Blues',6)),tmp(2,:),tmp(2,:),cbrewer('seq','Reds',6));
rbc(rbc > 1) = 1;
rbc(rbc < 0) = 0;
clear tmp