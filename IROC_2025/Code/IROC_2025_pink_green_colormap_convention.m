% ICES WGOH IROC red-blue divergent scheme convention 
% for standardised anomalies - set to range -3.5 to 3.5.  
% Central part would be +/- 0.5 in grey shade
% code developed by B. Berx

tmp = cbrewer('div','PiYG',3);
pgc = cat(1,flipud(cbrewer('seq','Greens',6)),tmp(2,:),tmp(2,:),cbrewer('seq','RdPu',6));
pgc(pgc > 1) = 1;
pgc(pgc < 0) = 0;
clear tmp