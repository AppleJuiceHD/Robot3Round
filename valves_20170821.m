function valves_20170821

fid=fopen('Valves_20170821_test_simplified_3.txt','w');
initialize_valves(fid);
test_valves(fid,'B');
% test_valves(fid,'B');

end

function test_valves(fid,para)

o(fid,'LOG TEST_VALVES %s',para);
o(fid,'SV[1] 0');
o(fid,'SV[2] 0');
wash_step(fid,para);
inject(fid,para);
wash_step(fid,para);

end

function wash_step(fid, para)
    
if para=='A'
    ReagentNb=8;
else
    ReagentNb=11;
end
    
 o(fid,'LOG Wash');
 o(fid,'SV[%d] 1',ReagentNb);   
 o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC CMD I'); 
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
 o(fid,'SP_XC WAIT');
 o(fid,'SV[%d] 0',ReagentNb);
 
end

  function inject(fid,para)
  
    o(fid,'LOG Inject');
    o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
    o(fid,'SP_XC WAIT');
    
    if para=='A'
        ReagentNb=9;
    else
        ReagentNb=10;
    end
    
    o(fid,'SV[%d] 1',ReagentNb);   
    o(fid,'WAIT 500');
    o(fid,'SP_XC CMD I'); 
    o(fid,'SP_XC WAIT');
    o(fid,'SP_XC R P,20,%d',400);  %% vol_drop ul
    o(fid,'SP_XC WAIT');
    o(fid,'WAIT 1000');
    o(fid,'SV[%d] 0',ReagentNb); 
    
  end

  function initialize_valves(fid)

   o(fid,'SV[0] 0');    %%   0-5 3round robot valves
   o(fid,'SV[1] 0');    %%  
   o(fid,'SV[2] 0');    %%
   o(fid,'SV[3] 0');    %%
   o(fid,'SV[4] 0');    %%  
   o(fid,'SV[5] 0');    %%  
   
   o(fid,'SV[6] 0');    %%  三通，切换wash buffer和primer，常开0为WB
   o(fid,'SV[7] 0');    %%  三通，切换wash buffer和denature，常开0为WB
   o(fid,'SV[8] 0');    %%  两通，WBRA
   o(fid,'SV[9] 0');    %%  两通，RA
   o(fid,'SV[10] 0');   %%  两通，RB
   o(fid,'SV[11] 0');   %%  两通，WBRB
  
  end

function o(f,s,varargin)
    fprintf(f,[s,'\r\n'],varargin{:});
end
 