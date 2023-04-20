
wrld=3


w1_mod=abs(w1-50);
w2_mod=abs(w2-50);
w3_mod=abs(w3-50);

for lvl=1:45
R= textread( "final/"+wrld+"/"+lvl+".txt",'%u')

fid = fopen( "final_mod/"+wrld+"/"+lvl+".txt", 'wt' );
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(1:8))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(9:16))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(17:24))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(25:32))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(33:40))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(41:48))
fprintf(fid,'\n')
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(49:56))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',R(57:64))
fprintf(fid,'%d %d %d %d %d %d\n',R(65:70))
fprintf(fid,'%d %d %d %d %d %d\n',R(71:76))
fprintf(fid,'\n')
fprintf(fid,'%d %d %d %d\n',w3_mod(lvl,:))
fclose(fid);
end