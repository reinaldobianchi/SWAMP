function bwtenc
%bwtenc is a BWT encoder
% type bwtenc at the command prompt and 
% a user interface is dispalyed.
% currently,its just text file.u can select just text files 
% for now.
%the BWT transformed file is written as bwt.cmp in the 
%current directory
%copyright 
%MA Imran imran_akthar@hotmail.com
%please send me ur feedback and suggestion 
%do check out my other files at MATLAB CENTRAL FILE EXCHANGE

%http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1093740


    
clear all;
clc;
path=pwd;
[filename, pathname] = uigetfile('*.*', 'Pick a file');
cd(pathname)
file_open=fopen(filename,'r');
file_read=fread(file_open,'uint8');
fclose(file_open);
cd(path)
disp('precessing..BWT Transform');
a=file_read;
b=zeros(1,2*length(a));

for sort_len=1:length(b)
    if(sort_len>length(a))
    b(sort_len)=a(sort_len-length(a));
else
    b(sort_len)=a(sort_len);
end
end
a=char(a);
b=char(b);
to_sort=zeros(length(a),length(a));
for row_sort=1:length(a)
    to_sort(row_sort,:)=b(row_sort:length(a)+row_sort-1);
end
char(to_sort);
[lexi_sorted_data,ind]=sortrows(to_sort);
char(lexi_sorted_data);

encoded_data=lexi_sorted_data(:,length(a));
primary_index=find(ind==2);
out_data=[encoded_data',primary_index];
file_bwt=fopen('bwt.cmp','w');
fwrite(file_bwt,out_data,'uint8');
fclose(file_bwt);
disp('BWT Transform over');
disp('file written to bwt.cmp');

       