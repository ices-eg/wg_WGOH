%%
% note - this loads datafiles in csv from the main IROC data store
% assumes ref period is set clim period as clim_per
% ref period was 1978-2007 in original figures
close all;clear all;clc;

% define data paths
IROC_data_path=[getenv('Working'),'\ICES Working Group Oceanic Hydrography\GitHub_wg_WGOH\IROC\Data\'];
figpath=[pwd,filesep];

%set colour schemes
% red blue colourmap - requires cbrewer
tmp = cbrewer('div','PiYG',3);
rbc = cat(1,flipud(cbrewer('seq','Blues',7)),tmp(2,:),tmp(2,:),cbrewer('seq','Reds',7));
rbc(rbc > 1) = 1;
rbc(rbc < 0) = 0;
clear tmp
%light grey for bar outlines and x-axis at 0
lgrey = [.7 .7 .7];

% find last year and set years
tmp = datevec(now);
last_year = tmp(1);clear tmp

timeseries_files = {'FramStrait_WSC_Annual.csv';
    'Norway_Sorkapp_Annual.csv';
    'Barents_BearIsland_Annual.csv';
    'Norway_Gimsoy_Annual.csv';
    'Norway_OWSM_50_Annual.csv';
    'Norway_Svinoy_Annual.csv';
    'Faroe_FaroeCurrent_Annual.csv';
    'FaroeShetland_NAW_Annual.csv';
    'Rockall_Ellett_Upper_Annual.csv'}

timeseries_names = {'Fram Strait';
    'Sorkapp Section';
    'Fugloya - Bear Island';
    'North Norwegian Sea (Gimsoy)';
    'Ocean Weather Station M';
    'South Norwegian Sea (Svinoy)';
    'Faroe Current';
    'Faroe Shetland Channel NAW';
    'Rockall Trough'}

ylower = 1975;
yhigher = last_year;

pnum = size(timeseries_files,1);
deltaplot = 0;%0.02;
deltaoff = 0.02;
pos_mat = zeros(pnum,4);
ph = floor((0.97-(pnum*deltaplot))/pnum.*100)./100;
pos_mat(:,1)=0.05;
pos_mat(:,2)=deltaoff+([1:pnum]-1)*(deltaplot+ph);
pos_mat(:,3)=0.9;
pos_mat(:,4)=ph;

Years_IROC = 1950:last_year;
Data_IROC = NaN.*zeros([length(Years_IROC), 7, length(timeseries_names)]);

% load data from timeseries file
for ff=1:size(timeseries_files,1)
    filename=[IROC_data_path,timeseries_files{ff}];
    ftext=timeseries_names{ff};
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
    dat=[timdata.Var1,timdata.Var2,timdata.Var3,timdata.Var4,...
        timdata.Var5,timdata.Var6,timdata.Var7];

    [~,idx1,idx2]=intersect(Years_IROC,dat(:,1));
    Data_IROC(idx1,:,ff)=dat(idx2,:);
    clear dat refind refdat refstd idx1 idx2 timdata NumHeadLines ftext filename
end

%%
idxtemp = 1:9;

ymin = ylower;
ymax = yhigher;

close all
for ss=1:size(timeseries_files,1);

    tmp = squeeze(Data_IROC(:,:,idxtemp(ss)));
    tmp(sum(isnan(tmp),2)>0,:)=[];
    xdata = tmp(:,1);%x axis
    tdata = tmp(:,2);% values
    adata = tmp(:,3);% anomalies
    sdata = tmp(:,4);% standardised anomalies
    clear tmp

    ydata = sdata;
    zdata = sdata;

    t_ext = 3.5;
    t_tic = [-3:1:3];
    t_lab = sprintf('% -1d\n',t_tic);


    %ax = subplot(ceil(length(idxtemp)/2),2,ss);hold on
    subplot(pnum+1,1,ss);hold on
    ax(ss)=gca;
    plot(ax(ss), [ymin ymax],[0 0],'k-','LineWidth',0.5)
    set(ax(ss),'YTickLabelMode','manual','YTick',t_tic,'YTickLabel',t_lab,...
        'ylim',[-1*t_ext t_ext])
    if ss~= length(idxtemp)
        set(ax(ss),'Xlim',[ymin ymax],'xtick',[],'XTicklabel',[],'XAxisLocation','origin')
    else
        set(ax(ss),'Xlim',[ymin ymax],'XTick',1950:10:ymax,'XMinorTick','on')
    end
    set(ax(ss),'Color','none')
    %ylabel(num2str(ss))
    if mod(ss,2)==1
        set(ax(ss),'YaxisLocation','left','Box','off')
        text(ymin+0.5,t_ext-0.5,timeseries_names{idxtemp(ss)},'HorizontalAlignment','left',...
                'color','r','FontWeight','bold')
    else
        set(ax(ss),'YaxisLocation','right','Box','off')
        text(ymax-0.5,t_ext-0.5,timeseries_names{idxtemp(ss)},'HorizontalAlignment','right',...
                'color','r','FontWeight','bold')
    end
    for yy=1:length(xdata)
        if isnan(ydata(yy)) || isnan(zdata(yy));continue;end
        h=bar(xdata(yy),ydata(yy),1.0);
        ind=floor(zdata(yy)*2)+9;
        if (ind<1);ind=1; end
        if (ind>16);ind=16; end
        set(h,'FaceColor',rbc(ind,:),'linestyle','-','linewidth',0.5,'EdgeColor',lgrey);
    end
    fstart= min(xdata(~isnan(zdata)))+0.5;
    fend=max(xdata(~isnan(zdata)))+0.5;
    newyr=fstart:1:fend;
    newdat = loess_yr(xdata(~isnan(zdata)),zdata(~isnan(zdata)),newyr,5,1,1);
    plot(ax(ss),newyr,newdat,'k','LineWidth',1.5);
    plot(ax(ss), [ylower:1:yhigher],0.*[ylower:1:yhigher],'.-','MarkerSize',4,'Color',lgrey)
end
cbounds =  -1*t_ext:0.5:t_ext+0.5;
yytxt = 1.1;
subplot(pnum+1,1,pnum+1);hold on
tx = gca;
set(tx,'position',[0.05 0.935 0.9 0.05])
for pp=1:size(rbc,1)
    if pp==1
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 1 1 0],rbc(pp,:),'edgecolor','none')
        text(pp,yytxt,{'';'y';['< ' sprintf('% -3.1f',cbounds(pp))]}, ...
            'horizontalalignment','center','VerticalAlignment','bottom','interpreter','tex','FontSize',10);
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 6 6 0],rbc(pp,:),'facecolor','none','edgecolor','k')
    elseif pp==size(rbc,1)
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 1 1 0],rbc(pp,:),'edgecolor','none')
        text(pp,yytxt,{[sprintf('% -3.1f',cbounds(pp-1)),' \leq'];
            'y'; ''},...
            'horizontalalignment','center','VerticalAlignment','bottom','interpreter','tex','FontSize',10);
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 6 6 0],rbc(pp,:),'facecolor','none','edgecolor','k')
    else
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 1 1 0],rbc(pp,:),'edgecolor','none')
        text(pp,yytxt,{[sprintf('% -3.1f',cbounds(pp-1)),' \leq'];
            'y'; ['<' sprintf('% -3.1f',cbounds(pp))]},...
            'horizontalalignment','center','VerticalAlignment','bottom','interpreter','tex','FontSize',10);
        patch(tx,pp+[-0.5 0.5 0.5 -0.5 -0.5],[0 0 6 6 0],rbc(pp,:),'facecolor','none','edgecolor','k')
    end
end
set(tx,'color','none','XColor','none','ycolor','none','xlim',[0.5 size(rbc,1)+0.5],'ylim',[0 6])

for ss=1:size(timeseries_files,1)
    set(ax(ss),'Position',pos_mat(abs(ss-(pnum+1)),:),'TickLength',[.002 .002]);
end

fname_fig = ['templot_',datestr(now,'yyyymmdd'),...
    '_yrs',num2str(ymin),'-',num2str(ymax)];

set(gcf,'paperorientation','portrait','papertype','a4','paperpositionmode','auto',...
    'paperunits','centimeters','paperposition',[0.6 0.6 19.7 28.4])
print(gcf, '-dpng', '-r300', fname_fig)
