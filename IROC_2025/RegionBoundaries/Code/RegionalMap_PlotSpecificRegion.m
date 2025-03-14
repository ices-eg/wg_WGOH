XLimVal = [-105 -40;
    -85 -40;
    -65 -5;
    -25  5;
    -50  70;
    -20 15;
    5  35]; 
    
YLimVal = [55 80;
    30 65;
    40  70;
    10 50;
    55 85;
    45 65;
    45 70 ] ;
    
close all
pcolor(sub5.xx,sub5.yy,sub5.eta'),shading flat,colorbar
caxis([-1000 0])
hold on

%%choose region number
rr=7;


eval(['rdata = IROC_newregions.region' num2str(rr),';'])
plot(rdata(:,1),rdata(:,2),'.k-','LineWidth',1.5)
set(gca,'XLim',XLimVal(rr,:),'YLim',YLimVal(rr,:))
