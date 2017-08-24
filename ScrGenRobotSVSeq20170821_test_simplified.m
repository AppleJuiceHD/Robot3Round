  function ScrGenRobotSVSeq20170821_test_simplified
  
fid=fopen('ScrGenSeq3Round_20170821_test_simplified_1.txt','w');      %��� FlowPath20170818 Һ·ͼ

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

 o(fid,'ADN 1');         %%   ���˶�����ϴλ  
end
 
  end

  function initializing(fid)
  
  %% SV0-5������ʹ�ã�
   o(fid,'SV[0] 0');    %%   
   o(fid,'SV[1] 0');    %%  
   o(fid,'SV[2] 0');    %%
   o(fid,'SV[3] 0');    %%
   o(fid,'SV[4] 0');    %%  
   o(fid,'SV[5] 0');    %%  
   
   
   o(fid,'SV[6] 0');    %%  ��ͨ���л�wash buffer��primer������0ΪWB
   o(fid,'SV[7] 0');    %%  ��ͨ���л�wash buffer��denature������0ΪWB
   o(fid,'SV[8] 0');    %%  ��ͨ��WBRA
   o(fid,'SV[9] 0');    %%  ��ͨ��RA
   o(fid,'SV[10] 0');   %%  ��ͨ��RB
   o(fid,'SV[11] 0');   %%  ��ͨ��WBRB
 
   
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
  
    %%    ��ϴλ
     o(fid,'ADN 1');         %%   ���˶�����ϴλ        
      Rinsing3Round_j1(fid);      
      if i == 3
         Rinsing3Round_j1(fid); 
      end
    
     o(fid,'ADN 2');         %%   ���˶�����ϴλupper position       
      SuckingAir(fid); 
 
    %%    �Լ�λ
    o(fid,'ADN 3');         %%   ���˶����Լ�λ��λ 
    o(fid,'WAIT 5000');

    
%     %% ������
% %     ���л���RA RB
%     o(fid,'SV[1] 0');%ly�޸�
%     o(fid,'SV[2] 0'); %ly�޸�
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

  %%   ��ϴ����������������ͨ�� 
%     SV[0]   diluting��E
%     SV[1]   RA
%     SV[2]   RB
%     SV[4]   I,ϡ��Һ

    %%  ע���
% SP_XC[1] CMD I       %%  ��ȡ��ϴҺ
% SP_XC[1] CMD E   %%  ���Լ�ƿ��
% SP_XC[1] CMD O   %% ���ڣ�waste

% o(fid,'SP_XC R P,10,100');
% o(fid,'SP_XC R D,10,100');        %%  ��O���Ƴ�
% o(fid,'SP_XC CMD OS2OA0');        %WastePump
% 
% SV[1] 0 
% SP_XC[1] CMD I       %%  ��ȡ��ϴҺ
% o(fid,'SP_XC R P,10,100');
% 
% SP_XC[1] CMD E   %%  ���Լ�ƿ��
% o(fid,'SP_XC CMD S2A0'); % Waste Pump��S2���ٶȣ��ɵ�1-20�� 1��죬20����
% 
% SP_XC[1] CMD I       %%  ��ȡ��ϴҺ
% o(fid,'SP_XC R P,10,100');
% SP_XC[1] CMD O   %% ���ڣ�waste
% o(fid,'SP_XC R D,10,100'); 
% SP_XC[1] CMD E   %%  ���Լ�ƿ��

% %% robot
% P04
% ADN 1 %%    ����16���ص���ϴ����λ
% ADN 2 %%    ����17������ϴ����λ
% ADN 3 %%    ����18���˶����Լ�λ��λ
% ADN 4 %%    ����19���˶����Լ�λ��λ



  end

  function WashSampleTubing_i1(fid)
  
   %������
    
     o(fid,'LOG Wash tube');
     
         %% ���л���RA RB
    o(fid,'SV[1] 0');%ly�޸�
    o(fid,'SV[2] 0'); %ly�޸�
    
    for i = 1:1
    %%  wash port 5 RA, 1st time 
      o(fid,'SV[9] 1');     %�� RA ·������ϴ��Һϴ��
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[9] 0');     %�� RA ·��
      
      
    %%  wash port 6 RB, 1st time 
      o(fid,'SV[10] 1');     %�� RB ·������ϴ��Һϴ��
      o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC CMD I'); 
      o(fid,'SP_XC WAIT');
      o(fid,'SP_XC R P,50,500');  %% syringe pull 500ul
      o(fid,'SP_XC WAIT');
      o(fid,'SV[10] 0');     %�� RB ·��
      
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
    

%     FULLRECORD=true;%ʲô��˼��
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
        o(fid,'ST_PRIOR MOVA 45000,-19500');   %��lane �޸�   %  Unit:um  % [10,-14]:kinetic position; [0,1]:[x,y] step length;[1,1]:1x1 figure;repeat 10 times
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
    o(fid,'WAIT 5000'); %%  �ŷ�Һ��5����
    
    for j=1:1 %%1:5
        %% ����ϴ�ؽ���
     for i = 1:5
         o(fid,'SV[4] 0');  %%  �л���ϡ��Һ���0
         o(fid,'SV[3] 0');  %%  �л���������

    %%  ��ȡ��ϴҺ����ϴ RA
    o(fid,'SV[0] 1');               %%  ת��RA
    o(fid,'SV[1] 1');               %%  ת��RA
    
    %   MixingPump(fid, Pflowrate, Pvolume, DFlowrate, DVolume)
    MixingPump(fid, 500, 1000, 500, 1000);
    
    %%  ��ȡ��ϴҺ����ϴ RB     
    o(fid,'SV[0] 0');               %%  ת��RB
    o(fid,'SV[2] 1');               %%  ת��RB
    
    MixingPump(fid, 500, 1000, 500, 1000);
    
     end
        
%         RARBRinsingNeedle(fid);
%         WashSampleTubing(fid);    %%�ǳ�ϴоƬ�Ĳ�����
                
        o(fid,'SV[3] 1');
        o(fid,'WAIT 5000'); 
    end
        
    %%%  �����ص��ر�״̬
    initializing(fid);            
  end
 
  function Rinsing3Round_j1(fid)
          %%  Rinsing
    o(fid,'SV[3] 1');
    o(fid,'WAIT 5000'); %%  �ŷ�Һ��5����
    
    for j=1:1 
        %% ����ϴ�ؽ���
     for i = 1:1
         o(fid,'SV[4] 0');  %%  �л���ϡ��Һ���0
         o(fid,'SV[3] 0');  %%  �л���������

    %%  ��ȡ��ϴҺ����ϴ RA
    o(fid,'SV[0] 1');               %%  ת��RA
    o(fid,'SV[1] 1');               %%  ת��RA
    
    %   MixingPump(fid, Pflowrate, Pvolume, DFlowrate, DVolume)
    MixingPump(fid, 300, 3000, 500, 3000);
    
    %%  ��ȡ��ϴҺ����ϴ RB     
    o(fid,'SV[0] 0');               %%  ת��RB
    o(fid,'SV[2] 1');               %%  ת��RB
    
    MixingPump(fid, 300, 3000, 500, 3000);

     end
         
     RARBRinsingNeedle_i1k1(fid);
     WashSampleTubing_i1(fid);
     
        o(fid,'SV[3] 1');
        o(fid,'WAIT 5000'); 
     end
        
    %%%  �����ص��ر�״̬
    initializing(fid);          
  end
  
  function SuckingAir(fid) 
      
    %% ������
%     ���л���RA RB
    o(fid,'SV[1] 0');%ly�޸�
    o(fid,'SV[2] 0'); %ly�޸�
    
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
           %%%  ����ϴ��׼������
             o(fid,'SV[4] 0');               %%  ת��L04

            %%  ��ȡL04����������ϴ��· 
            o(fid,'SV[0] 1');               %%  ת��RA
            o(fid,'SV[1] 1');               %%  ת��RA
 
            MixingPump(fid, 500, 1000, 500, 1000);
            
 
            %%  ��ȡL04����������ϴ��·
            o(fid,'SV[0] 0');               %%  ת��RB
            o(fid,'SV[2] 1');               %%  ת��RB
             
            MixingPump(fid, 500, 1000, 500, 1000);

        initializing(fid);  
          
      end
   
  function L04Mixing(fid)
            %%%    �Լ�λ����L04  
          o(fid,'SV[4] 0');               %%  ת��L04
          %% ʹ��L04��3mL������RA          
            o(fid,'SV[0] 1');               %%  ת��RA
            o(fid,'SV[1] 1');               %%  ת��RA
            o(fid,'WAIT 200');
       for i = 1:3 %%test 1:6->1:2,3ml->1ml
            %%  ��ȡL04����RA����
            MixingPump(fid, 500, 1000, 500, 1000);              
       end
     
           %% ʹ��L04��3mL������RB
            o(fid,'SV[0] 0');               %%  ת��RB
            o(fid,'SV[2] 1');               %%  ת��RB
            o(fid,'WAIT 200');
          for i = 1:3
            %%  ��ȡL04����RB����
            MixingPump(fid, 500, 1000, 500, 1000);
         end

      initializing(fid);          
          
        end
      
  function PreparingL19Diluting(fid)
              %%%  ����ϴ��׼������
            o(fid,'SV[4] 1');               %%  ת��L19
           
            %%  ��ȡL19����������ϴ��· 
            o(fid,'SV[0] 1');               %%  ת��RA
            o(fid,'SV[1] 1');               %%  ת��RA
 
            MixingPump(fid, 500, 1000, 500, 1000);
            
            %%  ��ȡL19����������ϴ��·
            o(fid,'SV[0] 0');               %%  ת��RB
            o(fid,'SV[2] 1');               %%  ת��RB
             
            MixingPump(fid, 500, 1000, 500, 1000);

        initializing(fid);             

      end
      
  function L19Mixing(fid)
     %%    �Լ�λ
          o(fid,'SV[4] 1');               %%  ת��L19
          
          %% ʹ��L19��3mL������RA          
            o(fid,'SV[0] 1');               %%  ת��RA
            o(fid,'SV[1] 1');               %%  ת��RA
            o(fid,'WAIT 200');
       for i = 1:3 %%test 1:6->1:2,3ml->1ml
            %%  ��ȡL19����RA����
            MixingPump(fid, 500, 1000, 500, 1000);              
       end
     
           %% ʹ��L04��3mL������RB
            o(fid,'SV[0] 0');               %%  ת��RB
            o(fid,'SV[2] 1');               %%  ת��RB
            o(fid,'WAIT 200');
          for i = 1:3
            %%  ��ȡL19����RB����
            MixingPump(fid, 500, 1000, 500, 1000);
         end

      initializing(fid);   
      
      end

  function RARBRinsingNeedle_i1k1(fid)
  
   for i=1:1            %%��needle��ϴǰ���������ص�Һ�壬���³����ɾ�Һ�壬�ظ�2�Ρ�
    o(fid,'SV[3] 1');   %%  ���ŷ�Һ
    o(fid,'WAIT 5000'); %%  �ŷ�Һ��5����
    o(fid,'SV[4] 0');  %%  �л���ϡ��Һ���0
    o(fid,'SV[3] 0');  %%  �л���������
    
    o(fid,'SV[0] 1');               %%  ת��RA
    o(fid,'SV[1] 1');               %%  ת��RA
    MixingPump(fid, 300, 3000, 300, 3000);
       
    o(fid,'SV[0] 0');               %%  ת��RB
    o(fid,'SV[2] 1');               %%  ת��RB
    MixingPump(fid, 300, 3000, 300, 3000);
   end
   
      %% ��RA��RB����ϴ���ڸ��������
          o(fid,'SP_XC CMD S2OA0I');  %% syringe zero
          o(fid,'SP_XC WAIT');
          o(fid,'SP_XC CMD I'); 
          o(fid,'SP_XC WAIT');
          o(fid,'SV[1] 0');%ly�޸�
          o(fid,'SV[2] 0'); %ly�޸�
     for k  = 1:1   %%test 1:5->1:1 ���¸�һ�β���
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
%             o(fid,'SV[6] 1');         %%  ��ȡ��ϴҺϡ��Һ���Ҳ࣬ϡ��Һ
%             o(fid,'WAIT 200');
%             o(fid,'PP_KQZ1 R P, %d,%d', Pflowrate, Pvolume);      %%  ��ȡ
%             o(fid,'PP_KQZ1 WAIT');
            o(fid,'SP_XC[2] R P,%d,%d',Pflowrate,Pvolume);    %��ȡ��ϴҺ��max 5ml
            o(fid,'SP_XC[2] WAIT');
            %%%  out 
%             o(fid,'SV[7] 1');
%             o(fid,'SV[6] 0');         %%  �³���ϴҺϡ��Һ����࣬ϡ��Һ
%             o(fid,'WAIT 200');
%             o(fid,'PP_KQZ1 R D, %d,%d',DFlowrate, DVolume);      %%  �³�
%             o(fid,'PP_KQZ1 WAIT');
%             o(fid,'WAIT 1000');   
            o(fid,'SP_XC[2] R D,%d,%d',DFlowrate,DVolume);    %%  �³���ϴҺϡ��Һ����࣬ϡ��Һ
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
  


 
 
 
