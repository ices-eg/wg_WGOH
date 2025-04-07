clear all;close all;clc

fname = [getenv('Bathy') '\GEBCO_2024_NAtlantic\gebco_2024_n90.0_s0.0_w-100.0_e50.0.nc'];
ncdisp(fname)

lon = ncread(fname,'lon');
lat = ncread(fname,'lat');
eta = ncread(fname,'elevation');

sub5.lon = lon(1:20:end);
sub5.lat = lat(1:20:end);
sub5.eta = eta(1:20:end,1:20:end);

[sub5.xx,sub5.yy]=meshgrid(sub5.lon,sub5.lat);

F_Eta = griddedInterpolant(sub5.xx',sub5.yy',double(sub5.eta));

pcolor(sub5.xx,sub5.yy,sub5.eta'),shading flat,colorbar
caxis([-1000 0])
hold on
[cc,hh] = contour(sub5.xx,sub5.yy,sub5.eta',[-500 0],'k');


close all
pcolor(sub5.xx,sub5.yy,sub5.eta'),shading flat,colorbar
caxis([-1000 0])
hold on

[regiondata]=fun_load_regions('LMR',0);

IROC_newregions.regionname1 = 'Baffin Bay';
IROC_newregions.regionname2 = 'Northeast American Shelf';
IROC_newregions.regionname3 = 'North Atlantic Subpolar Gyre';
IROC_newregions.regionname4 = 'Biscay, Iberia and Canaries';
IROC_newregions.regionname5 = 'Nordic and Barents Seas';
IROC_newregions.regionname6 = 'Northwest European Shelf';
IROC_newregions.regionname7 = 'Baltic Sea';

IROC_newregions.region1 = [NaN,NaN];
IROC_newregions.region2 = [NaN,NaN];
IROC_newregions.region3 = [NaN,NaN];
IROC_newregions.region4 = [NaN,NaN];
IROC_newregions.region5 = [NaN,NaN];
IROC_newregions.region6 = [NaN,NaN];
IROC_newregions.region7 = [NaN,NaN];

IROC_newregions.regionshort1 = 'BBAY';
IROC_newregions.regionshort2 = 'NEAS';
IROC_newregions.regionshort3 = 'SPNA';
IROC_newregions.regionshort4 = 'BICC';
IROC_newregions.regionshort5 = 'NSBS';
IROC_newregions.regionshort6 = 'NWES';
IROC_newregions.regionshort7 = 'BALT';

%%%% BALTIC %%%%
% taking the pre-defined region from the LME file
%IROC_newregions.region7 = regiondata.region1(:,2:3);
%    07-April-2025: incorporating edited file from D Kieke (edit to boundary with NWES). 
c = load('IROC_2025_RegionalBoundaries_BALT_revised_DKieke.csv');
IROC_newregions.region7 = c(:,[3,2]);
clear c


%%%% BAFFIN %%%%
% taking the pre-defined region from the LME file but replace the 1000 m
% contour
% c1 = regiondata.region15(1:19,2:3);
% cutoffR = regiondata.region15(20,2);
% cutoffL = regiondata.region15(29,3);
% [x1,y1]=contour(sub5.xx(661:end,1:720),sub5.yy(661:end,1:720),sub5.eta(1:720,661:end)',[-1000 -1000],'c');
% tmpc = [x1(1,2:645)',x1(2,2:645)'];
% tmpc(tmpc(:,1)>cutoffR,:)=[];
% tmpc(intersect(find(tmpc(:,2)<cutoffL),find(tmpc(:,1)<-55)),:)=[];
% tmpc(tmpc(:,2)<58,:)=[];
% c2 = cat(1,tmpc(1:5:385,:),tmpc(end,:));
% c3 = regiondata.region15(30:end,2:3);
% IROC_newregions.region1 = cat(1,c1,c2(end:-1:1,:),c3);
% clear c1 c2 c3 tmpc cutoffL cutoffR
%     07-April-2025: incorporating edited file from F Cyr (edit to boundary in Canadian archipelago).
c = load('IROC_2025_RegionalBoundaries_BB_FCyr.csv');
IROC_newregions.region1 = c(:,[3,2]);
clear c


%%%% Northeast American Shelf %%%%%
c1 = setdiff(regiondata.region4(:,[2:3]),regiondata.region5(:,[2:3]),'rows','stable');%boundary of Scotian Shelf
c2 = setdiff(regiondata.region5(:,[2:3]),regiondata.region4(:,[2:3]),'rows','stable');%boundary of NE US shelf
c3 = setdiff(regiondata.region16(:,[2:3]),regiondata.region4(:,[2:3]),'rows','stable');
c4 = setdiff(c3(:,:),regiondata.region5(:,[2:3]),'rows','stable');% boundary of Lab New F. Shelf
% plot(c1(:,1),c1(:,2),'k.-')
% plot(c2(:,1),c2(:,2),'b.-')
% plot(c4(:,1),c4(:,2),'m.-')
% set(gca,'XLim',[-85 -30],'YLim',[30 65])
% take outside boundaries of the regions and make sure connect in right
% places
IROC_newregions.region2 = cat(1,c2(1:end-2,:),c4(1086:end,:),c4(1:1085,:),c1(1:305,:),c2(1,:));
clear c1 c2 c3 c4

%%%% Northwest European Shelf %%%%%
% [x1,y1]=contour(sub5.xx(565:756,1009:1356),sub5.yy(565:756,1009:1356),sub5.eta(1009:1356,565:756)',[-500 -500],'g');
% c1 = [x1(1,407:1009)',x1(2,407:1009)'];%500 m contour on the west
% c2 = [regiondata.region1(4,2),x1(2,1009)];%point on EU continent at level of southern edge shelf
% c3 = regiondata.region1(4:31,2:3);%Baltic Sea boundary
% c4 = [regiondata.region1(31,2),x1(2,407)];%point in scandinavia at level of Norwegian shelf edge
% c5 = [x1(1,407),x1(2,407)];%first point of 500 m contour off Norway to close the shape
% % plot(c1(:,1),c1(:,2),'k.-',c2(:,1),c2(:,2),'b.-',c3(:,1),c3(:,2),'m.-',...
% %     c4(:,1),c4(:,2),'g.-',c5(:,1),c5(:,2),'c.-')
% IROC_newregions.region6 = cat(1,c1,c2,c3,c4,c5);
% IROC_newregions.region6(168:189,:)=[];%cut out kink at WTR
% clear c1 c2 c3 c4 c5 x1 y1
%     07-April-2025: incorporating edited file from D Kieke (edit to adjust Baltic Sea boundary).
c = load('IROC_2025_RegionalBoundaries_NWES_revised_DKieke.csv');
IROC_newregions.region6 = c(:,[3,2]);
clear c


%%%% Nordic and Barents Sea %%%%
% [x1,y1]=contour(sub5.xx(697:817,667:1201),sub5.yy(697:817,667:1201),sub5.eta(667:1201,697:817)',[-750 -750],'m');
% c1 = [x1(1,268:922)',x1(2,268:922)'];%GSR from Greenland to Scotland
% c2 = IROC_newregions.region6(170:-1:1,:);%takes the boundary of NWES from WTR to Norwegian coast
% clear x1 y1
% c3 = [linspace(c2(end,1),15,10)',repmat(c2(end,2),10,1)];%make connection to Barents Sea LMR
% c4 = regiondata.region18(46:-1:1,2:3);%boundary of the Barents Sea LMR
% c5 = regiondata.region18(94:-1:59,2:3);%boundary of the Barents Sea LMR
% c6 = regiondata.region13(47:-1:28,2:3);%boundary of the Greenland Sea LMR
% c7 = [regiondata.region13(28,2),c1(1,2)];%extending boundary south to lat of 750m contour
% c8 = [linspace(c7(1,1),c1(1,1),10)',repmat(c7(1,2),10,1)];%make connection to GSR
% % plot(c1(:,1),c1(:,2),'go',c2(:,1),c2(:,2),'bo',c3(:,1),c3(:,2),'mo',c4(:,1),c4(:,2),'r+',...
% %     c5(:,1),c5(:,2),'mo',c6(:,1),c6(:,2),'rx',c7(:,1),c7(:,2),'co',c8(:,1),c8(:,2),'k+')
% IROC_newregions.region5 = cat(1,c8,c1,c2,c3(2:end,:),c4,c5(2:end,:),c6(2:end,:),c7);
% clear c1 c2 c3 c4 c5 c6 c7 c8 
c = load('IROC_2025_RegionalBoundaries_NBS_KAMork.csv');
IROC_newregions.region5 = c(:,[3,2]);
clear c


%%%% Biscay Iberia Canary %%%% 
% c1 = [IROC_newregions.region6(581,:);6.7245,IROC_newregions.region6(581,2)];%northern boundary of NWES
% c2 = [2.31048,44.4860;0.3825,43.4713;-4.58966,38.1947;-6.05527,36.1989];%border through France and Spain
% c3 = regiondata.region8(1:116,2:3);%boundary of the Canary LMR
% c4 = regiondata.region7(20:42,2:3);%outside boundary of the Iberian Coastal LMR
% c5 = [c1(1,:)];
% IROC_newregions.region4 = cat(1,c1,c2,c3,c4,c5);
% IROC_newregions.region4(IROC_newregions.region4(:,1)>1,1)=1;
% clear c1 c2 c3 c4 c5
c = load('IROC_2025_RegionalBoundaries_BIC_RLeal.csv');
IROC_newregions.region4 = cat(1,c(1:45,[3,2]),IROC_newregions.region6(581,:),...
    c(46:end,[3,2]));
clear c

%%%% Subpolar Gyre %%%%
% c1 = IROC_newregions.region2(484:1390,:);%western boundary is shelf of NAS
% x1 = IROC_newregions.region2(1390,:);
% y1 = IROC_newregions.region6(581,:);
% x2 = linspace(x1(1),y1(1),30);
% y2 = linspace(x1(2),y1(2),30);
% %c2 = [x2',y2'];%southern boundary across the open ocean
% c2 = [x2(1:12)',y2(1:12)'];%southern boundary across the open ocean
% clear x1 y1 x2 y2
% c2b = IROC_newregions.region4(44:46,:);
% c3 = IROC_newregions.region6(581:-1:170,:);%south-eastern boundary is shelf edge NWES
% %c4 = IROC_newregions.region5(662:-1:12,:);%north-eastern boundary is GSR from NBS
% c4 =  IROC_newregions.region5(15:-1:2,:);
% %idx1 = intersect(find(sub5.lon>=-65),find(sub5.lon<=-30));
% %idx2 = intersect(find(sub5.lat>=54),find(sub5.lat<=66));
% %[x1,y1]=contour(sub5.xx(idx2,idx1),sub5.yy(idx2,idx1),sub5.eta(idx1,idx2)',[-750 -750],'m');
% %c5 = x1(:,807:-1:601)';% northern-ish boundary 750 m contour
% %clear idx1 idx2 x1 y1
% %c6 = IROC_newregions.region1(20:29,:);%NW boundary - Baffin Bay edge
% c6 =  IROC_newregions.region1(20:97,:);%NW boundary - Baffin Bay edge
% % IROC_newregions.region3 = cat(1,c1,c2,c3,c4,c5,c6);
% IROC_newregions.region3 = cat(1,c1,c2,c2b,c3,c4,c6);
%     07-April-2025: incorporating edited file from D Debruyeres (edit to boundary off Greenland).
c = load('IROC_2025_RegionalBoundaries_SPNA_DDesbruyeres.csv');
IROC_newregions.region3 = c(:,[3,2]);
clear c


save IROC_2025_regions.mat IROC_newregions
