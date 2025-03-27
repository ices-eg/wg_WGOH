clear all;close all;clc

% set path to where you store data folder - this is relative path in Bee
% file structure
IROC_datafolder = ['../../../IROC/Data/'];

% find a list of all the Annual files
flist = ls([IROC_datafolder,'*Annual*']);

% set the climatology period
clim_ref_period = [1991 2020];

%define colormaps
% Blue-Red rbc
tmp= cbrewer('div','PiYG',3);
rbc = cat(1,flipud(cbrewer('seq','Blues',6)),tmp(2,:),tmp(2,:),cbrewer('seq','Reds',6));
rbc(rbc>1)=1;rbc(rbc<0)=0;
clear tmp

% Green-Pink pgc
tmp= cbrewer('div','PiYG',3);
pgc = cat(1,flipud(cbrewer('seq','Greens',6)),tmp(2,:),tmp(2,:),cbrewer('seq','RdPu',6));
pgc(pgc>1)=1;pgc(pgc<0)=0;
clear tmp

% create empty variables to load in annual time series
IROC_annual_time = [1890:1:2024]';
IROC_annual_data = NaN.*zeros(size(IROC_annual_time,1),6,size(flist,1));
IROC_annual_name(1:size(flist,1),1) = {' '};
IROC_HLines = NaN.*zeros(size(flist,1),1);
% consolidate time series (in order listed in directory)
for ff=1:size(flist,1)
    data_filename = flist(ff,:);
    data_sitename = data_filename(1:regexpi(data_filename,'_Annual')-1);
    IROC_annual_name{ff} = strrep(data_sitename,'_',' ');
    if ~isempty(regexpi(IROC_annual_name{ff},'inflow')) | ~isempty(regexpi(IROC_annual_name{ff},'ice'))
        continue
    end
    NumHeadLines = 0;bline = repmat(' ',1,15);
    fid = fopen([IROC_datafolder,data_filename]);
%     while ~strncmpi(bline,'year',4)
    while isempty(regexpi(bline,'year'))
        bline = fgetl(fid);
        if length(bline)>15
            bline = bline(1:15);
        end
        NumHeadLines = NumHeadLines +1;
    end
    IROC_HLines(ff)=NumHeadLines-1;
    fid = fclose(fid);clear fid bline
    data = readtable([IROC_datafolder,data_filename],'NumHeaderLines',NumHeadLines-1);
    [~,idxT,idxI] = intersect(data{:,1},IROC_annual_time);
    %switch for those time series with incorrect header structure
    switch size(data,2)
        case 7
            IROC_annual_data(idxI,:,ff) = data{idxT,2:end};
        case 10
            IROC_annual_data(idxI,:,ff) = data{idxT,2:7};
        case 4
            IROC_annual_data(idxI,1:3,ff) = data{idxT,2:end};
        case 5
            IROC_annual_data(idxI,2:3,ff) = data{idxT,2:3};
            IROC_annual_data(idxI,5:6,ff) = data{idxT,4:5};
        otherwise
            error('number columns not recognised in IROC dataset')
    end
    clear data idxT idxI NumHeadLines data_sitename data_filename
end; clear ff

% temperature figures
Year(:,1) = IROC_annual_time(:,1);

idxtemp = [1:size(IROC_annual_name,1)];%use this to subset/or reorder the timeseries in plot

ylen=31;
figh1 = fun_plot_colourboxes([Year(end-ylen):1:Year(end)],[1:1:length(idxtemp)],...
    squeeze(IROC_annual_data(end-ylen:end,3,idxtemp))',...
    IROC_annual_name(idxtemp),rbc,'Ocean Temperature')

set(figh1,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh1, '-dpng', '-r300', 'IROC_TimeSeries_Temperature_Last30years.png')

ylen=9;
figh2 = fun_plot_colourboxes_with_value([Year(end-ylen):1:Year(end)],[1:1:length(idxtemp)],...
    squeeze(IROC_annual_data(end-ylen:end,3,idxtemp))',round(squeeze(IROC_annual_data(end-ylen:end,1,idxtemp))'*100)/100,...
    IROC_annual_name(idxtemp),rbc,'Ocean Temperature')

set(figh2,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh2, '-dpng', '-r300', 'IROC_TimeSeries_Temperature_last10years_with_text.png')

ylen=9;
figh2b = fun_plot_colourboxes([Year(end-ylen):1:Year(end)],[1:1:length(idxtemp)],...
    squeeze(IROC_annual_data(end-ylen:end,3,idxtemp))',...
    IROC_annual_name(idxtemp),rbc,'Ocean Temperature')

set(figh2b,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh2b, '-dpng', '-r300', 'IROC_TimeSeries_Temperature_last10years.png')


%% salinity figures
idxsal = [1:size(IROC_annual_name,1)];%use this to subset/or reorder the timeseries in plot

ylen=31;
figh1 = fun_plot_colourboxes([Year(end-ylen):1:Year(end)],[1:1:length(idxsal)],...
    squeeze(IROC_annual_data(end-ylen:end,6,idxsal))',...
    IROC_annual_name(idxsal),pgc,'Ocean Practical Salinity')

set(figh1,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh1, '-dpng', '-r300', 'IROC_TimeSeries_Salinity_Last30years.png')

ylen=9;
figh2 = fun_plot_colourboxes_with_value([Year(end-ylen):1:Year(end)],[1:1:length(idxsal)],...
    squeeze(IROC_annual_data(end-ylen:end,6,idxsal))',round(squeeze(IROC_annual_data(end-ylen:end,4,idxsal))'*1000)/1000,...
    IROC_annual_name(idxsal),pgc,'Ocean Practical Salinity')

set(figh2,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh2, '-dpng', '-r300', 'IROC_TimeSeries_Salinity_last10years_with_text.png')

ylen=9;
figh2b = fun_plot_colourboxes([Year(end-ylen):1:Year(end)],[1:1:length(idxsal)],...
    squeeze(IROC_annual_data(end-ylen:end,6,idxsal))',...
    IROC_annual_name(idxsal),pgc,'Ocean Practical Salinity')

set(figh2b,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 28.4 19.7])
print(figh2b, '-dpng', '-r300', 'IROC_TimeSeries_Salinity_last10years.png')