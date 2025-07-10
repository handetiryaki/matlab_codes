function [ z ] = data_matrix_construction_expdata(term_weighting_scheme,feature_size,feature_selection_method,dataset_type,train_set, tokenization_type,usestopwordremoval,uselowercase, usestemming)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
tic;


% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5; 
DATASET_REUTERS_PARTIAL = 6;
DATASET_NEWS3 = 7;
DATASET_SPAMSMSENG = 8;
DATASET_WEBKB = 9;
DATASET_ENRON1 = 10;
DATASET_BRITISHENGLISHSPAMSMS = 11;
DATASET_SPAMEMAILTR = 12;
DATASET_ENRON1_PARTIAL = 13;
DATASET_CLASSIC3 = 14;
DATASET_OHSUMED_SINGLELABEL_VERSION = 17;
DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION = 18;
DATASET_MININEWS20 = 19;
DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION = 20;
DATASET_REUTERS_TOP15 = 21;
DATASET_REUTERS_TOP20 = 22;
DATASET_CATDOG = 23;
DATASET_REUTERS_FOLDERS = 24;
DATASET_REUTERS_FOLDERS_ALL = 25;
DATASET_SPAM = 26;
DATASET_NEWS2C = 27;



if dataset_type==DATASET_REUTERS
    resfoldername='experiments_with_reuters_21578';
elseif dataset_type==DATASET_MILLIYET
    resfoldername='experiments_with_milliyet_collection';
elseif dataset_type==DATASET_SPAMSMSTR
    resfoldername='experiments_with_spamsmstr';
elseif dataset_type==DATASET_REUTERS_PARTIAL
    resfoldername='experiments_with_reuters_partial';
elseif dataset_type==DATASET_WEBKB
    resfoldername='experiments_with_webkb';
elseif dataset_type==DATASET_BRITISHENGLISHSPAMSMS
    resfoldername='experiments_with_britishenglishspamsms';
elseif dataset_type==DATASET_SPAMEMAILTR
    resfoldername='experiments_with_spamemailtr';
elseif dataset_type==DATASET_ENRON1_PARTIAL
    resfoldername='experiments_with_spamemailenronpartial';
elseif dataset_type==DATASET_CLASSIC3
    resfoldername='experiments_with_classic3';
elseif dataset_type==DATASET_NEWS3
    resfoldername='experiments_with_news3';
elseif dataset_type==DATASET_NEWS10
    resfoldername='experiments_with_news10';
elseif dataset_type==DATASET_NEWS20
    resfoldername='experiments_with_news20';
elseif dataset_type==DATASET_MININEWS20
    resfoldername='experiments_with_mininews20';
elseif dataset_type==DATASET_OHSUMED_SINGLELABEL_VERSION
    resfoldername='experiments_with_ohsumed_singlelabel';
elseif dataset_type==DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_engabstract_singlelabel';
elseif dataset_type==DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_trabstract_singlelabel';      
elseif dataset_type==DATASET_ENRON1
    resfoldername='experiments_with_enron1'; 
elseif dataset_type==DATASET_REUTERS_TOP15
    resfoldername='experiments_with_reuters_top15';     
elseif dataset_type==DATASET_REUTERS_TOP20
    resfoldername='experiments_with_reuters_top20';
elseif dataset_type==DATASET_CATDOG
    resfoldername='experiments_with_catdog';
elseif dataset_type==DATASET_REUTERS_FOLDERS
    resfoldername='experiments_with_reuters_folders';
elseif dataset_type==DATASET_REUTERS_FOLDERS_ALL
    resfoldername='experiments_with_reuters_folders_all';
elseif dataset_type==DATASET_SPAM
    resfoldername='experiments_with_spam';
elseif dataset_type==DATASET_NEWS2C
    resfoldername='experiments_with_news2c';
end


global dataset_class_idx;
global stopword_list_map;
global term_feature_map;
global document_frequency_map;




destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
eval(['load ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
eval(['load ', strcat(destination_fpath,'document_frequencies.mat'), '  document_frequency_map'])



document_frequency_map=containers.Map();

lenterms=length(term_list_pre);

for i=1:lenterms
    if isKey(document_frequency_map,term_list_pre(1,i).NAME)==1
        document_frequency_map(term_list_pre(1,i).NAME)=document_frequency_map(term_list_pre(1,i).NAME)+term_list_pre(1,i).DF;
    else
        document_frequency_map(term_list_pre(1,i).NAME)=term_list_pre(1,i).DF;
    end
end

if train_set==1
        if (feature_selection_method==1)%mutual information
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mi'])
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mi(1,i).term);
            end
        elseif (feature_selection_method==2)%gini index
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gi'])
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gi(1,i).term);
            end    
        elseif (feature_selection_method==3)%information gain
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ig'])            
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ig(1,i).term);
            end
        elseif (feature_selection_method==4)%chi 2
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_chi2'])            
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_chi2(1,i).term);                
            end
        elseif (feature_selection_method==5)%amguity tf
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_am_tf'])                        
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_am_tf(1,i).term);                
            end
        elseif (feature_selection_method==6)%phd novel metric formula 2
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_phdnm_f2'])                                    
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_phdnm_f2(1,i).term);                
            end 
        elseif (feature_selection_method==7)%DFS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfs'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dfs(1,i).term);                
            end     
        elseif (feature_selection_method==8)%document frequency
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_df'])                                                            
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_df(1,i).term);                
            end 
        elseif (feature_selection_method==9)%gini index original formula
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gi_original'])                                                                        
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gi_original(1,i).term);                
            end
         elseif (feature_selection_method==10)%information gain original formula
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ig_original'])                                                                                     
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ig_original(1,i).term);                
            end
         elseif (feature_selection_method==11)%chi2 average formula
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_chi2_original'])                                                                                                  
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_chi2_original(1,i).term);                
            end
         elseif (feature_selection_method==12)%poisson distribution
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_poisson'])                                                                                                               
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_poisson(1,i).term);                
            end
         elseif (feature_selection_method==13)%probability based weighting scores
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pbweighting'])                                                                                                                       
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_pbweighting(1,i).term);                
            end            
         elseif (feature_selection_method==14)%TF-RF weighting scores
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_tfrf'])                                                                                                                                    
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_tfrf(1,i).term);                
            end               
         elseif (feature_selection_method==15)%LOG TF-RF weighting scores
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_tfrf'])                                                                                                                                                 
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_tfrf(1,i).term);                
            end
         elseif (feature_selection_method==17)%PFS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pfs'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_pfs(1,i).term);                
            end     
        elseif (feature_selection_method==18)%DFSS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfss'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dfss(1,i).term);                
            end   
         elseif (feature_selection_method==19)%NDM
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ndm'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ndm(1,i).term);                
            end
         elseif (feature_selection_method==20)%MDFS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mdfs'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mdfs(1,i).term);                
            end
         elseif (feature_selection_method==21)%CDM
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cdm'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cdm(1,i).term);                
            end
          elseif (feature_selection_method==22)%DPM
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dpm'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dpm(1,i).term);                
            end
          elseif (feature_selection_method==23)%CMFS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cmfs'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cmfs(1,i).term);                
            end
          elseif (feature_selection_method==24)%MMR
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mmr'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mmr(1,i).term);                
            end 
           elseif (feature_selection_method==25)%EFS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_efs'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_efs(1,i).term);                
            end   
            elseif (feature_selection_method==26)%CICI
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cici'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cici(1,i).term);                
            end 
            elseif (feature_selection_method==27)%PMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pmh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_pmh(1,i).term);                
            end
            elseif (feature_selection_method==28)%GSS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gss'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gss(1,i).term);                
            end   
            elseif (feature_selection_method==29)%GSSS
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gsss'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gsss(1,i).term);                
            end
            
            
            elseif (feature_selection_method==30)%XH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_xh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_xh(1,i).term);                
            end   
            elseif (feature_selection_method==31)%DFSHMDFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfshmdfsh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dfshmdfsh(1,i).term);                
            end 
            elseif (feature_selection_method==32)%EFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_efsh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_efsh(1,i).term);                
            end   
            elseif (feature_selection_method==33)%SORH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_sorh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_sorh(1,i).term);                
            end 
            % MIH 34
% CCH 35
% IGH 36
% PFSH 37
            elseif (feature_selection_method==34)%MIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mih'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mih(1,i).term);                
            end   
            elseif (feature_selection_method==35)%CCH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cch'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cch(1,i).term);                
            end 
            elseif (feature_selection_method==36)%IGH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_igh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_igh(1,i).term);                
            end   
            elseif (feature_selection_method==37)%PFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pfsh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_pfsh(1,i).term);                
            end 
            % GINITH 38
% GINIH 39
% DFSSH 40
% NDMH 41
            elseif (feature_selection_method==38)%GINITH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ginith'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ginith(1,i).term);                
            end   
            elseif (feature_selection_method==39)%GINIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ginih'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ginih(1,i).term);                
            end 
            elseif (feature_selection_method==40)%DFSSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfssh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dfssh(1,i).term);                
            end   
            elseif (feature_selection_method==41)%NDMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ndmh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ndmh(1,i).term);                
            end 
            % CDMH 42
% DPMH 43
% CMFSH 44
% MMRH 45
            elseif (feature_selection_method==42)%CDMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cdmh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cdmh(1,i).term);                
            end   
            elseif (feature_selection_method==43)%DPMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dpmh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dpmh(1,i).term);                
            end 
            elseif (feature_selection_method==44)%CMFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cmfsh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cmfsh(1,i).term);                
            end   
            elseif (feature_selection_method==45)%MMRH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mmrh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mmrh(1,i).term);                
            end 
            % CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49
            elseif (feature_selection_method==46)%CRFH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_crfh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_crfh(1,i).term);                
            end   
            elseif (feature_selection_method==47)%POISSONH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_poissonh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_poissonh(1,i).term);                
            end 
            elseif (feature_selection_method==48)%CICIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cicih'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_cicih(1,i).term);                
            end   
            elseif (feature_selection_method==49)%GSSHGSSSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gsshgsssh'])                                                
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gsshgsssh(1,i).term);                
            end 
            
        end
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');        
    eval(['save ', strcat(destination_fpath,'term_feature.mat'), '  term_feature'])
else
    eval(['load ', strcat(destination_fpath,'term_feature.mat'), '  term_feature'])
end


%global
term_feature_map = containers.Map();

for i=1:length(term_feature)
    term_feature_map(char(term_feature(1,i)))=i;
end




% Initializations
topic_cnt = 0;


if (dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL || dataset_type == DATASET_REUTERS_TOP15 || dataset_type == DATASET_REUTERS_TOP20)
    %DATASET_REUTERS
    if dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn'};
    %for top8
    %dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship'};
    %for dfss
    %dataset_topics = {'earn', 'acq', 'crude','money-fx', 'trade', 'grain', 'ship',  'sugar','interest','coffee'};
    %major-minor top 8
    %dataset_topics = {'earn', 'ship'};
    %major-minor top 10
    %dataset_topics = {'earn', 'corn'};
    %major-minor top 15
    %dataset_topics = {'earn', 'nat-gas'};
    %major-minor pfs makale test
    %dataset_topics = {'ship', 'acq'};
    end
    if dataset_type == DATASET_REUTERS_TOP15
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn', 'dlr', 'oilseed', 'money-supply', 'sugar', 'gnp'};
       %major-minor
    %dataset_topics = {'earn', 'gnp'};
    end
    if dataset_type == DATASET_REUTERS_TOP20
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn', 'dlr', 'oilseed', 'money-supply', 'sugar', 'gnp', 'coffee', 'veg-oil', 'gold', 'nat-gas', 'soybean'};
    %major-minor
    %dataset_topics = {'earn', 'nat-gas'};
    end
    
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
   % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter','a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    if (dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_TOP15 || dataset_type == DATASET_REUTERS_TOP20)
        filecount=22;
    else
        filecount=6;
    end
    for cnt=1:filecount
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        if (dataset_type==DATASET_REUTERS || dataset_type == DATASET_REUTERS_TOP15 || dataset_type == DATASET_REUTERS_TOP20)
            fpath=['C:\DATASETS\TEXT\ENGLISH\REUTERS-21578\reut2-' file_name '.sgm'];
        else
            fpath=['C:\datasets\text\experimentaldata\mullass\reuters-21578-partial-1\reut2-' file_name '.sgm'];
        end
        fid = fopen(fpath, 'r');
        
        % Initial state
        op_state = 1;
        
        while 1
            curr_line = fgets(fid);
            
            % If EOF is encountered, finish process
            if curr_line < 0
                break
            end
            
            % -----------------------------------------------------------------
            % Find ModApte split
            % -----------------------------------------------------------------
            switch (op_state)
                case 1

                    % If file header is encountered for ModApte split, proceed to next state
                    if train_set == 1
                        res = strfind(curr_line, '<REUTERS TOPICS="YES" LEWISSPLIT="TRAIN"');
                    elseif train_set == 2
                        res = strfind(curr_line, '<REUTERS TOPICS="YES" LEWISSPLIT="TEST"');
                    end
                    
                    if ~isempty(res)
                        op_state = 2;
                    end
                    
                case 2
                    
                    % If topic header is encountered, find topic type.
                    res = strfind(curr_line, '<TOPICS>');
                    
                    if ~isempty(res)
                        
                        % Set next operation state
                        op_state = 1;
                        
                        % Initially no topic is found
                        topic_found = 0;
                        
                        % Get topic line
                        topic_line = curr_line;
                        
                        % -----------------------------------------------------------------
                        % If current topic is in the dataset, start feature extraction
                        % -----------------------------------------------------------------
                        for topic_idx=1:length(dataset_topics)
                            
                            curr_topic = ['<D>' char(dataset_topics(topic_idx)) '</D>'];
                           
                            
                            
                            if ~isempty(strfind(topic_line, curr_topic))
                                
                                % Set current class
                                curr_class = topic_idx;
                                
                                % Display topic count for tracking
                                topic_cnt = topic_cnt + 1;
                                if (mod(topic_cnt, 10) == 0)
                                    disp(topic_cnt);
                                end
                                
                                % Extract text if it is not done previously
                                if topic_found == 0
                                    
                                    % Topic is found
                                    topic_found = 1;
                                    
                                    % Look for header to find start of the text
                                    while 1
                                        tmp_line = fgets(fid);
                                        res = strfind(tmp_line, '<TEXT');
                                        if ~isempty(res)
                                            break;
                                        end
                                    end
                                    
                                    % Extract text until BODY footer is found
                                    curr_text = tmp_line;
                                    
                                    while 1
                                        tmp_line = fgets(fid);
                                        curr_text = [curr_text tmp_line];
                                        
                                        res = strfind(tmp_line, '</TEXT>');
                                        
                                        if ~isempty(res)
                                            % Remove header and footer from the text
                                            idx1 = strfind(curr_text, '<TEXT');
                                            idx2 = strfind(curr_text, '</TEXT>');
                                            curr_text = curr_text(idx1+6:idx2);
                                            break;
                                        end
                                    end
                                    %destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\<D>',curr_topic,'<\D>\');
                                    %eval(['save ', strcat(destination_fpath,'curr_text1.txt'), '  curr_text'])
                                    %PathName=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\',dataset_topics(curr_class),'\');
%                                     if train_set == 1
%                                         result_fpath=strcat('C:\datasets\text\english\',resfoldername,'\',dataset_topics(curr_class),'\train_',num2str(size(train_matrix,1)+1),'.txt');
%                                     elseif train_set == 2
%                                         result_fpath=strcat('C:\datasets\text\english\',resfoldername,'\',dataset_topics(curr_class),'\test_',num2str(size(test_matrix,1)+1),'.txt');
%                                     end
%                                     
%                                     fresid = fopen(result_fpath{1}, 'w');
%                                     fprintf(fresid,'%s',curr_text);
%                                     fclose(fresid);
%                                 end      
                               
                                    
%         %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%         % Find number of files in directory of current class
%         dir_data_train = dir(fullfile(class_path,'train*.txt'));
%         dir_data_test = dir(fullfile(class_path,'test*.txt'));
%         %num_files = length(dir_data) - 2;
%         
%         num_files_train = length(dir_data_train) - 2;
%         num_files_test = length(dir_data_test) - 2;
%                                 
                                end
        
        
                                % -----------------------------------------------------------------
                                % Process current text
                                % -----------------------------------------------------------------
                                
                                
                                result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
                                if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                                        train_matrix=[train_matrix;result];
                                        topic_matrix=[topic_matrix;curr_class];                                                             
                                else%prepare test matrix within test documents
                                        test_matrix=[test_matrix;result];
                                        topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                                end
                                
                                
                            end
                        
                        end
                     
                    end
            end
        end
        
        % Close file
        fclose(fid);
        for topic_idx=1:length(dataset_topics)
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)== topic_idx)];%dogru calismiyor
        end
    end
elseif dataset_type == DATASET_REUTERS_FOLDERS %DATASET DIVIDED INTO FOLDERS TRAIN TEST 
    dataset_topics = {'acq', 'earn', 'grain','money-fx'};

 topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
   % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter','a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
 
 for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path_train = ['C:\datasets\text\english\reuters_21578_10topicfolders\', char(dataset_topics(curr_class)),'\train'];
		class_path_test = ['C:\datasets\text\english\reuters_21578_10topicfolders\', char(dataset_topics(curr_class)),'\test'];
        dir_data_train = dir(class_path_train);
        disp(char(dataset_topics(curr_class)));
		dir_data_test = dir(class_path_test);

        % Find number of files in directory of current class
        num_files_train = length(dir_data_train) - 2;
		num_files_test = length(dir_data_test) - 2;
        
        %for all topics
        
        
        if curr_class == 1 
            if train_set == 1
				start_idx_train = 1;
				stop_idx_train = 716;
		    elseif train_set == 2
                start_idx_test = 1;
				stop_idx_test = num_files_test;
            end
        elseif curr_class == 2 
            if train_set == 1
				start_idx_train = 1;
				stop_idx_train = 1000;
		    elseif train_set == 2
				start_idx_test = 1;
				stop_idx_test = 1000;
            end
        elseif curr_class == 3 
            if train_set == 1
				start_idx_train = 1;
				stop_idx_train = 100;
		    elseif train_set == 2
				start_idx_test = 1;
				stop_idx_test = 100;
            end
		elseif curr_class == 4
            if train_set == 1
				start_idx_train = 1;
				stop_idx_train = 178;
			elseif train_set == 2
				start_idx_test = 1;
				stop_idx_test = num_files_test;
            end
        end
 


			if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
				for idx=start_idx_train:stop_idx_train
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 100) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path_train '\' dir_data_train(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];

					while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end
				    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end                                                  
                end    
			else%prepare test matrix within test documents
                for idx=start_idx_test:stop_idx_test          
				  % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 100) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path_test '\' dir_data_test(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];

					while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end
						   
				    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end                                    
                 end
           	
            
					test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
         end
           
 end
 elseif dataset_type == DATASET_REUTERS_FOLDERS_ALL %DATASET DIVIDED INTO FOLDERS TRAIN TEST TOGETHER
    
     dataset_topics = {'acq', 'coffee', 'crude', 'earn', 'grain','interest','money-fx', 'ship', 'sugar', 'trade'};

 topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
   % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter','a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
 
 for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\reuters_21578_10topicfolders_all\', char(dataset_topics(curr_class))];
		
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));
		
        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
		
        
        %for all topics
        

            
            if curr_class == 1
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 145;
                elseif train_set == 2
                    start_idx = 146;
                    stop_idx = 290;
                end
            elseif curr_class == 2
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 60;
                elseif train_set == 2
                    start_idx = 61;
                    stop_idx = num_files;
                end
            elseif curr_class == 3
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 130;
                elseif train_set == 2
                    start_idx = 131;
                    stop_idx = 260;
                end
            elseif curr_class == 4
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 150;
                elseif train_set == 2
                    start_idx = 151;
                    stop_idx = 300;
                end
            elseif curr_class == 5
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 135;
                elseif train_set == 2
                    start_idx = 136;
                    stop_idx = 270;
                end
            elseif curr_class == 6
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 145;
                elseif train_set == 2
                    start_idx = 146;
                    stop_idx = num_files;
                end
            elseif curr_class == 7
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 140;
                elseif train_set == 2
                    start_idx = 141;
                    stop_idx = 280;
                end
            elseif curr_class == 8
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 83;
                elseif train_set == 2
                    start_idx = 84;
                    stop_idx = num_files;
                end
            elseif curr_class == 9
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 64;
                elseif train_set == 2
                    start_idx = 65;
                    stop_idx = num_files;
                end
            elseif curr_class == 10
                if train_set == 1
                    start_idx = 1;
                    stop_idx = 125;
                elseif train_set == 2
                    start_idx = 126;
                    stop_idx = 250;
                end
            end

 


			 % Start processing files
         for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 100) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
           curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
            end
         
                    
                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                
         end 
  
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
 end      
        
elseif (dataset_type == DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION) %MEDLINETR ENGLISH ABSTRACTS DATASET
    
    %12 categories (v5.1)
    dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08','C09', 'C10', 'C14', 'C23'};
    
    topic_matrix=[];
    train_matrix=[];
       
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %turkish stopwords    
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\medlinetr_engabstract\all_docs_v5_1_turkish\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
                

        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;

        
        
        
        %pat = '<[^>]*>';
        
        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end

            

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

                   % Init current text
                   curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end
                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end 
            end
        
        end
    end




                    
    


                
               

    elseif dataset_type == DATASET_MININEWS20 %MINI NEWS20 DATASET

    % Original list 20 category
    dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.polis.guns', 'talk.polis.mideast', 'talk.polis.misc', 'talk.religion.misc'};      
    
    
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\mini_news20\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
                

        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        
        %pat = '<[^>]*>';
        
        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end
          

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

                   % Init current text
                   curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       
    end   

    %% CAT DOG DATASET %%
    
elseif dataset_type == DATASET_CATDOG %MINI CATDOG DATASET

    % Original list 3 category
    dataset_topics = {'C1', 'C2', 'C3'};      
    
    
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\experimentaldata\catdogfish2\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
                
        %train_set_ratio = 1.0;
        train_set_ratio = 0.7;
       
        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;
        

        
        %pat = '<[^>]*>';
        
        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end
          

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

                   % Init current text
                   curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
    end   

    
    

elseif dataset_type == DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION %MEDLINETR ENGLISH ABSTRACTS DATASET
    
    %12 categories (v5.1)
    dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08','C09', 'C10', 'C14', 'C23'};
    
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\medlinetr_engabstract\all_docs_v5_1_english\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        

            start_idx=floor(0.7*num_files)+1;
            stop_idx=num_files;
        

        
        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];
 


                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end

            

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

                   % Init current text
                   curr_text = [];
 


                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end



                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       
    end     
    
    
    
elseif dataset_type == DATASET_OHSUMED_SINGLELABEL_VERSION %OHSUMED DATASET
    

       
    %dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18','C19', 'C20', 'C21', 'C22', 'C23'};
    %dataset_topics = {'C05', 'C08', 'C14', 'C15'};vers1
    %dataset_topics = {'C12', 'C16', 'C19', 'C22'};vers2
    %dataset_topics = {'C01', 'C04', 'C05', 'C23'};%vers3
    %dataset_topics = {'C04', 'C07'};%top10
    dataset_topics = {'C14', 'C22'};% m-m original
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    test_class_count = [];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\ohsumed\all-docs-singlelabel\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

       % Find number of files in directory of current class
        
        
        num_files = length(dir_data) - 2;
         
%         start_idx=floor(0.7*num_files)+1;
%         stop_idx=num_files;
  %for all topics
        % vers3 ------------------
%         if curr_class == 1 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 315;
%             elseif train_set == 2
%             start_idx = 316;
%             stop_idx = num_files;
%             end
%         elseif curr_class == 2 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 1256;
%             elseif train_set == 2
%             start_idx = 1257;
%             stop_idx = num_files;
%             end
%         elseif curr_class == 3
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 251;
%             elseif train_set == 2
%             start_idx = 252;
%             stop_idx = 502;
%             end
%         elseif curr_class == 4
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 962;
%             elseif train_set == 2
%             start_idx = 963;
%             stop_idx = num_files;
%             end
%         end
      
if curr_class == 1 
            if train_set == 1
            start_idx = 1;
            stop_idx = 2013;
            elseif train_set == 2
            start_idx = 2014;
            stop_idx = num_files;
            end
        elseif curr_class == 2 
            if train_set == 1
            start_idx = 1;
            stop_idx = 39;
            elseif train_set == 2
            start_idx = 40;
            stop_idx = num_files;
            end
end    
%         elseif curr_class == 3
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%            start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 4
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 65;
%             elseif train_set == 2
%             start_idx = 66;
%             stop_idx = 130;
%             end
%         elseif curr_class == 5 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 60;
%             elseif train_set == 2
%             start_idx = 61;
%             stop_idx = 120;
%             end
%         elseif curr_class == 6
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 60;
%             elseif train_set == 2
%             start_idx = 61;
%             stop_idx = 120;
%             end
%         elseif curr_class == 7
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 66;
%             elseif train_set == 2
%             start_idx = 67;
%             stop_idx = num_files;
%             end 
%         elseif curr_class == 8
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 60;
%             elseif train_set == 2
%             start_idx = 61;
%             stop_idx = 120;
%             end
%         elseif curr_class == 9
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%             start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 10
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 65;
%             elseif train_set == 2
%             start_idx = 66;
%             stop_idx = 130;
%             end
%         elseif curr_class == 11 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%             start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 12
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 60;
%             elseif train_set == 2
%             start_idx = 61;
%             stop_idx = 120;
%             end
%         elseif curr_class == 13
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 55;
%             elseif train_set == 2
%             start_idx = 56;
%             stop_idx = 110;
%             end
%         elseif curr_class == 14
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 70;
%             elseif train_set == 2
%             start_idx = 71;
%             stop_idx = 140;
%             end
%         elseif curr_class == 15 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%             start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 16
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%             start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 17
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 55;
%             elseif train_set == 2
%             start_idx = 56;
%             stop_idx = 110;
%             end 
%         elseif curr_class == 18
%            if train_set == 1
%             start_idx = 1;
%             stop_idx = 60;
%             elseif train_set == 2
%             start_idx = 61;
%             stop_idx = 120;
%             end
%         elseif curr_class == 19
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%             elseif train_set == 2
%             start_idx = 51;
%             stop_idx = 100;
%             end
%         elseif curr_class == 20
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 65;
%             elseif train_set == 2
%             start_idx = 66;
%             stop_idx = 130;
%             end
%         elseif curr_class == 21 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 65;
%             elseif train_set == 2
%             start_idx = 66;
%             stop_idx = 130;
%             end
%         elseif curr_class == 22
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 28;
%             elseif train_set == 2
%             start_idx = 29;
%             stop_idx = num_files;
%             end
%         elseif curr_class == 23
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 65;
%             elseif train_set == 2
%             start_idx = 66;
%             stop_idx = 130;
%             end    
%         end  


 
       
        % Start processing files
         for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 100) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
           curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
            end

                    

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
    end    


        
%         %pat = '<[^>]*>';
%         
%         
%         % Start processing files
%         for idx=1:num_files
%             if train_set==1
%                 if (idx<start_idx || idx >stop_idx)
%                     % Display topic count for tracking
%                     topic_cnt = topic_cnt + 1;
%                     if (mod(topic_cnt, 1000) == 0)
%                         disp(topic_cnt);
%                     end
% 
%                     % Open current file
%                     file_path = [class_path '\' dir_data(idx + 2).name];
%                     curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
%                     % Init current text
%                     curr_text = [];
%   
% 
% 
%                     while 1
%                         curr_line = fgets(curr_fid);
% 
%                         % If EOF is encountered, finish process and close file
%                         if curr_line < 0
%                             fclose(curr_fid);
%                             break;
%                         end
%                         % curr_line
%                         % Add current line to curr_text
%                         curr_text = [curr_text curr_line];
% 
%                     end
% 
%             
% 
%                     % -----------------------------------------------------------------
%                     % Process current text
%                     % -----------------------------------------------------------------
%                     % curr_line
%                     result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
%     
%                     if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
%                            train_matrix=[train_matrix;result];
%                            topic_matrix=[topic_matrix;curr_class];                                                             
%                     else%prepare test matrix within test documents
%                            test_matrix=[test_matrix;result];
%                            topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
%                     end
%                 end
%             else
%                 if (idx>=start_idx && idx <=stop_idx)
%                     % Display topic count for tracking
%                     topic_cnt = topic_cnt + 1;
%                     if (mod(topic_cnt, 1000) == 0)
%                         disp(topic_cnt);
%                     end
% 
%                     % Open current file
%                     file_path = [class_path '\' dir_data(idx + 2).name];
%                     curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
% 
%                    % Init current text
%                    curr_text = [];
%  
% 
% 
%                     while 1
%                         curr_line = fgets(curr_fid);
% 
%                         % If EOF is encountered, finish process and close file
%                         if curr_line < 0
%                             fclose(curr_fid);
%                             break;
%                         end
%                         % curr_line
%                         % Add current line to curr_text
%                         curr_text = [curr_text curr_line];
% 
%                     end
% 
% 
% 
%                     % -----------------------------------------------------------------
%                     % Process current text
%                     % -----------------------------------------------------------------
%                     % curr_line
%                     result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
% 
%                     if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
%                            train_matrix=[train_matrix;result];
%                            topic_matrix=[topic_matrix;curr_class];                                                             
%                     else%prepare test matrix within test documents
%                            test_matrix=[test_matrix;result];
%                            topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
%                     end
%                 end
%                 
%                 
%                 
%                 
%             end
%          
%          
%             
%         end
%         
%        
%     end     
%     
    
elseif dataset_type == DATASET_CLASSIC3 %CLASSIC3 DATASET   
       
     %dataset_topics = {'cisi', 'cran', 'med'}; 
     dataset_topics = {'cisi', 'med'}; 
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\classic3_full\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
                
                
%         start_idx=floor(0.7*num_files)+1;
%         stop_idx=num_files;


%for all topics
        
        
        if curr_class == 1 
            if train_set == 1
            start_idx = 1;
            stop_idx = 1022;
            elseif train_set == 2
            start_idx = 1023;
            stop_idx = num_files;
            end
        elseif curr_class == 2 
            if train_set == 1
            start_idx = 1;
            stop_idx = 723;
            elseif train_set == 2
            start_idx = 724;
            stop_idx = num_files;
            end
%        elseif curr_class == 3
%             if train_set == 1 
%             start_idx = 1;
%             stop_idx = 516;
%             elseif train_set == 2
%             start_idx = 517;
%             stop_idx = num_files;
%             end
        end
        
        %pat = '<[^>]*>';
        
        
        % Start processing files
%         for idx=1:num_files
%             if train_set==1
%                 if (idx<start_idx || idx >stop_idx)
%                     
                    
                 for idx=start_idx:stop_idx
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];



                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end

            

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
    end  
    
elseif dataset_type == DATASET_ENRON1_PARTIAL %SPAM EMAIL ENGLISH
    

       
    dataset_topics = {'spam', 'legitimate'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\spamemail\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
                
                

        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;


        
        pat = '<[^>]*>';
        
        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
                    % Init current text
                    curr_text = [];

                    %remove header of email
                    strlen=-1;
                    while strlen~=0
                        tmp_line = fgets(curr_fid);
                        tmp_line = strtrim(tmp_line);
                        strlen=length(tmp_line);                
                    end    


                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end

                    curr_text=regexprep(curr_text, pat, '');
            

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

                   % Init current text
                   curr_text = [];

                    %remove header of email
                   strlen=-1;
                   while strlen~=0
                        tmp_line = fgets(curr_fid);
                        tmp_line = strtrim(tmp_line);
                        strlen=length(tmp_line);                
                   end    


                    while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end
                        % curr_line
                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                    end

                    curr_text=regexprep(curr_text, pat, ''); 


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       
    end 
    
elseif dataset_type == DATASET_SPAMSMSTR %SPAM SMS TURKISH
    

       
    dataset_topics = {'spam', 'legitimate'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %turkish stopwords
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\spamsms\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;

        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');


                    fgets(curr_fid);
                    curr_line = fgets(curr_fid);
                    curr_text = [curr_line];
                    fclose(curr_fid);    


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');


                    fgets(curr_fid);
                    curr_line = fgets(curr_fid);
                    curr_text = [curr_line];
                    fclose(curr_fid);    


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       
    end
    

elseif dataset_type == DATASET_SPAMEMAILTR %SPAM EMAIL TURKISH
    

       
    dataset_topics = {'spam', 'legitimate'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %turkish stopwords
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\spamemail\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
                

            start_idx=floor(num_files*.07)+1;
            stop_idx=num_files;
	

        
        % Start processing files
        for idx=1:num_files
            if train_set==1
                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');


                    % Init current text
                   curr_text = [];

                   % disregard from and to part of emails
                   fgets(curr_fid);
                   fgets(curr_fid);

                   while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end

                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                   end   
                    
       


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            else
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end

                    % Open current file
                    file_path = [class_path '\' dir_data(idx + 2).name];
                    curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');


                   % Init current text
                   curr_text = [];

                   % disregard from and to part of emails
                   fgets(curr_fid);
                   fgets(curr_fid);

                   while 1
                        curr_line = fgets(curr_fid);

                        % If EOF is encountered, finish process and close file
                        if curr_line < 0
                            fclose(curr_fid);
                            break;
                        end

                        % Add current line to curr_text
                        curr_text = [curr_text curr_line];

                   end   


                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
                
                
                
                
            end
         
         
            
        end
        
       
    end    
    
    
elseif dataset_type == DATASET_BRITISHENGLISHSPAMSMS %SPAM SMS ENGLISH
   
    
    dataset_topics = {'spam', 'legitimate'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

 for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\spamsms\britishenglishdata\' char(dataset_topics(curr_class)) '.txt'];      
        
        curr_fid = fopen(class_path, 'r', 'n', 'UTF-8');
        file = textscan(curr_fid, '%s', 'delimiter', '\n','whitespace', '');
        fclose(curr_fid);
        lines = file{1};
        num_files=length(lines);
        
        
                
        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;

        
        
        
        curr_fid = fopen(class_path, 'r', 'n', 'UTF-8');
        idx=1;
        while 1
                curr_line = fgets(curr_fid);

                if curr_line<0
                    fclose(curr_fid);
                    break;
                end
               if train_set==1

                if (idx<start_idx || idx >stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end


                    curr_text = curr_line;

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end


                end
                idx=idx+1;
               else%train set is 2
                   
                if (idx>=start_idx && idx <=stop_idx)
                    % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 1000) == 0)
                        disp(topic_cnt);
                    end


                    curr_text = curr_line;

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);

                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end


                end
            idx=idx+1;
                   
                   
                
                   
               end
            
        end
        
        
       
 end    
 
 elseif dataset_type == DATASET_SPAM %4827 legitimate, 747 spam
   
    
    dataset_topics = {'legitimate', 'spam'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\spamsms\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
         train_set_ratio = 0.7;
        
        % Define start/stop index
        
%         if curr_class == 1 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 522;
%             elseif train_set == 2
%             start_idx = 523;
%             stop_idx = num_files;
%             end
%         elseif curr_class == 2 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 3132;
%             elseif train_set == 2
%             start_idx = 3133;
%             stop_idx = 4482;
%             end
%         end
        
         if (train_set==1)
            start_idx = 1;          
            stop_idx = floor(num_files*train_set_ratio);           
         else
            start_idx = floor(num_files*train_set_ratio) + 1;          
            stop_idx = num_files;  
         end
        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 1000) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');
          
            
            curr_text='';
            while 1
                curr_line = fgets(curr_fid);
            
                % If EOF is encountered, finish process
                if curr_line < 0
                    break
                end
            
                curr_text = [curr_text curr_line];
            end
                        
            fclose(curr_fid);
            
            result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end
            
        end
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
        
    end        
                                
    
elseif dataset_type == DATASET_WEBKB %WEBKB 4 UNIVERSITY DATASET
    

       
    %dataset_topics = {'course', 'faculty', 'project', 'student'}; 
    dataset_topics = {'project', 'student'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
    test_class_count=[];
    
    %english stopwords    
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
      
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\webkb_4category\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);
        disp(char(dataset_topics(curr_class)));

        % Find number of files in directory of current classcatdog
        num_files = length(dir_data) - 2;
        
        
          
                
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFAULT VERSION  %%%%%%%%%%%%%%%%%%%%%       
        %train_set_ratio = 0.7;
        
        %start_idx=floor(train_set_ratio*num_files)+1;
        %stop_idx=num_files;       
                
          
%         % Define start/stop index
%         start_idx=(currentpart-1)*(num_files/crossvaltotal)+1;
%         stop_idx=start_idx+(num_files/crossvaltotal)-1;
%         start_idx=floor(start_idx);
%         stop_idx=floor(stop_idx);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

         %for all topics
        
        if curr_class == 1 
            if train_set == 1
            start_idx = 1;
            stop_idx = 150;
            elseif train_set == 2
            start_idx = 151;
            stop_idx = 300;
            end
        elseif curr_class == 2 
            if train_set == 1
            start_idx = 1;
            stop_idx = 100;
            elseif train_set == 2
            start_idx = 101;
            stop_idx = 200;
            end
        elseif curr_class == 3
            if train_set == 1
            start_idx = 1;
            stop_idx = 82;
            elseif train_set == 2
            start_idx = 83;
            stop_idx = 164;
            end
        elseif curr_class == 4
            if train_set == 1
            start_idx = 1;
            stop_idx = 820;
            elseif train_set == 2
            start_idx = 821;
            stop_idx = num_files;
            end
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFAULT VERSION  %%%%%%%%%%%%%%%%%%%%%        pat = '<[^>]*>';
        
        % Start processing files
%         for idx=start_idx:stop_idx
% 
%             % Display topic count for tracking
%             topic_cnt = topic_cnt + 1;
%             if (mod(topic_cnt, 100) == 0)
%                 disp(topic_cnt);
%             end

 %       pat = '<[^>]*>';
       
        % Start processing files
%         for idx=1:num_files
%             if train_set==1
%                 if (idx<start_idx || idx >stop_idx)
%                     % Display topic count for tracking
%                     topic_cnt = topic_cnt + 1;
%                     if (mod(topic_cnt, 100) == 0)
%                         disp(topic_cnt);
%                     end
                    
 


%                     % Open current file
%                     file_path = [class_path '\' dir_data(idx + 2).name];
%                     curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
%                     % Init current text
%                     curr_text = [];
% 
% %                     %remove header of email
% %                     strlen=-1;
% %                     while strlen~=0
% %                         tmp_line = fgets(curr_fid);
% %                         tmp_line = strtrim(tmp_line);
% %                         strlen=length(tmp_line);                
% %                     end    
% 
% 
%                     while 1
%                         curr_line = fgets(curr_fid);
% 
%                         % If EOF is encountered, finish process and close file
%                         if curr_line < 0
%                             fclose(curr_fid);
%                             break;
%                         end
%                         % curr_line
%                         % Add current line to curr_text
%                         curr_text = [curr_text curr_line];
% 
%                     end
% 
%                     %strip all html tags
%                     curr_text=regexprep(curr_text, pat, '');
%                     
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
                      
 pat = '<[^>]*>';
 % Start processing files
         for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 100) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
           curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
            end

                    %strip all html tags
                    curr_text=regexprep(curr_text, pat, '');
            

                    % -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, term_feature);
    
                    if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                           train_matrix=[train_matrix;result];
                           topic_matrix=[topic_matrix;curr_class];                                                             
                    else%prepare test matrix within test documents
                           test_matrix=[test_matrix;result];
                           topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                    end
                end
            
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)==curr_class)];
    end    
    
elseif dataset_type == DATASET_ENRON1
    
    
    dataset_topics = {'spam', 'ham'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\enron1\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        train_set_ratio = 0.7;
        
        % Define start/stop index
        
         if (train_set==1)
            start_idx = 1;          
            stop_idx = floor(num_files*train_set_ratio);           
         else
            start_idx = floor(num_files*train_set_ratio) + 1;          
            stop_idx = num_files;  
         end
        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 1000) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');
          
            
            curr_text='';
            while 1
                curr_line = fgets(curr_fid);
            
                % If EOF is encountered, finish process
                if curr_line < 0
                    break
                end
            
                curr_text = [curr_text curr_line];
            end
                        
            fclose(curr_fid);
            
            result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end
            
        end
        
    end        
                                
    
elseif (dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS20 || dataset_type == DATASET_NEWS3)
    
    if dataset_type == DATASET_NEWS3
        dataset_topics = {'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x'};
    elseif dataset_type == DATASET_NEWS10
        %dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball'};
         %minor-major  
        dataset_topics = {'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware'};   
    
    elseif dataset_type == DATASET_NEWS20
        %dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.politics.guns', 'talk.politics.mideast', 'talk.politics.misc', 'talk.religion.misc'};
        
        %minor-major
        dataset_topics = {'talk.politics.guns','talk.politics.mideast'};
    end
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    test_class_count =[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\DATASETS\TEXT\ENGLISH\NEWS20\ORG\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        %for minor-major (2 dataset_topic)
        if curr_class == 1 
            if train_set == 1
            start_idx = 1;
            stop_idx = 150;
            elseif train_set == 2
            start_idx = 151;
            stop_idx = num_files-700;
            end
            elseif curr_class == 2
            if train_set == 1
            start_idx = 1;
            stop_idx = 500;
            elseif train_set == 2
            start_idx = 501;
            stop_idx = num_files;
            end
        end
        
        %for all topics
        
%         if curr_class == 1 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%         elseif train_set == 2
%             start_idx = 51;
%             stop_idx = num_files-900;
%             end
%         elseif curr_class == 2 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 100;
%         elseif train_set == 2
%             start_idx = 101;
%             stop_idx = num_files-800;
%             end
%         elseif curr_class == 3
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 150;
%         elseif train_set == 2
%             start_idx = 151;
%             stop_idx = num_files-700;
%             end
%         elseif curr_class == 4
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 200;
%         elseif train_set == 2
%             start_idx = 201;
%             stop_idx = num_files-600;
%             end
%         elseif curr_class == 5
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 250;
%         elseif train_set == 2
%             start_idx = 251;
%             stop_idx = num_files-500;
%             end
%         elseif curr_class >5


        % Define start/stop index-balanced
%         if train_set == 1
%             start_idx = 1;
%             stop_idx = 500;
%         elseif train_set == 2
%             start_idx = 501;
%             stop_idx = num_files;
%         end
%         

%         if curr_class == 1 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 90;
%         elseif train_set == 2
%             start_idx = 91;
%             stop_idx = num_files-820;
%             end
%         elseif curr_class == 2 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 100;
%         elseif train_set == 2
%             start_idx = 101;
%             stop_idx = num_files-800;
%             end
%         elseif curr_class == 3
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 150;
%         elseif train_set == 2
%             start_idx = 151;
%             stop_idx = num_files-700;
%             end
%         elseif curr_class == 4
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 200;
%         elseif train_set == 2
%             start_idx = 201;
%             stop_idx = num_files-600;
%             end
%         elseif curr_class == 5
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 250;
%         elseif train_set == 2
%             start_idx = 251;
%             stop_idx = num_files-500;
%             end
%         elseif curr_class == 6 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 300;
%         elseif train_set == 2
%             start_idx = 301;
%             stop_idx = num_files-400;
%             end
%         elseif curr_class == 7 
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 350;
%         elseif train_set == 2
%             start_idx = 351;
%             stop_idx = num_files-300;
%             end
%         elseif curr_class == 8
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 400;
%         elseif train_set == 2
%             start_idx = 401;
%             stop_idx = num_files-200;
%             end
%         elseif curr_class == 9
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 450;
%         elseif train_set == 2
%             start_idx = 451;
%             stop_idx = num_files-100;
%             end
%         elseif curr_class == 10
% 
%         % Define start/stop index-balanced
%         if train_set == 1
%             start_idx = 1;
%             stop_idx = 500;
%         elseif train_set == 2
%             start_idx = 501;
%             stop_idx = num_files;
%         end
%         end
        
%         if curr_class == 1
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 50;
%         elseif train_set == 2
%             start_idx = 51;
%             stop_idx = num_files-900;
%             end
%         elseif curr_class >1
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 500;
%             elseif train_set == 2
%             start_idx = 501;
%             stop_idx = num_files;
%             end
%         end
        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 1000) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------


            result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class]; 
                    
            end
            
            
        end
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)== curr_class)];
    end
    
    elseif dataset_type == DATASET_NEWS2C
        dataset_topics = {'sci.space', 'alt.atheism'};
        
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    test_class_count =[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\experimentaldata\news2c\org\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        train_set_ratio = 0.7;
        
        % Define start/stop index
        
         if (train_set==1)
            start_idx = 1;          
            stop_idx = floor(num_files*train_set_ratio);           
         else
            start_idx = floor(num_files*train_set_ratio) + 1;          
            stop_idx = num_files;  
         end
        

        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 1000) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------


            result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class]; 
                    
            end
            
            
        end
        test_class_count = [test_class_count, sum(topic_matrix_for_test(:)== curr_class)];
    end
    
        
    elseif dataset_type == DATASET_SPAMSMSENG %SPAM SMS ENGLISH
      
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    

    
        if train_set==1
            file_name='train';
        else
            file_name='test';
        end
        
        fpath=['C:\datasets\text\english\spamsms\spamsms30_70percent\' file_name '.txt'];
        fid = fopen(fpath, 'r');
        
        
        while 1
            curr_line = fgets(fid);
            
            % If EOF is encountered, finish process
            if curr_line < 0
                break
            end
            
            res = strfind(curr_line, 'spam');
            
            if ~isempty(res)
                curr_class=1;
                modifiedStr = strrep(curr_line, 'spam', '');
            else
                curr_class=2;
                modifiedStr = strrep(curr_line, 'ham', '');

            end
            
            curr_text=char(modifiedStr);
            
            result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                   train_matrix=[train_matrix;result];
                   topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                   test_matrix=[test_matrix;result];
                   topic_matrix_for_test=[topic_matrix_for_test;curr_class];
                   
            end
            

        end
        % Close file
        fclose(fid);              
        
end      
   

    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'dataset_topics.mat'), '  dataset_topics'])
    
    train_matrix_without_weighting=train_matrix;
    
    eval(['load ', strcat(destination_fpath,'weighting_index_maps.mat'), '  term_feature_dfs_map term_feature_gi_original_map term_feature_ig_original_map term_feature_chi2_original_map term_feature_poisson_map term_feature_pbweighting_map term_feature_tfrf_map term_feature_tfrr_map term_feature_ig_map term_feature_mi_map term_feature_pfs_map term_feature_dfss_map term_feature_ndm_map term_feature_mdfs_map term_feature_cdm_map term_feature_dpm_map term_feature_cmfs_map term_feature_mmr_map term_feature_efs_map term_feature_cici_map term_feature_pmh_map term_feature_gss_map term_feature_gsss_map term_feature_xh_map term_feature_dfshmdfsh_map term_feature_efsh_map term_feature_sorh_map term_feature_mih_map term_feature_cch_map term_feature_igh_map term_feature_pfsh_map term_feature_ginith_map term_feature_ginih_map term_feature_dfssh_map term_feature_ndmh_map term_feature_cdmh_map term_feature_dpmh_map term_feature_cmfsh_map term_feature_mmrh_map term_feature_crfh_map term_feature_poissonh_map term_feature_cicih_map term_feature_gsshgsssh_map;'])
    
    
    eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])

    if (term_weighting_scheme==0)%BINARY WEIGHTING 
       if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
%                 tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    if (train_matrix(v,h)>0)
                        train_matrix(v,h)=1;
                    else
                        train_matrix(v,h)=0;
                    end
                    train_matrix(v,h)=train_matrix(v,h);
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    if (test_matrix(v,h)>0)
                        test_matrix(v,h)=1;
                    else
                        test_matrix(v,h)=0;
                    end
                    test_matrix(v,h)=test_matrix(v,h);
                end
            end            
       end
    elseif(term_weighting_scheme==1)%TF WEIGHTING (ALREADY TF WEIGHTED)
        disp('TF WEIGHTED');
        %Continue            
    elseif(term_weighting_scheme==2)%TF-IDF WEIGHTING        
        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    train_matrix(v,h)=train_matrix(v,h)*log10(sum(dataset_class_idx)/tempvalue);
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*log10(sum(dataset_class_idx)/tempvalue);
                end
            end            
        end
        
        
        elseif(term_weighting_scheme==3)%TF-IG WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ig'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ig(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ig(1,feature_index).value;
                end
            end            
        end
        
        
        elseif(term_weighting_scheme==4)%TF-MUTUAL INFO WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mi'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mi_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_mi(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mi_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_mi(1,feature_index).value;
                end
            end            
        end        
        
        
        elseif(term_weighting_scheme==7)%TF-DFS WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfs'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dfs(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dfs(1,feature_index).value;
                end
            end            
        end
        
      elseif(term_weighting_scheme==9)%TF-GI WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gi_original'])                    
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gi_original_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_gi_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gi_original_map(char(tempterm));

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_gi_original(1,feature_index).value;
                end
            end            
        end
        
        
      elseif(term_weighting_scheme==10)%TF-IG WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ig_original'])          
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_original_map(char(tempterm));
                
                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ig_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_original_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ig_original(1,feature_index).value;
                end
            end            
        end
        
        
      elseif(term_weighting_scheme==12)%TF-POISSON WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_poisson'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_poisson_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_poisson(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_poisson_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_poisson(1,feature_index).value;
                end
            end            
        end        
        
        
       elseif(term_weighting_scheme==11)%TF-CHI2 WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_chi2_original'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_chi2_original_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_chi2_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_chi2_original_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_chi2_original(1,feature_index).value;
                end
            end            
        end               
        
        
      elseif(term_weighting_scheme==13)%TF-PB based WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pbweighting'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pbweighting_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_pbweighting(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pbweighting_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_pbweighting(1,feature_index).value;
                end
            end            
        end        
        
      elseif(term_weighting_scheme==14)%TF-RF based WEIGHTING
          eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_tfrf'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_tfrf(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_tfrf(1,feature_index).value;
                end
            end            
        end     
        
      elseif(term_weighting_scheme==15)%LOG TF-RF based WEIGHTING
          eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_tfrf'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=log2(1+train_matrix(v,h))*term_feature_tfrf(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=log2(1+test_matrix(v,h))*term_feature_tfrf(1,feature_index).value;
                end
            end            
        end        
        
        
elseif(term_weighting_scheme==16)%LOG TF-RR based WEIGHTING
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_tfrr'])
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrr_map(char(tempterm));
                

                for v=1:lenv
                    if (train_matrix(v,h)>0)
                        train_matrix(v,h)=(log2(train_matrix(v,h)) + 1)*term_feature_tfrr(1,feature_index).value;
                    end
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrr_map(char(tempterm));
                

                for v=1:lenv
                    if (test_matrix(v,h)>0)
                        test_matrix(v,h)=(log2(test_matrix(v,h)) + 1)*term_feature_tfrr(1,feature_index).value;
                    end
                end
            end            
        end         
       elseif(term_weighting_scheme==17)%TF-PFS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pfs'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pfs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_pfs(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pfs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_pfs(1,feature_index).value;
                end
            end            
        end 
        
    
    
    elseif(term_weighting_scheme==18)%TF-DFSS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfss'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfss_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dfss(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfss_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dfss(1,feature_index).value;
                end
            end            
        end 
        elseif(term_weighting_scheme==19)%TF-NDM 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ndm'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ndm_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ndm(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ndm_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ndm(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==20)%TF-MDFS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mdfs'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mdfs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_mdfs(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mdfs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_mdfs(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==21)%TF-CDM 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cdm'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cdm_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cdm(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cdm_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cdm(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==22)%TF-DPM
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dpm'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dpm_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dpm(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dpm_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dpm(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==23)%TF-CMFS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cmfs'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cmfs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cmfs(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cmfs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cmfs(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==24)%TF-MMR 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mmr'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mmr_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_mmr(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mmr_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_mmr(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==25)%TF-EFS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_efs'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_efs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_efs(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_efs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_efs(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==26)%CICI 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cici'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cici_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cici(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cici_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cici(1,feature_index).value;
                end
            end
        end
    elseif(term_weighting_scheme==27)%PMH 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pmh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pmh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_pmh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pmh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_pmh(1,feature_index).value;
                end
            end
        end 
        elseif(term_weighting_scheme==28)%GSS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gss'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gss_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_gss(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gss_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_gss(1,feature_index).value;
                end
            end
        end 
        elseif(term_weighting_scheme==29)%GSSS 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gsss'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gsss_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_gsss(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gsss_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_gsss(1,feature_index).value;
                end
            end
        end
        % term_weighting_scheme=30 (TF-XH)
% term_weighting_scheme=31 (TF-DFSHMDFSH)
% term_weighting_scheme=32 (TF-EFSH)
% term_weighting_scheme=33 (TF-SORH)
% term_weighting_scheme=34 (TF-MIH)
% term_weighting_scheme=35 (TF-CCH) 
% term_weighting_scheme=36 (TF-IGH)
% term_weighting_scheme=37 (TF-PFSH)
% term_weighting_scheme=38 (TF-GINITH)
% term_weighting_scheme=39 (TF-GINIH)
% term_weighting_scheme=40 (TF-DFSSH)
% term_weighting_scheme=41 (TF-NDMH)
% term_weighting_scheme=42 (TF-CDMH)
% term_weighting_scheme=43 (TF-DPMH)
% term_weighting_scheme=44 (TF-CMFSH)
% term_weighting_scheme=45 (TF-MMRH)
% term_weighting_scheme=46 (TF-CRFH)
% term_weighting_scheme=47 (TF-POISSONH)
% term_weighting_scheme=48 (TF-CICIH)
% term_weighting_scheme=49 (TF-GSSHGSSSH)
        elseif(term_weighting_scheme==30)%TF-XH 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_xh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_xh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_xh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_xh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_xh(1,feature_index).value;
                end
            end
        end 
        elseif(term_weighting_scheme==31)%TF-DFSHMDFSH 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfshmdfsh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfshmdfsh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dfshmdfsh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfshmdfsh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dfshmdfsh(1,feature_index).value;
                end
            end
        end  
        elseif(term_weighting_scheme==32)%TF-EFSH 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_efsh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_efsh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_efsh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_efsh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_efsh(1,feature_index).value;
                end
            end
        end
        
        elseif(term_weighting_scheme==33)%TF-SORH 
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_sorh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_sorh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_sorh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_sorh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_sorh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==34)%TF-MIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mih'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mih_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_mih(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mih_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_mih(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==35)%TF-CCH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cch'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cch_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cch(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cch_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cch(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==36)%TF-IGH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_igh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_igh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_igh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_igh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_igh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==37)%TF-PFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_pfsh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pfsh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_pfsh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pfsh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_pfsh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==38)%TF-GINITH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ginith'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ginith_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ginith(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ginith_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ginith(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==39)%TF-GINIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ginih'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ginih_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ginih(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ginih_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ginih(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==40)%TF-DFSSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dfssh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfssh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dfssh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfssh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dfssh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==41)%TF-NDMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_ndmh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ndmh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ndmh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ndmh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ndmh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==42)%TF-CDMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cdmh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cdmh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cdmh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cdmh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cdmh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==43)%TF-DPMH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_dpmh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dpmh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dpmh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dpmh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dpmh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==44)%TF-CMFSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cmfsh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cmfsh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cmfsh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cmfsh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cmfsh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==45)%TF-MMRH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_mmrh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mmrh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_mmrh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_mmrh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_mmrh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==46)%TF-CRFH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_crfh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_crfh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_crfh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_crfh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_crfh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==47)%TF-POISSONH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_poissonh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_poissonh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_poissonh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_poissonh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_poissonh(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==48)%TF-CICIH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_cicih'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cicih_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_cicih(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_cicih_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_cicih(1,feature_index).value;
                end
            end
        end
        elseif(term_weighting_scheme==49)%TF-GSSHGSSSH
            eval(['load ', strcat(destination_fpath,'features.mat'), '  term_feature_gsshgsssh'])                                
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gsshgsssh_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_gsshgsssh(1,feature_index).value;
                end
            end
            
                   
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gsshgsssh_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_gsshgsssh(1,feature_index).value;
                end
            end
        end
        
    end 
    if train_set==1
        disp('train data construction finished');
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
         eval(['save ', strcat(destination_fpath,'train_matrix.mat'), '  train_matrix topic_matrix train_matrix_without_weighting'])
        %save train_matrix train_matrix topic_matrix train_matrix_without_weighting;
    else
        disp('test data construction finished');
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        %save test_matrix test_matrix topic_matrix_for_test;
        eval(['save ', strcat(destination_fpath,'test_matrix.mat'), '  test_matrix test_class_count topic_matrix_for_test'])
    end
    
end




%===================================================================
% Process Current English Text
%===================================================================
function z=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature)

global stopword_list_map;
global term_feature_map;

result=zeros(1,length(term_feature));


% Make all text lowercase
if uselowercase==1
    curr_text = lower(curr_text);
end

% Remove html codes little than, greater than, and
curr_text = strrep(curr_text, '&lt;', ' ');
curr_text = strrep(curr_text, '&gt;', ' ');
curr_text = strrep(curr_text, '&amp;', ' ');


if tokenization_type==0
    tokenizer='alphanum';
else
    tokenizer='alpha';
end

alphanum_index = isstrprop(curr_text,tokenizer);  % Find indices of alphanumeric characters
curr_text(~alphanum_index) = ' ';%Convert non-alphanumeric chars to space


% Extract words from current text
word_list = strread(curr_text, '%s');


% Process word list in current text
for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    
    %use stop word list if usestopwordremoval is 1, otherwise disregard elimination
    
    % -----------------------------------------------------------------
    % Stopword list elimination
    % -----------------------------------------------------------------    
    is_stopword = 0;
    if (usestopwordremoval==1)        

        if isKey(stopword_list_map,lower(curr_word))==1
            is_stopword = 1;
        end

    end
    
    
    % If term is not in the stopword list, process it.
    if is_stopword ~= 1
        

        
        if (usestemming==1)
        % -----------------------------------------------------------------
        % Porter stemming
        % -----------------------------------------------------------------
        
        curr_word = pr_fe_text_stemmer(char(curr_word));
        else
            curr_word = char(curr_word);
        end
        
   
        
        % -----------------------------------------------------------------
        % Preprocessing is now over. Process current word.
        % -----------------------------------------------------------------

               
        word_index=-1;


        if isKey(term_feature_map,curr_word)==1
            word_index=term_feature_map(curr_word);
        end


        if word_index~=-1
            %result(1,word_index)=1; Set feature with id i=1
            result(1,word_index)=result(1,word_index)+1;%increase feature frequency with id i=1
        end
                  
    end        
    
 
    
end

z=result;

    
end

%===================================================================
% Process Current Turkish Text
%===================================================================
function z=process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature)

global stopword_list_map;
global term_feature_map;

result=zeros(1,length(term_feature));



% Make all text lowercase
if uselowercase==1
    curr_text = lower(curr_text);
end


% Get decimal format of current text
dec_curr_text = abs(curr_text);


if tokenization_type==0
    curr_text((((dec_curr_text <48) | (dec_curr_text >57))& (dec_curr_text < 65)) | (dec_curr_text > 90 & dec_curr_text < 97) | (dec_curr_text > 122 & dec_curr_text ~=231 & dec_curr_text ~=246 & dec_curr_text ~=252 & dec_curr_text ~=287 & dec_curr_text ~=305 & dec_curr_text ~=351 & dec_curr_text ~=199 & dec_curr_text ~=214 & dec_curr_text ~=350 & dec_curr_text ~=220 & dec_curr_text ~=286 & dec_curr_text ~=304)) = 32;%231=ç, 246=ö, 351=þ, 252=ü, 287=ð, 305=ý, 199=Ç, 214=Ö, 350=Þ, 220=Ü, 286=Ð, 304=Ý%alphanumeric tokenizer
else
    curr_text((dec_curr_text < 65) | (dec_curr_text > 90 & dec_curr_text < 97) | (dec_curr_text > 122 & dec_curr_text ~=231 & dec_curr_text ~=246 & dec_curr_text ~=252 & dec_curr_text ~=287 & dec_curr_text ~=305 & dec_curr_text ~=351 & dec_curr_text ~=199 & dec_curr_text ~=214 & dec_curr_text ~=350 & dec_curr_text ~=220 & dec_curr_text ~=286 & dec_curr_text ~=304)) = 32;%231=ç, 246=ö, 351=þ, 252=ü, 287=ð, 305=ý, 199=Ç, 214=Ö, 350=Þ, 220=Ü, 286=Ð, 304=Ý%alpha tokenizer
end



% Extract words from current text
word_list = strread(curr_text, '%s');


% Process word list in current text
for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    
    %use stop word list if usestopwordremoval is 1, otherwise disregard elimination
    
    % -----------------------------------------------------------------
    % Stopword list elimination
    % -----------------------------------------------------------------    
    is_stopword = 0;
    if (usestopwordremoval==1)        

        if isKey(stopword_list_map,lower(curr_word))==1
            is_stopword = 1;
        end

    end
    
    
    % If term is not in the stopword list, process it.
    if is_stopword ~= 1        
        
        if usestemming==1        

            %F5 stemmer
            if length(char(curr_word))>5
                tempword=char(curr_word);
                curr_word=tempword(1:5);
            else
                curr_word=char(curr_word);
            end
        else
             %no stemming
             curr_word=char(curr_word);
        end
        
   
        
        % -----------------------------------------------------------------
        % Preprocessing is now over. Process current word.
        % -----------------------------------------------------------------

               
        word_index=-1;


        if isKey(term_feature_map,curr_word)==1
            word_index=term_feature_map(curr_word);
        end


        if word_index~=-1
            result(1,word_index)=result(1,word_index)+1;%increase feature frequency with id i=1
        end
                  
    end        
    
 
    
end

z=result;

    
end
