  function ScrGenRobotSVSeq20170821_test_simplified
  
fid=fopen('ScrGenSeq3Round_20170821_test_simplified_1.txt','w');      %结合 FlowPath20170818 液路图

initializing(fid);

para = loadParameters();
%%  program
for i = 1:para.round
    i
switch  num2str(i)
    case '1'   
%         %%  for mixing, ADN 1 4 1 3 4 1
        ReagentSelection(fid, i);      %% with moving
%         Denature(fid, para);
        AnnealingSeqPrimer(fid, para); 
        CycleNumber = (1:3);
        Seq(fid, para, CycleNumber,i);    %% with moving
% %         AfterMixing(fid);
    case '2'
        ReagentSelection(fid, i);
%         WashSampleTubing(fid);
          Denature(fid, para);
          AnnealingSeqPrimer(fid, para);
          CycleNumber = (1:3);
          Seq(fid, para, CycleNumber,i);
%         SeqWithoutSequencing(fid);
    case '3'
          ReagentSelection(fid, i);
          Denature(fid, para);
          AnnealingSeqPrimer(fid, para);
          CycleNumber = (1:3);
          Seq(fid, para, CycleNumber,i);
end

 o(fid,'ADN 1');         %%   针运动到清洗位  
end
 
  end

  function initializing(fid)
  
  %% SV0-5，三轮使用，
   o(fid,'SV[0] 0');    %%   
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
  
  function para = loadParameters()
        para.round = 3;
        para.IMAGING_TILES1='[20,-19.5],[10,1],[3,1]';       
        para.IMAGING_CONDITIONS1='{C100T10,1.0,001000}';
        para.dir=['E:\data\170810_YL_Seq_3RR\HH3HH_WashinJunk_Round1_5Re_MK_Round2_5Re_KM_Round3_10Re_MK\Round1';...
            'E:\data\170810_YL_Seq_3RR\HH3HH_WashinJunk_Round1_5Re_MK_Round2_5Re_KM_Round3_10Re_MK\Round2';...
            'E:\data\170810_YL_Seq_3RR\HH3HH_WashinJunk_Round1_5Re_MK_Round2_5Re_KM_Round3_10Re_MK\Round3';];

        para.exptime=1;
        para.intensity=100;

        para.RECORD_PREWASH=0;
        para.RECORD_INJ=1;
        para.RECORD_KINETIC=1;
        para.RECORD_REACTION=1;
        para.SAVE_KIN_IMG=0;
        para.time_total=55;
        para.time_period=5;

        para.vol_denature=500;  %%  Denature
        para.vol_seqprimer=200; %%  Anneal
end

  function ReagentSelection(fid, i)
    %%    ADN 1 2 3 4, 1 2 3 4, 1 2 3 4  
  
    %%    清洗位
     o(fid,'ADN 1');         %%   针运动到清洗位        
      Rinsing3Round_j1(fid);      
      if i == 3
         Rinsing3Round_j1(fid); 
      end
    
     o(fid,'ADN 2');         %%   针运动到清洗位upper position       
      SuckingAir(fid); 
 
    %%    试剂位
    o(fid,'ADN 3');         %%   针运动到试剂位高位 
    o(fid,'WAIT 5000');

    
%     %% 吸空气
% %     阀切换至RA RB
%     o(fid,'SV[1] 0');%ly修改
%     o(fid,'SV[2] 0'); %ly修改
%     
%      o(fid,'LOG Air');
%       o(fid,'RV_7970 P 5');
%       o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
%       o(fid,'SP_XC WAIT');
%       o(fid,'SP_XC CMD I'); 
%       o(fid,'SP_XC WAIT');
%       o(fid,'SP_XC R P,50,100');  %% syringe pull 500ul
%       o(fid,'SP_XC WAIT');
%       o(fid,'RV_7970 P 6');
%       o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
%       o(fid,'SP_XC WAIT');
%       o(fid,'SP_XC CMD I'); 
%       o(fid,'SP_XC WAIT');
%       o(fid,'SP_XC R P,50,100');  %% syringe pull 500ul
%       o(fid,'SP_XC WAIT')           

  %%   清洗及混匀组件，五个三通阀 
%     SV[0]   diluting，E
%     SV[1]   RA
%     SV[2]   RB
%     SV[4]   I,稀释液

    %%  注射泵
% SP_XC[1] CMD I       %%  吸取清洗液
% SP_XC[1] CMD E   %%  与试剂瓶连
% SP_XC[1] CMD O   %% 出口，waste

% o(fid,'SP_XC R P,10,100');
% o(fid,'SP_XC R D,10,100');        %%  从O口推出
% o(fid,'SP_XC CMD OS2OA0');        %WastePump
% 
% SV[1] 0 
% SP_XC[1] CMD I       %%  吸取清洗液
% o(fid,'SP_XC R P,10,100');
% 
% SP_XC[1] CMD E   %%  与试剂瓶连
% o(fid,'SP_XC CMD S2A0'); % Waste Pump，S2是速度，可调1-20， 1最快，20最慢
% 
% SP_XC[1] CMD I       %%  吸取清洗液
% o(fid,'SP_XC R P,10,100');
% SP_XC[1] CMD O   %% 出口，waste
% o(fid,'SP_XC R D,10,100'); 
% SP_XC[1] CMD E   %%  与试剂瓶连

% %% robot
% P04
% ADN 1 %%    代号16，回到清洗池下位
% ADN 2 %%    代号17，到清洗池上位
% ADN 3 %%    代号18，运动到试剂位上位
% ADN 4 %%    代号19，运动到试剂位下位



  end

  function WashSampleTubing_i1(fid)
  
   %吸空气
    
     o(fid,'LOG Wash tube');
     
         %% 阀切换至RA RB
    o(fid,'SV[1] 0');%ly修改
    o(fid,'SV[2] 0'); %ly修改
    
    for i = 1:1
    %%  wash port 5 RA, 1st time 
      o(fid,'SV[9] 1');     %开 RA 路，用清洗池液洗；
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[9] 0');     %关 RA 路；
      
      
    %%  wash port 6 RB, 1st time 
      o(fid,'SV[10] 1');     %开 RB 路，用清洗池液洗；
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[10] 0');     %开 RB 路；
      
    end
     
  
  end
  
  function Denature(fid, para)

         o(fid,'SV[7] 1');  
         o(fid,'SV[8] 1');  
     o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
     o(fid,'SP_XC WAIT');
     o(fid,'SP_XC CMD I'); 
     o(fid,'SP_XC WAIT');
     o(fid,'SP_XC R P,20,%d',para.vol_denature);  %% syringe pull 500ul
     o(fid,'SP_XC WAIT');
     o(fid,'WAIT 300000');

         o(fid,'SV[7] 0');  
         o(fid,'SV[8] 0');  
     
     para.WBSVNb = 8;
     wash_step(fid,para);
%      wash_step(fid,para);
%      wash_step(fid,para);

      o(fid,'\n\n');
  end
   
  function AnnealingSeqPrimer(fid, para)
        %% Annealing
        o(fid,'LOG Annealing ');

           %% Loading Seq Primer 
         o(fid,'LOG Seq Primer');  
         
         o(fid,'SV[6] 1');  
         o(fid,'SV[11] 1');  
         o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
         o(fid,'SP_XC WAIT');
         o(fid,'SP_XC CMD I'); 
         o(fid,'SP_XC WAIT');
         o(fid,'SP_XC R P,20,%d',para.vol_seqprimer);  %% syringe pull 500ul
         o(fid,'SP_XC WAIT');         

            %% thermal control
        for CYCLE_NUMBER=0:140
            temp4=95-0.5*CYCLE_NUMBER;
            o(fid,'TC_720 SET 1,%f',temp4);
            o(fid,'TC_720 WAIT');
            o(fid,'WAIT 12000');
        end
         o(fid,'TC_720 SET 1,25');  
         o(fid,'TC_720 WAIT');

         o(fid,'SV[6] 0');  
         o(fid,'SV[11] 0');  
         
         para.WBSVNb = 11;
         wash_step(fid,para);
%          wash_step(fid,para);
%          wash_step(fid,para);
%          
           o(fid,'\n\n');
  end
 
  function Seq(fid, para, CycleNumber,round)
   %% Seq
  o(fid,'LOG Seq');
  o(fid,'CAM_INIT');
   o(fid,'MKDIRG %s',para.dir(round,:));
CycleNumber;
para.dir(round,:);
  %cyc280
 sequence='ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB';
for CYCLE_NUMBER=CycleNumber %1:numel(sequence)
  if CYCLE_NUMBER==3
      o(fid,'ADN 4'); 
  end
     
    if (CYCLE_NUMBER==1 ||CYCLE_NUMBER==2)
       para.vol_rxn=400;
    else
       para.vol_rxn=100;
    end
    
    if sequence(CYCLE_NUMBER)=='A'
        para.ReagentNb = 9;
        para.WBSVNb = 8;
    else
        para.ReagentNb = 10;
        para.WBSVNb = 11;
    end
    

%     FULLRECORD=true;%什么意思？
    o(fid,'LOG cycle_%d',CYCLE_NUMBER);   
    o(fid,'TC_720 SET 1,4');       
    
    o(fid,'LOG Wash');

    wash_step(fid,para);

   % seal snap
    if para.RECORD_PREWASH
        o(fid,'LOG wash snap');
        o(fid,'L_TL 1,%d',para.intensity);
        o(fid,'CAM_FL4 %d,cyc_%d-S0',para.exptime,CYCLE_NUMBER);
        o(fid,'L_TL 0,%d',para.intensity);
    end
    
    o(fid,'\n\n');
    o(fid,'LOG inject sample');
    inject(fid,para);
    
    o(fid,'TC_720 SET 1,15');
    o(fid,'TC_720 WAIT');
    o(fid,'WAIT 3000');
    
    if para.RECORD_INJ
        o(fid,'LOG inject scan');
%       o(fid,'L_TL 1,%d',intensity);
%       o(fid,'CAM_FL4 %d,cyc_%d-S1',exptime,CYCLE_NUMBER);
        o(fid,'CAM_FASTSCAN2 %d,%s,%s,%s',CYCLE_NUMBER,'S1',para.IMAGING_TILES1,para.IMAGING_CONDITIONS1);
        o(fid,'L_TL 0,%d',para.intensity);
    end

    o(fid,'SP_XC CMD S2OA0I');    

    o(fid,'\n\n');
    o(fid,'LOG reaction');
    o(fid,'TC_720 SET 1,65');
    if para.RECORD_KINETIC
        o(fid,'MKDIR cyc_%d',CYCLE_NUMBER);
        o(fid,'ST_PRIOR MOVA 45000,-19500');   %换lane 修改   %  Unit:um  % [10,-14]:kinetic position; [0,1]:[x,y] step length;[1,1]:1x1 figure;repeat 10 times
        o(fid,'CAM_KINETIC cyc_%d,kin,%f,%f,%f,%d,%d',CYCLE_NUMBER,para.time_total,para.time_period,para.exptime,para.intensity,para.SAVE_KIN_IMG);
        %o(fid,'CAM_FASTSCAN2 %d,%s,%s,%s',CYCLE_NUMBER,'S2',IMAGING_TILES2,IMAGING_CONDITIONS1);
        %o(fid,'WAIT 5000');
        %o(fid,'CAM_FASTSCAN2 %d,%s,%s,%s',CYCLE_NUMBER,'S2',IMAGING_TILES3,IMAGING_CONDITIONS1);
    else
        o(fid,'WAIT %d',para.time_total*1000);
    end
    o(fid,'TC_720 SET 1,15');
    o(fid,'TC_720 WAIT');
    o(fid,'WAIT 3000');
    
    % reaction scan
   if para.RECORD_REACTION
        o(fid,'LOG reaction scan');
%         o(fid,'L_TL 1,%d',intensity);
%         o(fid,'CAM_FL4 %d,cyc_%d-S2',exptime,CYCLE_NUMBER);
         o(fid,'CAM_FASTSCAN2 %d,%s,%s,%s',CYCLE_NUMBER,'S3',para.IMAGING_TILES1,para.IMAGING_CONDITIONS1);
         o(fid,'L_TL 0,%d',para.intensity);
   end
    

     o(fid,'\n\n');
end
 o(fid,'CAM_CLOSE');

o(fid,'TC_720 SET 0');
wash_step(fid,para);

  o(fid,'\n\n');
  end

  function SeqWithoutSequencing(fid)
            o(fid,'ADN 4'); 
  end
  
  function AfterMixing(fid)
            o(fid,'ADN 4');
            o(fid,'ADN 1'); 
            
  end

 function wash_step(fid, para)
 %% Wash step
 o(fid,'LOG Wash');
 o(fid,'SV[%d] 1',para.WBSVNb);   
 o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC CMD I'); 
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
 o(fid,'SP_XC WAIT');
 o(fid,'SV[%d] 0',para.WBSVNb);
end
 
  function inject(fid,para)

    % inj reaction
    o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
    o(fid,'SP_XC WAIT');
    o(fid,'SV[%d] 1',para.ReagentNb);   
    o(fid,'WAIT 500');
    o(fid,'SP_XC CMD I'); 
    o(fid,'SP_XC WAIT');
    o(fid,'SP_XC R P,20,%d',para.vol_rxn);  %% vol_drop ul
    o(fid,'SP_XC WAIT');
    o(fid,'WAIT 1000');
    o(fid,'SV[%d] 0',para.ReagentNb);  
  end
  
  function Rinsing(fid)
              %%  Rinsing
    o(fid,'SV[3] 1');
    o(fid,'WAIT 5000'); %%  排废液，5秒钟
    
    for j=1:1 %%1:5
        %% 在清洗池浸泡
     for i = 1:5
         o(fid,'SV[4] 0');  %%  切换到稀释液入口0
         o(fid,'SV[3] 0');  %%  切换到溢流池

    %%  吸取清洗液并清洗 RA
    o(fid,'SV[0] 1');               %%  转到RA
    o(fid,'SV[1] 1');               %%  转到RA
    
    %   MixingPump(fid, Pflowrate, Pvolume, DFlowrate, DVolume)
    MixingPump(fid, 500, 1000, 500, 1000);
    
    %%  吸取清洗液并清洗 RB     
    o(fid,'SV[0] 0');               %%  转到RB
    o(fid,'SV[2] 1');               %%  转到RB
    
    MixingPump(fid, 500, 1000, 500, 1000);
    
     end
        
%         RARBRinsingNeedle(fid);
%         WashSampleTubing(fid);    %%是冲洗芯片的步骤吗？
                
        o(fid,'SV[3] 1');
        o(fid,'WAIT 5000'); 
    end
        
    %%%  阀都回到关闭状态
    initializing(fid);            
  end
 
  function Rinsing3Round_j1(fid)
          %%  Rinsing
    o(fid,'SV[3] 1');
    o(fid,'WAIT 5000'); %%  排废液，5秒钟
    
    for j=1:1 
        %% 在清洗池浸泡
     for i = 1:1
         o(fid,'SV[4] 0');  %%  切换到稀释液入口0
         o(fid,'SV[3] 0');  %%  切换到溢流池

    %%  吸取清洗液并清洗 RA
    o(fid,'SV[0] 1');               %%  转到RA
    o(fid,'SV[1] 1');               %%  转到RA
    
    %   MixingPump(fid, Pflowrate, Pvolume, DFlowrate, DVolume)
    MixingPump(fid, 300, 3000, 500, 3000);
    
    %%  吸取清洗液并清洗 RB     
    o(fid,'SV[0] 0');               %%  转到RB
    o(fid,'SV[2] 1');               %%  转到RB
    
    MixingPump(fid, 300, 3000, 500, 3000);

     end
         
     RARBRinsingNeedle_i1k1(fid);
     WashSampleTubing_i1(fid);
     
        o(fid,'SV[3] 1');
        o(fid,'WAIT 5000'); 
     end
        
    %%%  阀都回到关闭状态
    initializing(fid);          
  end
  
  function SuckingAir(fid) 
      
    %% 吸空气
%     阀切换至RA RB
    o(fid,'SV[1] 0');%ly修改
    o(fid,'SV[2] 0'); %ly修改
    
     o(fid,'LOG Air');
      o(fid,'SV[9] 1');
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,100');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[9] 0');
      
      o(fid,'SV[10] 1');
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,100');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[10] 0');
  end
 
  function PreparingL04Diluting(fid)
           %%%  在清洗池准备混匀
             o(fid,'SV[4] 0');               %%  转到L04

            %%  吸取L04并排气及清洗管路 
            o(fid,'SV[0] 1');               %%  转到RA
            o(fid,'SV[1] 1');               %%  转到RA
 
            MixingPump(fid, 500, 1000, 500, 1000);
            
 
            %%  吸取L04并排气及清洗管路
            o(fid,'SV[0] 0');               %%  转到RB
            o(fid,'SV[2] 1');               %%  转到RB
             
            MixingPump(fid, 500, 1000, 500, 1000);

        initializing(fid);  
          
      end
   
  function L04Mixing(fid)
            %%%    试剂位混匀L04  
          o(fid,'SV[4] 0');               %%  转到L04
          %% 使用L04，3mL，混匀RA          
            o(fid,'SV[0] 1');               %%  转到RA
            o(fid,'SV[1] 1');               %%  转到RA
            o(fid,'WAIT 200');
       for i = 1:3 %%test 1:6->1:2,3ml->1ml
            %%  吸取L04并在RA混匀
            MixingPump(fid, 500, 1000, 500, 1000);              
       end
     
           %% 使用L04，3mL，混匀RB
            o(fid,'SV[0] 0');               %%  转到RB
            o(fid,'SV[2] 1');               %%  转到RB
            o(fid,'WAIT 200');
          for i = 1:3
            %%  吸取L04并在RB混匀
            MixingPump(fid, 500, 1000, 500, 1000);
         end

      initializing(fid);          
          
        end
      
  function PreparingL19Diluting(fid)
              %%%  在清洗池准备混匀
            o(fid,'SV[4] 1');               %%  转到L19
           
            %%  吸取L19并排气及清洗管路 
            o(fid,'SV[0] 1');               %%  转到RA
            o(fid,'SV[1] 1');               %%  转到RA
 
            MixingPump(fid, 500, 1000, 500, 1000);
            
            %%  吸取L19并排气及清洗管路
            o(fid,'SV[0] 0');               %%  转到RB
            o(fid,'SV[2] 1');               %%  转到RB
             
            MixingPump(fid, 500, 1000, 500, 1000);

        initializing(fid);             

      end
      
  function L19Mixing(fid)
     %%    试剂位
          o(fid,'SV[4] 1');               %%  转到L19
          
          %% 使用L19，3mL，混匀RA          
            o(fid,'SV[0] 1');               %%  转到RA
            o(fid,'SV[1] 1');               %%  转到RA
            o(fid,'WAIT 200');
       for i = 1:3 %%test 1:6->1:2,3ml->1ml
            %%  吸取L19并在RA混匀
            MixingPump(fid, 500, 1000, 500, 1000);              
       end
     
           %% 使用L04，3mL，混匀RB
            o(fid,'SV[0] 0');               %%  转到RB
            o(fid,'SV[2] 1');               %%  转到RB
            o(fid,'WAIT 200');
          for i = 1:3
            %%  吸取L19并在RB混匀
            MixingPump(fid, 500, 1000, 500, 1000);
         end

      initializing(fid);   
      
      end

  function RARBRinsingNeedle_i1k1(fid)
  
   for i=1:1            %%在needle清洗前排完溢流池的液体，重新充满干净液体，重复2次。
    o(fid,'SV[3] 1');   %%  打开排废液
    o(fid,'WAIT 5000'); %%  排废液，5秒钟
    o(fid,'SV[4] 0');  %%  切换到稀释液入口0
    o(fid,'SV[3] 0');  %%  切换到溢流池
    
    o(fid,'SV[0] 1');               %%  转到RA
    o(fid,'SV[1] 1');               %%  转到RA
    MixingPump(fid, 300, 3000, 300, 3000);
       
    o(fid,'SV[0] 0');               %%  转到RB
    o(fid,'SV[2] 1');               %%  转到RB
    MixingPump(fid, 300, 3000, 300, 3000);
   end
   
      %% 针RA、RB在清洗池内各吸吐五次
          o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
          o(fid,'SP_XC WAIT');
          o(fid,'SP_XC CMD I'); 
          o(fid,'SP_XC WAIT');
          o(fid,'SV[1] 0');%ly修改
          o(fid,'SV[2] 0'); %ly修改
     for k  = 1:1   %%test 1:5->1:1 吸吐各一次测试
          o(fid,'SV[9] 1');
          o(fid,'SP_XC R P,50,100');  %% syringe pull 100ul
          o(fid,'SP_XC WAIT');
          o(fid,'SP_XC R D,50,100');  %% syringe push 100ul
          o(fid,'SP_XC WAIT');
          o(fid,'SV[9] 0');
          
          o(fid,'SV[10] 1');
          o(fid,'SP_XC R P,50,100');  %% syringe pull 100ul
          o(fid,'SP_XC WAIT');  
          o(fid,'SP_XC R D,50,100');  %% syringe push 100ul
          o(fid,'SP_XC WAIT');
          o(fid,'SV[10] 0');
          
     end 
     
  end
 
  function MixingPump(fid, Pflowrate, Pvolume, DFlowrate, DVolume)
  
   %%%  in 
%             o(fid,'SV[7] 0');
%             o(fid,'SV[6] 1');         %%  吸取清洗液稀释液，右侧，稀释液
%             o(fid,'WAIT 200');
%             o(fid,'PP_KQZ1 R P, %d,%d', Pflowrate, Pvolume);      %%  吸取
%             o(fid,'PP_KQZ1 WAIT');
            o(fid,'SP_XC[2] R P,%d,%d',Pflowrate,Pvolume);    %吸取清洗液，max 5ml
            o(fid,'SP_XC[2] WAIT');
            %%%  out 
%             o(fid,'SV[7] 1');
%             o(fid,'SV[6] 0');         %%  吐出清洗液稀释液，左侧，稀释液
%             o(fid,'WAIT 200');
%             o(fid,'PP_KQZ1 R D, %d,%d',DFlowrate, DVolume);      %%  吐出
%             o(fid,'PP_KQZ1 WAIT');
%             o(fid,'WAIT 1000');   
            o(fid,'SP_XC[2] R D,%d,%d',DFlowrate,DVolume);    %%  吐出清洗液稀释液，左侧，稀释液
            o(fid,'SP_XC[2] WAIT');
  
  end
     
  function o(f,s,varargin)
    fprintf(f,[s,'\r\n'],varargin{:});
  end
 
  
 function loading_pcrmix(fid,port_pcrmix,vol_pcrmix)
 o(fid,'RV_7970 P %d',port_pcrmix);
 o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
 o(fid,'SP_XC WAIT'); 
 o(fid,'SP_XC CMD I'); 
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC R P,20,%d',vol_pcrmix);  %% syringe pull 500ul
 o(fid,'SP_XC WAIT');
 end
 function loading_qcprimer(fid,port_qcprimer,vol_qcprimer)
 o(fid,'RV_7970 P %d',port_qcprimer);
 o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
 o(fid,'SP_XC WAIT');  
 o(fid,'SP_XC CMD I'); 
 o(fid,'SP_XC WAIT');
 o(fid,'SP_XC R P,20,%d',vol_qcprimer);  %% syringe pull 500ul
 o(fid,'SP_XC WAIT');
 end
 function comments()
% o(fid,'TC_720 SET 1,15');
% o(fid,'TC_720 WAIT');

%% Loading PCRMix
% o(fid,'LOG Loading PCRMix');
% loading_pcrmix(fid,port_pcrmix,vol_pcrmix)

%% PCR Thermocycle
% o(fid,'LOG PCR Thermocycle');
% o(fid,'TC_720 SET 1,95');
% o(fid,'TC_720 WAIT');
% o(fid,'WAIT 90000');
% for CYCLE_NUMBER=0:15
%     o(fid,'TC_720 SET 1,95');
%     o(fid,'TC_720 WAIT');
%     o(fid,'WAIT 30000');
%     tem=0.3
%     temp=65-tem*CYCLE_NUMBER
%     o(fid,'TC_720 SET 1,%f',temp);
%     o(fid,'TC_720 WAIT');
%     o(fid,'WAIT 15000');
%     o(fid,'TC_720 SET 1,72');
%     o(fid,'TC_720 WAIT');
%     o(fid,'WAIT 30000');
% end
% for CYCLE_NUMBER=1:30
%     o(fid,'TC_720 SET 1,95');
%     o(fid,'TC_720 WAIT');
%     o(fid,'WAIT 30000');
%     o(fid,'TC_720 SET 1,65');
%     o(fid,'TC_720 WAIT');
%     o(fid,'WAIT 300000');
% end
% %% Wash


% 
% 
%  o(fid,'LOG Wash');
%  wash_step(fid,port_wash)
%  wash_step(fid,port_wash)
%  wash_step(fid,port_wash)
% 
% % %% Formamide Denature
% %  o(fid,'LOG Denature');
% %  o(fid,'TC_720 SET 1,25');   
% %  loading_denature(fid,port_denature,vol_denature)
% %  o(fid,'WAIT 300000');
% %  
% % %% Wash
% %  o(fid,'LOG Wash');
% %  wash_step(fid,port_wash)
% %  wash_step(fid,port_wash)
% %  wash_step(fid,port_wash)
% % 
% % %% Loading QC Primer 
% %  o(fid,'LOG Loading QC Primer ');
% %  loading_qcprimer(fid,port_qcprimer,vol_qcprimer)
% %  
% % %% Annealing
% %  o(fid,'LOG Annealing ');
% %  for CYCLE_NUMBER=0:140
% %     temp4=95-0.5*CYCLE_NUMBER
% %     o(fid,'TC_720 SET 1,%f',temp4);
% %     o(fid,'TC_720 WAIT');
% %     o(fid,'WAIT 12000');
% %  end
% %  o(fid,'TC_720 SET 1,25');  
% %  o(fid,'TC_720 WAIT');
% % %  
% %% Wash
%  o(fid,'LOG Wash');
%  wash_step(fid,port_wash)
%  wash_step(fid,port_wash)
%  wash_step(fid,port_wash)
% % %  
% %  %% QC
% %  o(fid,'QC');
% %  o(fid,'judge');
% %  
% % Formamide Denature
%  o(fid,'LOG Denature');
%  o(fid,'TC_720 SET 1,25');   
%  loading_denature(fid,port_denature,vol_denature)
%  o(fid,'WAIT 300000');
 
 end
  


 
 
 
