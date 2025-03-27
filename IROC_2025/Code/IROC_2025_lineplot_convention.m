% ICES WGOH IROC line plot conventions
% rgb codes and plotting instructions developed by D. Kieke

% plotting colours - multiply by 255 to obtain RGB codes 
col_avg = [1,1,1].*0.50; %colour for the climatology mean
col_std = [1,1,1].*0.75; %colour for the +/- standard deviation
col_ext = [1,1,1].*0.50; %colour for the extremes

col_m22 = [0,0,1].*0.90; %colour for year 1 markers - 2022
col_m23 = [0,1,0].*0.80; %colour for year 2 markers - 2023
col_m24 = [1,0,0].*0.90; %colour for year 3 markers - 2024

col_l22 = [0.2,0.8,1.0]; %colour for year 1 lines   - 2022
col_l23 = [0.2,0.8,0.6]; %colour for year 2 lines   - 2023
col_l24 = [1.0,0.6,0.6]; %colour for year 3 lines   - 2024

% climatological reference …

hp1 = plot(month,SST_mean_monthly_RP,'-','linewidth',1,'color',col_avg);

% mean +/-standard deviation … 

hp2 = plot(month,SST_mean_monthly_RP + 1*SST_std_monthly_RP,'--','linewidth',0.25,'color',col_std);
hp3 = plot(month,SST_mean_monthly_RP - 1*SST_std_monthly_RP,'--','linewidth',0.25,'color',col_std);

% climatological min/max  …

hp4 = plot(month,SST_max_monthly_RP,':','linewidth',0.25,'color',col_ext);
hp5 = plot(month,SST_min_monthly_RP,':','linewidth',0.25,'color',col_ext);

% year 2022, blueish … 
hp6 = plot(month,SST_yr0,'o-','markerfacecolor',col_y22,'markeredgecolor',col_y22,'markersize',3,'linewidth',0.75,'color',col_l22);

% year 2023, greenish …
hp7 = plot(month,SST_yr1,'o-','markerfacecolor',col_y23,'markeredgecolor',col_y23,'markersize',3,'linewidth',0.75,'color',col_l23);

% year 2024, reddish …
hp8 = plot(month,SST_yr,'o-','markerfacecolor',col_y24,'markeredgecolor',col_y24,'markersize',3,'linewidth',0.75,'color',col_l24);
