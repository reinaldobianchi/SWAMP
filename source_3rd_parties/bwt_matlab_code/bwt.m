clear all;
clc;
file_open=fopen('test.txt','r');
file_read=fread(file_open,'uint8');
fclose(file_open);
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

%%%%%%%%%%%%%%%%BWT DECODING STARTS
dec_bwt_file=fopen('bwt.cmp','r');
dec_bwt_read=fread(dec_bwt_file,'uint8');
fclose(dec_bwt_file);

encoded_data=dec_bwt_read(1:length(dec_bwt_read)-1);
primary_index=dec_bwt_read(length(dec_bwt_read));


sorted_data=sort(encoded_data);
vector_flag=ones(1,length(encoded_data))';
vector=zeros(1,length(encoded_data))';
%%%%%%%preparing vector table
for i=1:length(sorted_data)
    for j=1:length(sorted_data)
        if(encoded_data(j)==sorted_data(i) && vector_flag(j))
%             clc;
%             encoded_data(j);
%             sorted_data(i);
            vector_flag(j);
            vector(i)=j;
            vector_flag(j)=0;
            break
            
        end
    end
end

index=primary_index;
reconst_data=zeros(1,length(encoded_data));
%getting original data back
for i=1:length(encoded_data)
       reconst_data(i)=encoded_data(index);
       index=vector(index);
   end
  
   
   char(lexi_sorted_data(:,length(a)))
   primary_index=find(ind==2)
   char(reconst_data)
       