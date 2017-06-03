function write_CEA_problem(OF,aeatOFbest,requirements,fuel,oxid,run,optimflag)
Pc=requirements.pinj;
Pe=requirements.pexit;
if run==1
    FID = fopen(fullfile('fcea2','regenLRE1.inp'),'wt');
    while FID<0 %keep trying till file opens
        FID = fopen(fullfile('fcea2','regenLRE1.inp'),'wt');
    end
else
    FID = fopen(fullfile('fcea2','regenLRE2.inp'),'wt');
    while FID<0 %keep trying till file opens
        FID = fopen(fullfile('fcea2','regenLRE2.inp'),'wt');
    end
end
if(optimflag==1)
    fprintf(FID,'problem ro eq\n');%infinite combustion chamber
else
    fprintf(FID,'problem ro fac fz\n');%finite combustion chamber
    fprintf(FID,'acat=%2.2f\n',requirements.acat);%contraction ratio, Ac/At
    fprintf(FID,'supar=%2.2f\n',aeatOFbest);%expansion ratio, Ae/At
end
fprintf(FID,'o/f=%1.2f\n',OF);
fprintf(FID,'p,bar=%3.1f\n',Pc);
fprintf(FID,'pip=%3.1f\n',Pc/Pe);%ratio of chamber to ambient pressure
% fprintf(FID,'supar=%2.2f\n',5.42);
fprintf(FID,'reactants\n');
fprintf(FID,'fuel= %s C %d O %d N %d H %d\n',fuel.name,...
    fuel.carbon,fuel.oxygen,fuel.nitrogen,fuel.hydrogen); 
fprintf(FID,'wt%%=%2.2f\n',100.0);
fprintf(FID,'h,kj=%2.2f\n',fuel(1).hf); 
fprintf(FID,'t(k)=%2.2f\n',298.16);
fprintf(FID,'oxid = %s C %d O %d N %d H %d\n',oxid.name,...
    oxid.carbon,oxid.oxygen,oxid.nitrogen,oxid.hydrogen);  
fprintf(FID,'wt%%= %2.2f\n',100);   
fprintf(FID,'t(k)=%2.2f\n',298.16);
fprintf(FID,'h,kj=%2.2f\n',oxid.hf); 
fprintf(FID,'output    short  transport\n');
fprintf(FID,'plot\n');  
% fprintf(FID,' p t rho mw cp gam sonic vis cond pran mach ae cf isp\n');
if run==1
    if optimflag==1
        fprintf(FID,'p t rho mw cp gam sonic\n');
    else
        fprintf(FID,'p t rho mwfz cpfz gamfz sonic\n');
    end
else
    if optimflag==1
        fprintf(FID,'vis cond pran mach ae cf isp\n');
    else
        fprintf(FID,'visfz condfz pranfz mach ae cf isp\n');
    end
end
fprintf(FID,'end\n');
fclose(FID);
fid = fopen(fullfile('fcea2','fname.txt'),'wt');
while fid<0
    fid = fopen(fullfile('fcea2','fname.txt'),'wt');
end
if run==1
    fprintf(fid,'regenLRE1\n0'); % write file name
else
    fprintf(fid,'regenLRE2\n0');
end
fclose(fid);