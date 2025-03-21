function [yearly_anom,yearly_normanom]=fun_calc_annual_anomalies_method1(monthly_time,monthly_anom,monthly_normanom,yearly_time)
% function to calculate annual anomaly as the mean of the monthly anomalies
% and monthly normalised anomalies

A = size(monthly_anom);

TDim = find(A==size(monthly_time,1));

for yy=1:size(yearly_time,1)
    if yy==1
        yearly_anom = NaN.*zeros(size(monthly_normanom,1),size(monthly_normanom,2),size(yearly_time,1));
        yearly_normanom = NaN.*zeros(size(monthly_normanom,1),size(monthly_normanom,2),size(yearly_time,1));
    end
    idxy = find(monthly_time(:,1)==yearly_time(yy));
    switch TDim
        case 3
            yearly_anom(:,:,yy)=mean(monthly_anom(:,:,idxy),3);
            yearly_normanom(:,:,yy)=mean(monthly_normanom(:,:,idxy),3);
        otherwise
            error('Time is not third dimension - write some code!')
    end
end


% for yy=1:size(time_yy,1)
%     box_avg_salanom_annual(:,:,yy)=mean(box_avg_salanom(:,:,idxy),3);
%     box_avg_salnormanom_annual(:,:,yy)=mean(box_avg_salnormanom(:,:,idxy),3);
%     box_avg_tempanom_annual(:,:,yy)=mean(box_avg_tempanom(:,:,idxy),3);
%     box_avg_tempnormanom_annual(:,:,yy)=mean(box_avg_tempnormanom(:,:,idxy),3);
% end
