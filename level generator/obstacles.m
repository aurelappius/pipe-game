function Z = obstacles(stone_prob,red,blu,yel,lvl,wrld) %function (syms,start,epsilon)

S=[
8 8 8 8 8 8 8 8;
8 8 8 8 8 8 8 8;
8 8 8 8 8 8 8 8;
8 8 8 8 8 8 8 8;
8 8 8 8 8 8 8 8;
8 8 8 8 8 8 8 8;
];

bord=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      ];
l=24;

while blu > 0 
    r = randi([1, 24],1,1);
    if(bord(r)==0)
        bord(r)=1;
        blu=blu-1;
    end
end
while red > 0 
    r = randi([1, 24],1,1);
    if(bord(r)==0)
        bord(r)=2;
        red=red-1;
    end
end
while yel > 0 
    r = randi([1, 24],1,1);
    if(bord(r)==0)
        bord(r)=3;
        yel=yel-1;
    end
end
for c = 1:8
    for r = 1:6
        if( rand(1,1)<stone_prob )
            S(r,c) = 9;
        end
    end
end
S(1,:)
%output:
fid = fopen( "gen/"+wrld+"/"+lvl+".txt", 'wt' );
fprintf(fid,'%d %d %d %d %d %d %d %d\n',S)
fprintf(fid,'\n')
fprintf(fid,'%d %d %d %d %d %d %d %d\n',bord(1:8))
fprintf(fid,'%d %d %d %d %d %d %d %d\n',bord(9:16))
fprintf(fid,'0 %d %d %d %d 0\n',bord(17:20))
fprintf(fid,'0 %d %d %d %d 0\n',bord(21:24))
fprintf(fid,'\n')
fprintf(fid,'50 50 50 50')
fclose(fid);
return
