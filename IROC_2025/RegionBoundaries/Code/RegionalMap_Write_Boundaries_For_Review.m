clear all;close all;clc

racro = {'BB','NAS','NASPG','BIC','NBS','NWES','BS'};

load IROC_2025_regions.mat
for rr=1:7
    eval(['rdata = IROC_newregions.region' num2str(rr),';']);
    fid = fopen(['IROC_2025_RegionalBoundaries_' racro{rr} '.csv'],'w');
    fprintf(fid,'%s\n','% Point Number, Decimal Latitude, Decimal Longitude');
    fprintf(fid,'%4d, %7.4f, %7.4f\n',[([1:size(rdata,1)]'),rdata(:,2),rdata(:,1)]');
    fclose(fid);
end