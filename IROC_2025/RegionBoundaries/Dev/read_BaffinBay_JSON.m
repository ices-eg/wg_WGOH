fname = 'BaffinBay.json'; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
for ii=1:size(val.features.geometry.coordinates{1},1);
    plot(val.features.geometry.coordinates{1}{ii}(:,1),val.features.geometry.coordinates{1}{ii}(:,2),'m-')
end

