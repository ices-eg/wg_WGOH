function [yearly_anom,yearly_normanom]=fun_calc_annual_anomalies_method2(yearly_time,yearly_data,clim_per)
% function to calculate annual anomaly as the anomaly of the annual mean
% relative to annual means in the climatology period (clim_per)


idxclim = intersect(find(yearly_time(:,1)>=clim_per(1)),find(yearly_time(:,1)<=clim_per(2)));

A = size(yearly_data);

if A(2) == size(yearly_time,1)
    yearly_avg_clim=mean(yearly_data(:,idxclim),2);
    yearly_std_clim=std(yearly_data(:,idxclim),[],2);
    yearly_anom=yearly_data - repmat(yearly_avg_clim,1,size(yearly_data,2));
    yearly_normanom=yearly_anom ./ repmat(yearly_std_clim,1,size(yearly_data,2));
elseif A(1) == size(yearly_time,1)
    yearly_avg_clim=mean(yearly_data(idxclim,:),1);
    yearly_std_clim=std(yearly_data(idxclim,:),[],1);
    yearly_anom=yearly_data - repmat(yearly_avg_clim,size(yearly_data,1),1);
    yearly_normanom=yearly_anom ./ repmat(yearly_std_clim,size(yearly_data,2),1);
else
    error('Time dimensions don''t match')
end

% 
% idxclim = intersect(find(time_yy(:,1)>=1991),find(time_yy(:,1)<=2020));
% box_avg_tempclim_annual=mean(box_avg_temp_monthly_annual(:,idxclim),2);
% box_std_tempclim_annual=std(box_avg_temp_monthly_annual(:,idxclim),[],2);
% box_avg_tempanom_annual=box_avg_temp_monthly_annual - repmat(box_avg_tempclim_annual,1,size(box_avg_temp_monthly_annual,2));
% box_avg_tempnormanom_annual=box_avg_tempanom_annual ./ repmat(box_std_tempclim_annual,1,size(box_avg_temp_monthly_annual,2));
