%% make nice plots of each individual region

clear all;close all;clc
fname = [getenv('Bathy') '\GEBCO_2024\GEBCO_2024_sub_ice_topo.nc'];
ncdisp(fname)

lon = ncread(fname,'lon');
lat = ncread(fname,'lat');

idxlon = intersect(find(lon>=-110),find(lon<=80));
idxlat = intersect(find(lat>=0),find(lat<=90));

istride = 20;
eta = ncread(fname,'elevation',[idxlon(1) idxlat(1)],[Inf Inf],[istride istride]);
lon = ncread(fname,'lon',[idxlon(1)],[Inf],[istride]);
lat = ncread(fname,'lat',[idxlat(1)],[Inf],[istride]);

clear idxlon idxlat
%%
load IROC_2025_regions.mat

%%

XLimVal = [-105 -40;
    -85 -40;
    -65 -5;
    -35  5;
    -40  70;
    -20 15;
    5  35]; 
    
YLimVal = [55 80;
    30 65;
    40  70;
    15 50;
    55 85;
    45 65;
    45 70 ] ;

cmap_ocean = flipud(cbrewer('seq','Blues',101));
cmap_ocean(cmap_ocean<0)=0;cmap_ocean(cmap_ocean>1)=1;
cmap_land = cbrewer('seq','Greens',31);
cmap_land(cmap_land<0)=0;cmap_land(cmap_land>1)=1;

for rr=1:7;
eval(['rdata = IROC_newregions.region' num2str(rr),';'])
eval(['rname = IROC_newregions.regionname' num2str(rr),';'])
close all
%m_proj('lambert','lon',XLimVal(rr,:),'lat',YLimVal(rr,:)); 
m_proj('mercator','lon',XLimVal(rr,:),'lat',YLimVal(rr,:)); 

[CS,CH]=m_contourf(lon,lat,double(eta)',[-10000:1000:1000 1000:100:0 250:250:3000],'edgecolor','none');
hold on
caxis([-10000 3000])
m_grid('linestyle','none','tickdir','out','linewidth',3);
 
colormap([cmap_ocean;cmap_land]);

coldef_land = cmap_land(end-1,:);
m_gshhs_i('color',coldef_land)

m_plot(rdata(:,1),rdata(:,2),'.r-','LineWidth',0.25,'color','r')%[.6 .6 .6]
title(rname)
print(gcf, '-dpng', '-r300', ['IROC_2025_RegionalBoundaries_',rname,'.png'])  

end

%% NWES base only
rr=6;
eval(['rdata = IROC_newregions.region' num2str(rr),';'])
eval(['rname = IROC_newregions.regionname' num2str(rr),';'])

close all
%m_proj('lambert','lon',XLimVal(rr,:),'lat',YLimVal(rr,:)); 
m_proj('mercator','lon',XLimVal(rr,:),'lat',YLimVal(rr,:)); 

[CS,CH]=m_contourf(lon,lat,double(eta)',[-3000:100:-200,-200:50:0, 250:250:3000],'edgecolor','none');
hold on
caxis([-3000 0])
m_grid('linestyle','none','tickdir','out','linewidth',3);
 
colormap([cmap_ocean])%;cmap_land]);

coldef_land = cmap_land(end-1,:);
m_gshhs_i('color',coldef_land)

title(rname)
print(gcf, '-dpng', '-r300', ['IROC_2025_emptyBasemap_',rname,'.png'])  
