function figh = fun_plot_colourboxes_with_value(Xdata,Ydata,Zdata,Zdata2,Ylabels,cmap,FigTitle)

%finds out format for the number of decimal places for Zdata2
tmp_e1 = Zdata2-round(Zdata2.*10)/10;
tmp_e2 = Zdata2-round(Zdata2.*100)/100;
tmp_e3 = Zdata2-round(Zdata2.*1000)/1000;
if median(tmp_e1(:),'omitnan')==0
    dpfmt = 1;
elseif median(tmp_e2(:),'omitnan')==0
    dpfmt = 2;
elseif median(tmp_e3(:),'omitnan')==0
    dpfmt = 3;
else
    dpfmt = 2;
end

figh = figure;
ax1=axes;hold on,%ax2 = axes;set(ax2,'color','none')
im= imagesc(ax1,Xdata,Ydata,Zdata);im.AlphaData=0.8;
set(ax1,'xlim',[Xdata(1)-0.5 Xdata(end)+0.5],'ylim',[Ydata(1)-0.5 Ydata(end)+0.5],'color','none');
set(ax1,'xtick',Xdata)
set(ax1,'ytick',Ydata,'yticklabel',Ylabels)
set(ax1,'TickLength',[0 0],'box','off')
set(ax1,'xcolor',[.2 .2 .2],'ycolor',[.2 .2 .2],'fontsize',12);
plot(ax1,repmat([Xdata(1)-0.5 Xdata(end)+0.5],Ydata(end)+1,1)',repmat([Ydata-0.5,Ydata(end)+0.5]',1,2)','-','linewidth',1,'color',[.2 .2 .2])
plot(ax1,repmat([Xdata-0.5,Xdata(end)+0.5],2,1),repmat([Ydata(1)-0.5 Ydata(end)+0.5],(length(Xdata)+1),1)','-','linewidth',1,'color',[.2 .2 .2])
set(ax1,'xaxislocation','top')
set(ax1,'XTickLabelRotation',90)
caxis([-3.5 3.5])
colormap(cmap)
h = colorbar(ax1,'eastoutside','fontsize',12,'fontname','arial');
htick = [-3.5:0.5:3.5];
%pos1 = get(ax1,'position');posh = get(h,'position');
set(h,'tickdir','both','ytick',htick,'yticklabel',sprintf('%+4.2f \n',htick),'ycolor',[.2 .2 .2])
ylabel(h,['Standardised Anomalies'])
%'position',[pos1(1)+pos1(3)+0.02 pos1(2) 0.02 pos1(4)],
[rr,cc]=size(Zdata);
for ir = 1:rr
    for ic = 1:cc
        if isnan(Zdata(ir,ic))
            patch(Xdata(ic)+[-0.5,0.5,0.5,-0.5,-0.5],Ydata(ir)+[-0.5,-0.5,0.5,0.5,-0.5],'w','edgecolor',[.2 .2 .2])
        else
            if ~isnan(Zdata2(ir,ic))
                switch dpfmt
                    case 1
                    text(ax1,Xdata(ic),Ydata(ir),sprintf('%5.1f',Zdata2(ir,ic)),...
                        'verticalalignment','middle','horizontalalignment','center','color','k','fontsize',12,'rotation',0)
                    case 2
                    text(ax1,Xdata(ic),Ydata(ir),sprintf('%5.2f',Zdata2(ir,ic)),...
                        'verticalalignment','middle','horizontalalignment','center','color','k','fontsize',12,'rotation',0)
                    case 3
                    text(ax1,Xdata(ic),Ydata(ir),sprintf('%5.3f',Zdata2(ir,ic)),...
                        'verticalalignment','middle','horizontalalignment','center','color','k','fontsize',12,'rotation',0)
                end
            end
        end
    end
end
title(FigTitle)
set(gcf,'color','w')

