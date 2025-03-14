%% make nice map of all together
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
close all
m_proj('lambert','lon',[-105 70],'lat',[10 85]); 

cmap_ocean = flipud(cbrewer('seq','Blues',101));
cmap_ocean(cmap_ocean<0)=0;cmap_ocean(cmap_ocean>1)=1;
cmap_land = cbrewer('seq','Greens',31);
cmap_land(cmap_land<0)=0;cmap_land(cmap_land>1)=1;

[CS,CH]=m_contourf(lon,lat,double(eta)',[-10000:1000:1000 1000:100:0 250:250:3000],'edgecolor','none');
hold on
caxis([-10000 3000])
m_grid('linestyle','none','tickdir','out','linewidth',3);
 
colormap([cmap_ocean;cmap_land]);

for rr=1:7;
eval(['rdata = IROC_newregions.region' num2str(rr),';'])
m_plot(rdata(:,1),rdata(:,2),'-','LineWidth',1,'color','r')%[.6 .6 .6]
end

coldef_land = cmap_land(end-1,:);%[.5 .5 .5];
m_gshhs_i('patch',coldef_land)

brighten(.3);

ax=m_contfbar(1,[.5 .8],CS,CH);
title(ax,{'Level/m',''}); % Move up by inserting a blank line

set(gcf,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(gcf, '-dpng', '-r300', 'IROC_2025_RegionalBoundaries.png')  

%%
close all
m_proj('mercator','lon',[-105 70],'lat',[10 85]); 

cmap_ocean = flipud(cbrewer('seq','Blues',101));
cmap_ocean(cmap_ocean<0)=0;cmap_ocean(cmap_ocean>1)=1;
cmap_land = cbrewer('seq','Greens',31);
cmap_land(cmap_land<0)=0;cmap_land(cmap_land>1)=1;

[CS,CH]=m_contourf(lon,lat,double(eta)',[-10000:1000:1000 1000:100:0 250:250:3000],'edgecolor','none');
hold on
caxis([-10000 3000])
m_grid('linestyle','none','tickdir','out','linewidth',3);
 
colormap([cmap_ocean;cmap_land]);

coldef_land = cmap_land(end-1,:);%[.5 .5 .5];
m_gshhs_i('color',coldef_land)

brighten(.3);

for rr=1:7;
eval(['rdata = IROC_newregions.region' num2str(rr),';'])
m_plot(rdata(:,1),rdata(:,2),'-','LineWidth',1,'color','r')%[.6 .6 .6]
end

ax=m_contfbar(1,[.5 .8],CS,CH);
title(ax,{'Level/m',''}); % Move up by inserting a blank line

set(gcf,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(gcf, '-dpng', '-r300', 'IROC_2025_RegionalBoundaries2.png')  