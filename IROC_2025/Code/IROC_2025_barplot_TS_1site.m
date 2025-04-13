%% Bar plot of anomalies for a single IROC timeseries
% note - this loads datafile in csv from the main IROC data store
% assumes ref period is set clim period as clim_per
% saves figure in PWD (present working directory)

close all;clear all;clc;

% define data directory path
IROC_data_path=[getenv('Working'),'\ICES Working Group Oceanic Hydrography\GitHub_wg_WGOH\IROC\Data\'];

% set filename of timeseries
timeseries_files = {'Norway_Svinoy_Annual'};
timeseries_names = {'South Norwegian Sea (Svinoy)'};

% add filesep to fig path
figpath=[pwd,filesep];

%set colour schemes
% red blue colourmap - requires cbrewer
tmp = cbrewer('div','PiYG',3);
rbc = cat(1,flipud(cbrewer('seq','Blues',7)),tmp(2,:),tmp(2,:),cbrewer('seq','Reds',7));
rbc(rbc > 1) = 1;
rbc(rbc < 0) = 0;
clear tmp
% pink green colourmap - requires cbrewer
tmp = cbrewer('div','PiYG',3);
pgc = cat(1,flipud(cbrewer('seq','Greens',7)),tmp(2,:),tmp(2,:),cbrewer('seq','RdPu',7));
pgc(pgc > 1) = 1;
pgc(pgc < 0) = 0;
clear tmp
%light grey for bar outlines and x-axis at 0
lgrey = [.7 .7 .7];

% sets limits to the plot
ylower = 1975;
yhigher = 2025;

% load data from timeseries file
filename=[IROC_data_path,timeseries_files{1},'.csv'];
NumHeadLines = 0;bline = repmat(' ',1,15);
fid = fopen(filename);
%     while ~strncmpi(bline,'year',4)
while isempty(regexpi(bline,'year'))
    bline = fgetl(fid);
    if length(bline)>15
        bline = bline(1:15);
    end
    NumHeadLines = NumHeadLines +1;
end
fid = fclose(fid);clear fid bline
timdata = readtable(filename,'NumHeaderLines',NumHeadLines,'EmptyValue',NaN);

%% Temperature plot
%prepare data
tmp = [timdata.Var1,timdata.Var2,timdata.Var3,timdata.Var4];
tmp(sum(isnan(tmp),2)>0,:)=[];
xdata = tmp(:,1);%x axis
tdata = tmp(:,2);% values
adata = tmp(:,3);% anomalies
sdata = tmp(:,4);% standardised anomalies
clear tmp

% choose bar data [ydata] & colour data [zdata]
ydata = sdata;
zdata = sdata;

%set y axis limits and labels
t_ext = 3.5;
t_tic = [-3:1:3];
t_lab = sprintf('% -1d\n',t_tic);

% make bar plot
subplot(2,1,1);hold on
ax_t=gca;
plot(ax_t, [ylower yhigher],[0 0],'k-','LineWidth',0.5)
set(ax_t,'YTickLabelMode','manual','YTick',t_tic,'YTickLabel',t_lab,...
    'ylim',[-1*t_ext t_ext])
set(ax_t,'Xlim',[ylower yhigher],'XTick',ylower:10:yhigher,'XMinorTick','off','XColor','none')
set(ax_t,'Color','none')
set(ax_t,'YaxisLocation','left','Box','off')
text(ylower+0.5,t_ext,{timeseries_names{1};'Temperature'},'HorizontalAlignment','left','VerticalAlignment','top')
for yy=1:length(xdata)
    if isnan(ydata(yy)) || isnan(zdata(yy));continue;end
    h=bar(xdata(yy),ydata(yy),1.0);
    ind=floor(zdata(yy)*2)+9;
    if (ind<1);ind=1; end
    if (ind>16);ind=16; end
    set(h,'FaceColor',rbc(ind,:),'linestyle','-','linewidth',0.5,'EdgeColor',lgrey);
end
plot(ax_t, [ylower:1:yhigher],0.*[ylower:1:yhigher],'.-','MarkerSize',4,'Color',lgrey)

%% Salinity plot
%prepare data
tmp = [timdata.Var1,timdata.Var5,timdata.Var6,timdata.Var7];
tmp(sum(isnan(tmp),2)>0,:)=[];
xdata = tmp(:,1);%x axis
tdata = tmp(:,2);% values
adata = tmp(:,3);% anomalies
sdata = tmp(:,4);% standardised anomalies
clear tmp

% choose bar data [ydata] & colour data [zdata]
ydata = sdata;
zdata = sdata;

%set y axis limits and labels
t_ext = 3.5;
t_tic = [-3:1:3];
t_lab = sprintf('% -1d\n',t_tic);

% make bar plot
subplot(2,1,2);hold on
ax_s=gca;
plot(ax_s, [ylower yhigher],[0 0],'k-','LineWidth',0.5)
set(ax_s,'YTickLabelMode','manual','YTick',t_tic,'YTickLabel',t_lab,'ylim',[-1*t_ext t_ext])
set(ax_s,'Xlim',[ylower yhigher],'XTick',ylower:10:yhigher,'XMinorTick','off','XColor','none')
set(ax_s,'Color','none')
set(ax_s,'YaxisLocation','right','Box','off')
text(yhigher-0.5,t_ext,{timeseries_names{1};'Salinity'},'HorizontalAlignment','right','VerticalAlignment','top')
for yy=1:length(xdata)
    if isnan(ydata(yy)) || isnan(zdata(yy));continue;end
    h=bar(xdata(yy),ydata(yy),1.0);
    ind=floor(zdata(yy)*2)+9;
    if (ind<1);ind=1; end
    if (ind>16);ind=16; end
    set(h,'FaceColor',pgc(ind,:),'linestyle','-','linewidth',0.5,'EdgeColor',lgrey);
end
plot(ax_s, [ylower:1:yhigher],0.*[ylower:1:yhigher],'.-','MarkerSize',4,'Color',lgrey)

%adjust the size of the temperature and salinity plots and colour legends
set(ax_s,'Position',[0.05 0.04 0.9 0.48],'TickLength',[.002 .002]);
set(ax_t,'Position',[0.05 0.51 0.9 0.48],'TickLength',[.002 .002]);

xax_only = axes;
set(xax_only,'Position',[0.05 0.03 0.9 0.35],'color','none','YColor','none',...
    'Xlim',[ylower yhigher],'XTick',ylower:10:yhigher,'XMinorTick','off',...
    'TickLength',[.002 .002])

%save figure 
fname_fig = [timeseries_files{1},'_',datestr(now,'yyyymmdd'),...
        '_temp_sal_barplot.png'];
set(gcf,'paperorientation','landscape','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.2 0.2 28.6 19.9])
print(gcf, '-dpng', '-r300', fname_fig)
