function custom_precalculations(dataset_type)

%term feature matrices are constructed by using term_list_pre matrix
%maximum feature selection values of each term are selected and
%saved as 7 ordered matrices in features.mat file


%load dataset_class_idx;
%load term_list_pre;

% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5;
DATASET_REUTERS_PARTIAL = 6;
DATASET_NEWS3 = 7;
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

destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
eval(['load ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

term_feature_am_tf   = struct('term', {},'value', {});
term_feature_dfs = struct('term', {},'value', {});
term_feature_phdnm_f2 = struct('term', {},'value', {});
term_feature_gi   = struct('term', {},'value', {});
term_feature_ig   = struct('term', {},'value', {});
term_feature_chi2   = struct('term', {},'value', {});
term_feature_mi   = struct('term', {},'value', {});
term_feature_df   = struct('term', {},'value', {});
term_feature_gi_original   = struct('term', {},'value', {});
term_feature_ig_original   = struct('term', {},'value', {});
term_feature_chi2_original   = struct('term', {},'value', {});
term_feature_poisson   = struct('term', {},'value', {});
term_feature_pbweighting   = struct('term', {},'value', {});
term_feature_tfrf   = struct('term', {},'value', {});
term_feature_tfrr   = struct('term', {},'value', {});
term_feature_pfs = struct('term', {},'value', {});
term_feature_dfss = struct('term', {},'value', {});
term_feature_ndm = struct('term', {},'value', {});
term_feature_mdfs = struct('term', {},'value', {});
term_feature_cdm   = struct('term', {},'value', {});
term_feature_dpm = struct('term', {},'value', {});
term_feature_mor = struct('term', {},'value', {});
term_feature_cmfs = struct('term', {},'value', {});
term_feature_mmr = struct('term', {},'value', {});
term_feature_efs = struct('term', {},'value', {});
term_feature_cici = struct('term', {},'value', {});
term_feature_pmh = struct('term', {},'value', {});
term_feature_gss = struct('term', {},'value', {});
term_feature_gsss = struct('term', {},'value', {});

term_feature_xh   = struct('term', {},'value', {});
term_feature_dfshmdfsh = struct('term', {},'value', {});
term_feature_efsh = struct('term', {},'value', {});
term_feature_sorh = struct('term', {},'value', {});
term_feature_mih = struct('term', {},'value', {});
term_feature_cch = struct('term', {},'value', {});
term_feature_igh = struct('term', {},'value', {});
term_feature_pfsh = struct('term', {},'value', {});
term_feature_ginith = struct('term', {},'value', {});
term_feature_ginih = struct('term', {},'value', {});
term_feature_dfssh   = struct('term', {},'value', {});
term_feature_ndmh = struct('term', {},'value', {});
term_feature_cdmh = struct('term', {},'value', {});
term_feature_dpmh = struct('term', {},'value', {});
term_feature_cmfsh = struct('term', {},'value', {});
term_feature_mmrh = struct('term', {},'value', {});
term_feature_crfh = struct('term', {},'value', {});
term_feature_poissonh = struct('term', {},'value', {});
term_feature_cicih = struct('term', {},'value', {});
term_feature_gsshgsssh = struct('term', {},'value', {});

% DFSSH 40
% NDMH 41
% CDMH 42
% DPMH 43
% CMFSH 44
% MMRH 45
% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

doc_freq_of_terms   = struct('term', {},'value', {});

term_list=repmat(cellstr(''), 1,length(term_list_pre));

for i=1:length(term_list_pre)
    term_list(1,i)=cellstr(term_list_pre(i).NAME);
end

%sort matrices according to alphabetic order
[~, order] = sort(term_list(1,:));
new_term_list_pre_namesorted = term_list_pre(order);


counter=1;
termcounter=1;
lengthterms=length(term_list_pre);

tempterm=new_term_list_pre_namesorted(1,1).NAME;
term_feature_am_tf(1,1).value=0;
term_feature_dfs(1,1).value=0;
term_feature_phdnm_f2(1,1).value=0;
term_feature_gi(1,1).value=0;
term_feature_ig(1,1).value=0;
term_feature_chi2(1,1).value=0;
term_feature_mi(1,1).value=0;
term_feature_df(1,1).value=0;
doc_freq_of_terms(1,1).value=0;
term_feature_gi_original(1,1).value=0;
term_feature_ig_original(1,1).value=0;
term_feature_chi2_original(1,1).value=0;
term_feature_poisson(1,1).value=0;
term_feature_pbweighting(1,1).value=0;
term_feature_tfrf(1,1).value=0;
term_feature_tfrr(1,1).value=0;
term_feature_pfs(1,1).value=0;
term_feature_dfss(1,1).value=0;
term_feature_ndm(1,1).value=0;
term_feature_mdfs(1,1).value=0;
term_feature_cdm(1,1).value=0;
term_feature_dpm(1,1).value=0;
term_feature_mor(1,1).value=0;
term_feature_cmfs(1,1).value=0;
term_feature_mmr(1,1).value=0;
term_feature_efs(1,1).value=0;
term_feature_cici(1,1).value=0;
term_feature_pmh(1,1).value=0;
term_feature_gss(1,1).value=0;
term_feature_gsss(1,1).value=0;

term_feature_xh(1,1).value=0;
term_feature_dfshmdfsh(1,1).value=0;
term_feature_efsh(1,1).value=0;
term_feature_sorh(1,1).value=0;
term_feature_mih(1,1).value=0;
term_feature_cch(1,1).value=0;
term_feature_igh(1,1).value=0;
term_feature_pfsh(1,1).value=0;
term_feature_ginith(1,1).value=0;
term_feature_ginih(1,1).value=0;
term_feature_dfssh(1,1).value=0;
term_feature_ndmh(1,1).value=0;
term_feature_cdmh(1,1).value=0;
term_feature_dpmh(1,1).value=0;
term_feature_cmfsh(1,1).value=0;
term_feature_mmrh(1,1).value=0;
term_feature_crfh(1,1).value=0;
term_feature_poissonh(1,1).value=0;
term_feature_cicih(1,1).value=0;
term_feature_gsshgsssh(1,1).value=0;

%control=0;

%iterate over all terms,
%get unique terms and maximum their corresponding maximum values in new_term_list_pre_namesorted matrix 
while counter<=lengthterms
    %get unique term names
    term_feature_am_tf(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dfs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_phdnm_f2(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gi(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ig(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_chi2(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mi(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_df(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    doc_freq_of_terms(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gi_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ig_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_chi2_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_poisson(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_pbweighting(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_tfrf(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_tfrr(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_pfs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dfss(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ndm(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mdfs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cdm(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dpm(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mor(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cmfs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mmr(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_efs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cici(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_pmh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gss(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gsss(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;

    term_feature_xh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dfshmdfsh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_efsh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_sorh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mih(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cch(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_igh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_pfsh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ginith(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ginih(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dfssh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ndmh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cdmh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dpmh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cmfsh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mmrh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_crfh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_poissonh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_cicih(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gsshgsssh(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;

    
    
    
    if (isnan(new_term_list_pre_namesorted(1,counter).TF_RR) || isinf(new_term_list_pre_namesorted(1,counter).TF_RR))
        temp_tfrr_weight=0;
    else
        temp_tfrr_weight=new_term_list_pre_namesorted(1,counter).TF_RR;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT) || isinf(new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT))
        temp_pb_weight=0;
    else
        temp_pb_weight=new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).TF_RF) || isinf(new_term_list_pre_namesorted(1,counter).TF_RF))
        temp_tfrf_weight=0;
    else
        temp_tfrf_weight=new_term_list_pre_namesorted(1,counter).TF_RF;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PHD_NM_F2) || isinf(new_term_list_pre_namesorted(1,counter).PHD_NM_F2))
        temp_phdnm_f2=0;
    else
        temp_phdnm_f2=new_term_list_pre_namesorted(1,counter).PHD_NM_F2;
    end
    
    %use a temp_gini_index for comparisons, it is first occurrence value
    %for a term
    %replace its value if next values of a term are bigger than temp_gini_index
    
    if (isnan(new_term_list_pre_namesorted(1,counter).IG))
        temp_ig=0;
    else
        temp_ig=new_term_list_pre_namesorted(1,counter).IG;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).IG_FOR_TERM) || isinf(new_term_list_pre_namesorted(1,counter).IG_FOR_TERM))
        temp_igoriginal=0;
    else
        temp_igoriginal=new_term_list_pre_namesorted(1,counter).IG_FOR_TERM;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CHI2) || isinf(new_term_list_pre_namesorted(1,counter).CHI2))
        temp_chi2=0;
    else
        temp_chi2=new_term_list_pre_namesorted(1,counter).CHI2;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).POISSON) || isinf(new_term_list_pre_namesorted(1,counter).POISSON))
        temp_poisson=0;
    else
        temp_poisson=new_term_list_pre_namesorted(1,counter).POISSON;
    end
    
    
    if (isnan(new_term_list_pre_namesorted(1,counter).MUTUAL_INFO))
        temp_mi=0;
    else
        temp_mi=new_term_list_pre_namesorted(1,counter).MUTUAL_INFO;
    end
        
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DF) || isinf(new_term_list_pre_namesorted(1,counter).DF))
        temp_df=0;
    else
        temp_df=new_term_list_pre_namesorted(1,counter).DF;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DFSS) || isinf(new_term_list_pre_namesorted(1,counter).DFSS))
        temp_dfss=0;
    else
        temp_dfss=new_term_list_pre_namesorted(1,counter).DFSS;
    end
    
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CDM) || isinf(new_term_list_pre_namesorted(1,counter).CDM))
        temp_cdm=0;
    else
        temp_cdm=new_term_list_pre_namesorted(1,counter).CDM;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DPM)|| isinf(new_term_list_pre_namesorted(1,counter).DPM))
        temp_dpm=0;
    else
        temp_dpm=new_term_list_pre_namesorted(1,counter).DPM;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).MOR)|| isinf(new_term_list_pre_namesorted(1,counter).MOR))
        temp_mor=0;
    else
        temp_mor=new_term_list_pre_namesorted(1,counter).MOR;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CMFS) || isinf(new_term_list_pre_namesorted(1,counter).CMFS))
        temp_cmfs=0;
    else
        temp_cmfs=new_term_list_pre_namesorted(1,counter).CMFS;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).MMR) || isinf(new_term_list_pre_namesorted(1,counter).MMR))
        temp_mmr=0;
    else
        temp_mmr=new_term_list_pre_namesorted(1,counter).MMR;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).EFS) || isinf(new_term_list_pre_namesorted(1,counter).EFS))
        temp_efs=0;
    else
        temp_efs=new_term_list_pre_namesorted(1,counter).EFS;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CICI) || isinf(new_term_list_pre_namesorted(1,counter).CICI))
        temp_cici=0;
    else
        temp_cici=new_term_list_pre_namesorted(1,counter).CICI;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PMH) || isinf(new_term_list_pre_namesorted(1,counter).PMH))
        temp_pmh=0;
    else
        temp_pmh=new_term_list_pre_namesorted(1,counter).PMH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).GSS) || isinf(new_term_list_pre_namesorted(1,counter).GSS))
        temp_gss=0;
    else
        temp_gss=new_term_list_pre_namesorted(1,counter).GSS;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).GSSS) || isinf(new_term_list_pre_namesorted(1,counter).GSSS))
        temp_gsss=0;
    else
        temp_gsss=new_term_list_pre_namesorted(1,counter).GSSS;
    end
    
%     % for ndm inf problem - ONCEDEN KAPATILMIS, KAPALI KALSIN
     if (isnan(new_term_list_pre_namesorted(1,counter).NDM) || isinf(new_term_list_pre_namesorted(1,counter).NDM))
         temp_ndm=0;
     else
         temp_ndm=new_term_list_pre_namesorted(1,counter).NDM;
     end
%     
%     % for pfs inf problem
    if (isnan(new_term_list_pre_namesorted(1,counter).PFS) || isinf(new_term_list_pre_namesorted(1,counter).PFS))
        temp_pfs=0;
    else
        temp_pfs=new_term_list_pre_namesorted(1,counter).PFS;
    end
    
  




    
    if (isnan(new_term_list_pre_namesorted(1,counter).XH) || isinf(new_term_list_pre_namesorted(1,counter).XH))
        temp_xh=0;
    else
        temp_xh=new_term_list_pre_namesorted(1,counter).XH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DFSHMDFSH) || isinf(new_term_list_pre_namesorted(1,counter).DFSHMDFSH))
        temp_dfshmdfsh=0;
    else
        temp_dfshmdfsh=new_term_list_pre_namesorted(1,counter).DFSHMDFSH;
    end
    
      % XH 30
% DFSHMDFSH 31
% EFSH 32
% SORH 33

    if (isnan(new_term_list_pre_namesorted(1,counter).EFSH) || isinf(new_term_list_pre_namesorted(1,counter).EFSH))
        temp_efsh=0;
    else
        temp_efsh=new_term_list_pre_namesorted(1,counter).EFSH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).SORH) || isinf(new_term_list_pre_namesorted(1,counter).SORH))
        temp_sorh=0;
    else
        temp_sorh=new_term_list_pre_namesorted(1,counter).SORH;
    end
    
    % MIH 34
% CCH 35
% IGH 36
% PFSH 37

    if (isnan(new_term_list_pre_namesorted(1,counter).MIH) || isinf(new_term_list_pre_namesorted(1,counter).MIH))
        temp_mih=0;
    else
        temp_mih=new_term_list_pre_namesorted(1,counter).MIH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CCH) || isinf(new_term_list_pre_namesorted(1,counter).CCH))
        temp_cch=0;
    else
        temp_cch=new_term_list_pre_namesorted(1,counter).CCH;
    end
    if (isnan(new_term_list_pre_namesorted(1,counter).IGH) || isinf(new_term_list_pre_namesorted(1,counter).IGH))
        temp_igh=0;
    else
        temp_igh=new_term_list_pre_namesorted(1,counter).IGH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PFSH) || isinf(new_term_list_pre_namesorted(1,counter).PFSH))
        temp_pfsh=0;
    else
        temp_pfsh=new_term_list_pre_namesorted(1,counter).PFSH;
    end
    
% GINITH 38
% GINIH 39
% DFSSH 40
% NDMH 41
   
    if (isnan(new_term_list_pre_namesorted(1,counter).GINITH) || isinf(new_term_list_pre_namesorted(1,counter).GINITH))
        temp_ginith=0;
    else
        temp_ginith=new_term_list_pre_namesorted(1,counter).GINITH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).GINIH) || isinf(new_term_list_pre_namesorted(1,counter).GINIH))
        temp_ginih=0;
    else
        temp_ginih=new_term_list_pre_namesorted(1,counter).GINIH;
    end
    if (isnan(new_term_list_pre_namesorted(1,counter).DFSSH) || isinf(new_term_list_pre_namesorted(1,counter).DFSSH))
        temp_dfssh=0;
    else
        temp_dfssh=new_term_list_pre_namesorted(1,counter).DFSSH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).NDMH) || isinf(new_term_list_pre_namesorted(1,counter).NDMH))
        temp_ndmh=0;
    else
        temp_ndmh=new_term_list_pre_namesorted(1,counter).NDMH;
    end
    
% CDMH 42
% DPMH 43
% CMFSH 44
% MMRH 45

if (isnan(new_term_list_pre_namesorted(1,counter).CDMH) || isinf(new_term_list_pre_namesorted(1,counter).CDMH))
        temp_cdmh=0;
    else
        temp_cdmh=new_term_list_pre_namesorted(1,counter).CDMH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DPMH) || isinf(new_term_list_pre_namesorted(1,counter).DPMH))
        temp_dpmh=0;
    else
        temp_dpmh=new_term_list_pre_namesorted(1,counter).DPMH;
    end
    if (isnan(new_term_list_pre_namesorted(1,counter).CMFSH) || isinf(new_term_list_pre_namesorted(1,counter).CMFSH))
        temp_cmfsh=0;
    else
        temp_cmfsh=new_term_list_pre_namesorted(1,counter).CMFSH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).MMRH) || isinf(new_term_list_pre_namesorted(1,counter).MMRH))
        temp_mmrh=0;
    else
        temp_mmrh=new_term_list_pre_namesorted(1,counter).MMRH;
    end
    
% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

if (isnan(new_term_list_pre_namesorted(1,counter).CRFH) || isinf(new_term_list_pre_namesorted(1,counter).CRFH))
        temp_crfh=0;
    else
        temp_crfh=new_term_list_pre_namesorted(1,counter).CRFH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).POISSONH) || isinf(new_term_list_pre_namesorted(1,counter).POISSONH))
        temp_poissonh=0;
    else
        temp_poissonh=new_term_list_pre_namesorted(1,counter).POISSONH;
    end
    if (isnan(new_term_list_pre_namesorted(1,counter).CICIH) || isinf(new_term_list_pre_namesorted(1,counter).CICIH))
        temp_cicih=0;
    else
        temp_cicih=new_term_list_pre_namesorted(1,counter).CICIH;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).GSSHGSSSH) || isinf(new_term_list_pre_namesorted(1,counter).GSSHGSSSH))
        temp_gsshgsssh=0;
    else
        temp_gsshgsssh=new_term_list_pre_namesorted(1,counter).GSSHGSSSH;
    end
%     
%     if (term_feature_ndm(termcounter).value<temp_ndm)
%         term_feature_ndm(termcounter).value=temp_ndm;
%     end
%     
%     if (term_feature_pfs(termcounter).value<temp_pfs)
%         term_feature_pfs(termcounter).value=temp_pfs;
%     end
%     
    %%%%
    
    
    %en buyugu 
    if (term_feature_tfrr(termcounter).value<temp_tfrr_weight)
        term_feature_tfrr(termcounter).value=temp_tfrr_weight;
    end
    
    %en buyugu 
    if (term_feature_tfrf(termcounter).value<temp_tfrf_weight)
        term_feature_tfrf(termcounter).value=temp_tfrf_weight;
    end
    
    %en buyugu 
    if (term_feature_pbweighting(termcounter).value<temp_pb_weight)
        term_feature_pbweighting(termcounter).value=temp_pb_weight;
    end
    
    if (term_feature_am_tf(termcounter).value<new_term_list_pre_namesorted(1,counter).AM_TF)
        term_feature_am_tf(termcounter).value=new_term_list_pre_namesorted(1,counter).AM_TF;
    end
    
    %DFSS - max
    if (term_feature_dfss(termcounter).value<temp_dfss)
        term_feature_dfss(termcounter).value=temp_dfss;
    end
    
    %%%% ONCEDEN KAPALIYDI, KAPALI KALSIN
% en buyugu    
%     if (term_feature_dfs(termcounter).value<new_term_list_pre_namesorted(1,counter).DFS)
%         term_feature_dfs(termcounter).value=new_term_list_pre_namesorted(1,counter).DFS;
%     end
 

% weighted average toplami
    %term_feature_dfs(termcounter).value=term_feature_dfs(termcounter).value+(dataset_class_idx(new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx))*new_term_list_pre_namesorted(1,counter).DFS;
 
    %%%%   

%normal toplam
    term_feature_dfs(termcounter).value=term_feature_dfs(termcounter).value+new_term_list_pre_namesorted(1,counter).DFS;
    %control=control+new_term_list_pre_namesorted(1,counter).DF;
    
    
    
    %NDM
    term_feature_ndm(termcounter).value=term_feature_ndm(termcounter).value+new_term_list_pre_namesorted(1,counter).NDM;
     
    %MDFS
    term_feature_mdfs(termcounter).value=term_feature_mdfs(termcounter).value+new_term_list_pre_namesorted(1,counter).MDFS;
    
    %CDM
    term_feature_cdm(termcounter).value=term_feature_cdm(termcounter).value+new_term_list_pre_namesorted(1,counter).CDM;
    
    %DPM
    term_feature_dpm(termcounter).value=term_feature_dpm(termcounter).value+new_term_list_pre_namesorted(1,counter).DPM;
    
    %MOR
    term_feature_mor(termcounter).value=term_feature_mor(termcounter).value+new_term_list_pre_namesorted(1,counter).MOR;
    
    %CMFS
    term_feature_cmfs(termcounter).value=term_feature_cmfs(termcounter).value+new_term_list_pre_namesorted(1,counter).CMFS;
    
    %MMR
    term_feature_mmr(termcounter).value=term_feature_mmr(termcounter).value+new_term_list_pre_namesorted(1,counter).MMR;
    
    %EFS
    term_feature_efs(termcounter).value=term_feature_efs(termcounter).value+new_term_list_pre_namesorted(1,counter).EFS;
    
    %CICI
    term_feature_cici(termcounter).value=term_feature_cici(termcounter).value+new_term_list_pre_namesorted(1,counter).CICI;
    
    %PMH
    term_feature_pmh(termcounter).value=term_feature_pmh(termcounter).value+new_term_list_pre_namesorted(1,counter).PMH;
    
    %GSS
    term_feature_gss(termcounter).value=term_feature_gss(termcounter).value+new_term_list_pre_namesorted(1,counter).GSS;
    
    %GSSS
    term_feature_gsss(termcounter).value=term_feature_gsss(termcounter).value+new_term_list_pre_namesorted(1,counter).GSSS;
    
    
    % XH 30
% DFSHMDFSH 31
% EFSH 32
% SORH 33
% MIH 34
% CCH 35
% IGH 36
% PFSH 37
% GINITH 38
% GINIH 39
% DFSSH 40
% NDMH 41
% CDMH 42
% DPMH 43
% CMFSH 44
% MMRH 45
% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

    %XH
    term_feature_xh(termcounter).value=term_feature_xh(termcounter).value+new_term_list_pre_namesorted(1,counter).XH;
    
    %DFSHMDFSH
    term_feature_dfshmdfsh(termcounter).value=term_feature_dfshmdfsh(termcounter).value+new_term_list_pre_namesorted(1,counter).DFSHMDFSH;
    
    %EFSH
    term_feature_efsh(termcounter).value=term_feature_efsh(termcounter).value+new_term_list_pre_namesorted(1,counter).EFSH;
    
    %SORH
    term_feature_sorh(termcounter).value=term_feature_sorh(termcounter).value+new_term_list_pre_namesorted(1,counter).SORH;
    
    % MIH 34
    term_feature_mih(termcounter).value=term_feature_mih(termcounter).value+new_term_list_pre_namesorted(1,counter).MIH;
    
% CCH 35
term_feature_cch(termcounter).value=term_feature_cch(termcounter).value+new_term_list_pre_namesorted(1,counter).CCH;

% IGH 36
term_feature_igh(termcounter).value=term_feature_igh(termcounter).value+new_term_list_pre_namesorted(1,counter).IGH;

% PFSH 37
term_feature_pfsh(termcounter).value=term_feature_pfsh(termcounter).value+new_term_list_pre_namesorted(1,counter).PFSH;

% GINITH 38
term_feature_ginith(termcounter).value=term_feature_ginith(termcounter).value+new_term_list_pre_namesorted(1,counter).GINITH;

% GINIH 39
term_feature_ginih(termcounter).value=term_feature_ginih(termcounter).value+new_term_list_pre_namesorted(1,counter).GINIH;

% DFSSH 40
term_feature_dfssh(termcounter).value=term_feature_dfssh(termcounter).value+new_term_list_pre_namesorted(1,counter).DFSSH;

% NDMH 41
term_feature_ndmh(termcounter).value=term_feature_ndmh(termcounter).value+new_term_list_pre_namesorted(1,counter).NDMH;

% CDMH 42
term_feature_cdmh(termcounter).value=term_feature_cdmh(termcounter).value+new_term_list_pre_namesorted(1,counter).CDMH;

% DPMH 43
term_feature_dpmh(termcounter).value=term_feature_dpmh(termcounter).value+new_term_list_pre_namesorted(1,counter).DPMH;

% CMFSH 44
term_feature_cmfsh(termcounter).value=term_feature_cmfsh(termcounter).value+new_term_list_pre_namesorted(1,counter).CMFSH;

% MMRH 45
term_feature_mmrh(termcounter).value=term_feature_mmrh(termcounter).value+new_term_list_pre_namesorted(1,counter).MMRH;

% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

% CRFH 46
term_feature_crfh(termcounter).value=term_feature_crfh(termcounter).value+new_term_list_pre_namesorted(1,counter).CRFH;

% POISSONH 47
term_feature_poissonh(termcounter).value=term_feature_poissonh(termcounter).value+new_term_list_pre_namesorted(1,counter).POISSONH;

% CICIH 48
term_feature_cicih(termcounter).value=term_feature_cicih(termcounter).value+new_term_list_pre_namesorted(1,counter).CICIH;

% GSSHGSSSH 49
term_feature_gsshgsssh(termcounter).value=term_feature_gsshgsssh(termcounter).value+new_term_list_pre_namesorted(1,counter).GSSHGSSSH;
    
%     for curr_class=1:length(dataset_topics)
%         if curr_class == 1
%             [~, class_min_idx] = dataset_class_idx(curr_class);
    %PFS takes minor class into consideration
    [~, class_min_idx] = min(dataset_class_idx);
            if (new_term_list_pre_namesorted(1,counter).CLASS == class_min_idx)
        term_feature_pfs(termcounter).value = new_term_list_pre_namesorted(1,counter).PFS;
            end
        
    %end 
    
    %term_feature_pfs(termcounter).value=term_feature_pfs(termcounter).value+new_term_list_pre_namesorted(1,counter).PFS;
    

% en buyugu 
%     if (term_feature_phdnm_f2(termcounter).value<temp_phdnm_f2)
%         term_feature_phdnm_f2(termcounter).value=temp_phdnm_f2;
%     end
  

%normal toplam    
term_feature_phdnm_f2(termcounter).value=term_feature_phdnm_f2(termcounter).value+temp_phdnm_f2;

% weighted average toplami
%term_feature_phdnm_f2(termcounter).value=term_feature_phdnm_f2(termcounter).value+(dataset_class_idx(new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx))*temp_phdnm_f2;

    
    

    if (term_feature_gi(termcounter).value<new_term_list_pre_namesorted(1,counter).GINI_INDEX)
        term_feature_gi(termcounter).value=new_term_list_pre_namesorted(1,counter).GINI_INDEX;
    end
    

    
    if (term_feature_chi2(termcounter).value<temp_chi2)
        term_feature_chi2(termcounter).value=temp_chi2;
    end
    

    
    if (term_feature_df(termcounter).value<temp_df)
        term_feature_df(termcounter).value=temp_df;
    end
    
%    classprob=dataset_class_idx(1,new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx);  
    
    if (term_feature_mi(termcounter).value<temp_mi)
        term_feature_mi(termcounter).value=temp_mi;
    end
    
%     term_feature_mi(termcounter).value=term_feature_mi(termcounter).value+(classprob*temp_mi);
    
    
    
    if (term_feature_ig(termcounter).value<temp_ig)
        term_feature_ig(termcounter).value=temp_ig;
    end
%     
%      term_feature_ig(termcounter).value=term_feature_ig(termcounter).value+(classprob*temp_ig);

    
    if (term_feature_chi2_original(termcounter).value<temp_chi2)
        term_feature_chi2_original(termcounter).value=temp_chi2;
    end
    
%     term_feature_chi2_original(termcounter).value=term_feature_chi2_original(termcounter).value+(classprob*temp_chi2);
    
%     
%     if (term_feature_mor(termcounter).value<temp_mor)
%         term_feature_mor(termcounter).value=temp_mor;
%     end
% 
%     if (term_feature_dfss(termcounter).value<temp_dfss)
%         term_feature_dfss(termcounter).value=temp_dfss;
%     end
%     
%     if (term_feature_ndm(termcounter).value<temp_ndm)
%         term_feature_ndm(termcounter).value=temp_ndm;
%     end
% 
%     if (term_feature_poisson(termcounter).value<temp_poisson)
%         term_feature_poisson(termcounter).value=temp_poisson;
%     end
%     
%     
%     if (term_feature_cdm(termcounter).value<temp_cdm)
%         term_feature_cdm(termcounter).value=temp_cdm;
%     end
%     
%     if (term_feature_dpm(termcounter).value<temp_dpm)
%         term_feature_dpm(termcounter).value=temp_dpm;
%     end
%     
%     if (term_feature_mor(termcounter).value<temp_mor)
%         term_feature_mor(termcounter).value=temp_mor;
%     end
%     
%     if (term_feature_cmfs(termcounter).value<temp_cmfs)
%         term_feature_cmfs(termcounter).value=temp_cmfs;
%     end
%     
%     if (term_feature_mmr(termcounter).value<temp_mmr)
%         term_feature_mmr(termcounter).value=temp_mmr;
%     end
%     
%     if (term_feature_efs(termcounter).value<temp_efs)
%         term_feature_efs(termcounter).value=temp_efs;
%     end
%    
%     if (term_feature_cici(termcounter).value<temp_cici)
%         term_feature_cici(termcounter).value=temp_cici;
%     end
% 
%     term_feature_poisson(termcounter).value=term_feature_poisson(termcounter).value+(classprob*temp_poisson);            


    
    term_feature_gi_original(termcounter).value=term_feature_gi_original(termcounter).value+new_term_list_pre_namesorted(1,counter).GINI_INDEX_FOR_TERM;
    term_feature_ig_original(termcounter).value=term_feature_ig_original(termcounter).value+temp_igoriginal;
    
   
    doc_freq_of_terms(termcounter).value=doc_freq_of_terms(termcounter).value+new_term_list_pre_namesorted(1,counter).APPEARANCE;   

    %increase termcounter if reoccurring elements are finished and assign
    %next term as current
    if counter<lengthterms
        if strcmp(tempterm,new_term_list_pre_namesorted(1,counter+1).NAME)~=1
            %to eliminate terms occuring all documents
%             if (control==sum(pfs))
%                 term_feature_dfs(1,termcounter).value=0;
%             end
%             control=0;
            
            termcounter=termcounter+1;
            tempterm=new_term_list_pre_namesorted(1,counter+1).NAME;
            term_feature_am_tf(1,termcounter).value=0;
            term_feature_dfs(1,termcounter).value=0;
            term_feature_phdnm_f2(1,termcounter).value=0;
            term_feature_gi(1,termcounter).value=0;
            term_feature_ig(1,termcounter).value=0;
            term_feature_mi(1,termcounter).value=0;
            term_feature_chi2(1,termcounter).value=0;
            term_feature_df(1,termcounter).value=0;
            doc_freq_of_terms(1,termcounter).value=0;
            term_feature_gi_original(1,termcounter).value=0;
            term_feature_ig_original(1,termcounter).value=0;
            term_feature_chi2_original(1,termcounter).value=0;
            term_feature_poisson(1,termcounter).value=0;
            term_feature_pbweighting(1,termcounter).value=0;
            term_feature_tfrf(1,termcounter).value=0;
            term_feature_tfrr(1,termcounter).value=0;
            term_feature_pfs(1,termcounter).value=0;
            term_feature_dfss(1,termcounter).value=0;
            term_feature_ndm(1,termcounter).value=0;
            term_feature_mdfs(1,termcounter).value=0;
            term_feature_cdm(1,termcounter).value=0;
            term_feature_dpm(1,termcounter).value=0;
            term_feature_mor(1,termcounter).value=0;
            term_feature_cmfs(1,termcounter).value=0;
            term_feature_mmr(1,termcounter).value=0;
            term_feature_efs(1,termcounter).value=0;
            term_feature_cici(1,termcounter).value=0;
            term_feature_pmh(1,termcounter).value=0;
            term_feature_gss(1,termcounter).value=0;
            term_feature_gsss(1,termcounter).value=0;
 

% CMFSH 44
% MMRH 45
% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49
            term_feature_xh(1,termcounter).value=0;
            term_feature_dfshmdfsh(1,termcounter).value=0;
            term_feature_efsh(1,termcounter).value=0;
            term_feature_sorh(1,termcounter).value=0;
            term_feature_mih(1,termcounter).value=0;
            term_feature_cch(1,termcounter).value=0;
            term_feature_igh(1,termcounter).value=0;
            term_feature_pfsh(1,termcounter).value=0;
            term_feature_ginith(1,termcounter).value=0;
            term_feature_ginih(1,termcounter).value=0;
            term_feature_dfssh(1,termcounter).value=0;
            term_feature_ndmh(1,termcounter).value=0;
            term_feature_cdmh(1,termcounter).value=0;
            term_feature_dpmh(1,termcounter).value=0;
            term_feature_cmfsh(1,termcounter).value=0;
            term_feature_mmrh(1,termcounter).value=0;
            term_feature_crfh(1,termcounter).value=0;
            term_feature_poissonh(1,termcounter).value=0;
            term_feature_cicih(1,termcounter).value=0;
            term_feature_gsshgsssh(1,termcounter).value=0;

        end
    end
    %increase 
    counter=counter+1;
end




%sort unique terms according to their value, dfs
lenterms=length(term_feature_dfs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dfs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dfs = term_feature_dfs(orderidx);


%sort unique terms according to their value, phd novel method formula 2
lenterms=length(term_feature_phdnm_f2);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_phdnm_f2(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_phdnm_f2 = term_feature_phdnm_f2(orderidx);


%sort unique terms according to their value, gini index

lenterms=length(term_feature_gi);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gi(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gi = term_feature_gi(orderidx);


%sort unique terms according to their value, information gain
lenterms=length(term_feature_ig);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    if (isnan(term_feature_ig(1,i).value))
        tmptermvalues(1,i)=0;
    else
        tmptermvalues(1,i)=term_feature_ig(1,i).value;
    end
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ig = term_feature_ig(orderidx);


%sort unique terms according to their value, mutual information
lenterms=length(term_feature_mi);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mi(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mi = term_feature_mi(orderidx);


%sort unique terms according to their value, chi square

tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2 = term_feature_chi2(orderidx);


%sort unique terms according to their value, ambiguity measure tf
lenterms=length(term_feature_am_tf);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_am_tf(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_am_tf = term_feature_am_tf(orderidx);

%sort unique terms according to their value, document frequency
%check for null df values and make them zero
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    if (isnan(term_feature_df(1,i).value) || isinf(term_feature_df(1,i).value))
        tmptermvalues(1,i)=0;
    else
        tmptermvalues(1,i)=term_feature_df(1,i).value;
    end
end

[dummy, orderidx] = sort(tmptermvalues,'descend');
term_feature_df = term_feature_df(orderidx);

%sort unique terms according to their value, dfss
lenterms=length(term_feature_dfss);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dfss(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dfss = term_feature_dfss(orderidx);


%sort unique terms according to their value, pfs
lenterms=length(term_feature_pfs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_pfs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_pfs = term_feature_pfs(orderidx);

%sort unique terms according to their value, ndm
lenterms=length(term_feature_ndm);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ndm(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ndm = term_feature_ndm(orderidx);

%sort unique terms according to their value, mdfs
lenterms=length(term_feature_mdfs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mdfs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mdfs = term_feature_mdfs(orderidx);

%sort unique terms according to their value, cdm
lenterms=length(term_feature_cdm);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cdm(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cdm = term_feature_cdm(orderidx);

%sort unique terms according to their value, dpm
lenterms=length(term_feature_dpm);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dpm(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dpm = term_feature_dpm(orderidx);

%sort unique terms according to their value, mor
lenterms=length(term_feature_mor);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mor(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mor = term_feature_mor(orderidx);

%sort unique terms according to their value, cmfs
lenterms=length(term_feature_cmfs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cmfs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cmfs = term_feature_cmfs(orderidx);

%sort unique terms according to their value, mmr
lenterms=length(term_feature_mmr);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mmr(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mmr = term_feature_mmr(orderidx);

%sort unique terms according to their value, efs
lenterms=length(term_feature_efs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_efs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_efs = term_feature_efs(orderidx);

%sort unique terms according to their value, cici
lenterms=length(term_feature_cici);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cici(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cici = term_feature_cici(orderidx);

%sort unique terms according to their value, pmh
lenterms=length(term_feature_pmh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_pmh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_pmh = term_feature_pmh(orderidx);

%sort unique terms according to their value, gss
lenterms=length(term_feature_gss);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gss(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gss = term_feature_gss(orderidx);

%sort unique terms according to their value, gsss
lenterms=length(term_feature_gsss);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gsss(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gsss = term_feature_gsss(orderidx);



%sort unique terms according to original gini index formula
lenterms=length(term_feature_gi_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gi_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gi_original = term_feature_gi_original(orderidx);


%sort unique terms according to original information gain formula
lenterms=length(term_feature_ig_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ig_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ig_original = term_feature_ig_original(orderidx);


%sort unique terms according to original chi square formula
lenterms=length(term_feature_chi2_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2_original = term_feature_chi2_original(orderidx);

%sort unique terms according to probability based weighting formula
lenterms=length(term_feature_pbweighting);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_pbweighting(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_pbweighting = term_feature_pbweighting(orderidx);


%sort unique terms according to tfrf weighting formula
lenterms=length(term_feature_tfrf);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_tfrf(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_tfrf = term_feature_tfrf(orderidx);

%sort unique terms according to tfrr weighting formula
lenterms=length(term_feature_tfrr);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_tfrr(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_tfrr = term_feature_tfrr(orderidx);

%sort unique terms according to original chi square formula
lenterms=length(term_feature_chi2_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2_original = term_feature_chi2_original(orderidx);


%sort unique terms according to poisson formula
lenterms=length(term_feature_poisson);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_poisson(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_poisson = term_feature_poisson(orderidx);



% XH 30
% DFSHMDFSH 31
% EFSH 32
% SORH 33
% MIH 34
% CCH 35
% IGH 36
% PFSH 37
% GINITH 38
% GINIH 39
% DFSSH 40
% NDMH 41
% CDMH 42
% DPMH 43
% CMFSH 44
% MMRH 45
% CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

%sort unique terms according to their value, xh
lenterms=length(term_feature_xh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_xh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_xh= term_feature_xh(orderidx);

%sort unique terms according to their value, dfshmdfsh
lenterms=length(term_feature_dfshmdfsh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dfshmdfsh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dfshmdfsh= term_feature_dfshmdfsh(orderidx);

%sort unique terms according to their value, efsh
lenterms=length(term_feature_efsh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_efsh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_efsh= term_feature_efsh(orderidx);

%sort unique terms according to their value, sorh
lenterms=length(term_feature_sorh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_sorh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_sorh= term_feature_sorh(orderidx);

%sort unique terms according to their value, mih
lenterms=length(term_feature_mih);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mih(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mih= term_feature_mih(orderidx);

%sort unique terms according to their value, cch
lenterms=length(term_feature_cch);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cch(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cch= term_feature_cch(orderidx);

document_frequency_map=containers.Map();

%sort unique terms according to their value, igh
lenterms=length(term_feature_igh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_igh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_igh= term_feature_igh(orderidx);

%sort unique terms according to their value, pfsh
lenterms=length(term_feature_pfsh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_pfsh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_pfsh= term_feature_pfsh(orderidx);

%sort unique terms according to their value, ginith
lenterms=length(term_feature_ginith);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ginith(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ginith= term_feature_ginith(orderidx);

%sort unique terms according to their value, ginih
lenterms=length(term_feature_ginih);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ginih(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ginih= term_feature_ginih(orderidx);

%sort unique terms according to their value, dfssh
lenterms=length(term_feature_dfssh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dfssh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dfssh= term_feature_dfssh(orderidx);

%sort unique terms according to their value, ndmh
lenterms=length(term_feature_ndmh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ndmh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ndmh= term_feature_ndmh(orderidx);

%sort unique terms according to their value, cdmh
lenterms=length(term_feature_cdmh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cdmh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cdmh= term_feature_cdmh(orderidx);

%sort unique terms according to their value, dpmh
lenterms=length(term_feature_dpmh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dpmh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dpmh= term_feature_dpmh(orderidx);

%sort unique terms according to their value, cmfsh
lenterms=length(term_feature_cmfsh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cmfsh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cmfsh= term_feature_cmfsh(orderidx);

%sort unique terms according to their value, mmrh
lenterms=length(term_feature_mmrh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mmrh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mmrh= term_feature_mmrh(orderidx);

%sort unique terms according to their value, crfh
lenterms=length(term_feature_crfh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_crfh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_crfh= term_feature_crfh(orderidx);

%sort unique terms according to their value, poissonh
lenterms=length(term_feature_poissonh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_poissonh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_poissonh= term_feature_poissonh(orderidx);

%sort unique terms according to their value, cicih
lenterms=length(term_feature_cicih);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_cicih(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_cicih= term_feature_cicih(orderidx);

%sort unique terms according to their value, gsshgsssh
lenterms=length(term_feature_gsshgsssh);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gsshgsssh(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gsshgsssh= term_feature_gsshgsssh(orderidx);



document_frequency_map=containers.Map();

for i=1:lenterms
    document_frequency_map(doc_freq_of_terms(1,i).term)=doc_freq_of_terms(1,i).value;
end


% features are already sorted by multiple feature selection methods
% save index values of features into a map

term_feature_dfs_map = containers.Map();
term_feature_gi_original_map = containers.Map();
term_feature_ig_original_map = containers.Map();
term_feature_ig_map = containers.Map();
term_feature_mi_map = containers.Map();
term_feature_chi2_original_map = containers.Map();
term_feature_poisson_map = containers.Map();
term_feature_pbweighting_map = containers.Map();
term_feature_tfrf_map = containers.Map();
term_feature_tfrr_map = containers.Map();
term_feature_pfs_map = containers.Map();
term_feature_dfss_map = containers.Map();
term_feature_ndm_map = containers.Map();
term_feature_mdfs_map = containers.Map();
term_feature_cdm_map = containers.Map();
term_feature_dpm_map = containers.Map();
term_feature_mor_map = containers.Map();
term_feature_cmfs_map = containers.Map();
term_feature_mmr_map = containers.Map();
term_feature_efs_map = containers.Map();
term_feature_cici_map = containers.Map();
term_feature_pmh_map = containers.Map();
term_feature_gss_map = containers.Map();
term_feature_gsss_map = containers.Map();

term_feature_xh_map = containers.Map();
term_feature_dfshmdfsh_map = containers.Map();
term_feature_efsh_map = containers.Map();
term_feature_sorh_map = containers.Map();
term_feature_mih_map = containers.Map();
term_feature_cch_map = containers.Map();
term_feature_igh_map = containers.Map();
term_feature_pfsh_map = containers.Map();
term_feature_ginith_map = containers.Map();
term_feature_ginih_map = containers.Map();
term_feature_dfssh_map = containers.Map();
term_feature_ndmh_map = containers.Map();
term_feature_cdmh_map = containers.Map();
term_feature_dpmh_map = containers.Map();
term_feature_cmfsh_map = containers.Map();
term_feature_mmrh_map = containers.Map();
term_feature_crfh_map = containers.Map();
term_feature_poissonh_map = containers.Map();
term_feature_cicih_map = containers.Map();
term_feature_gsshgsssh_map = containers.Map();


for i=1:lenterms
    term_feature_dfs_map(term_feature_dfs(i).term)=i;
    term_feature_gi_original_map(term_feature_gi_original(i).term)=i;
    term_feature_ig_original_map(term_feature_ig_original(i).term)=i;
    term_feature_ig_map(term_feature_ig(i).term)=i;
    term_feature_mi_map(term_feature_mi(i).term)=i;
    term_feature_chi2_original_map(term_feature_chi2_original(i).term)=i;
    term_feature_poisson_map(term_feature_poisson(i).term)=i;
    term_feature_pbweighting_map(term_feature_pbweighting(i).term)=i;
    term_feature_tfrf_map(term_feature_tfrf(i).term)=i;
    term_feature_tfrr_map(term_feature_tfrr(i).term)=i;
    term_feature_pfs_map(term_feature_pfs(i).term)=i;
    term_feature_dfss_map(term_feature_dfss(i).term)=i;
    term_feature_ndm_map(term_feature_ndm(i).term)=i;
    term_feature_mdfs_map(term_feature_mdfs(i).term)=i;
    term_feature_cdm_map(term_feature_cdm(i).term)=i; 
    term_feature_dpm_map(term_feature_dpm(i).term)=i;
    term_feature_mor_map(term_feature_dpm(i).term)=i;
    term_feature_cmfs_map(term_feature_cmfs(i).term)=i;
    term_feature_mmr_map(term_feature_mmr(i).term)=i;
    term_feature_efs_map(term_feature_efs(i).term)=i;
    term_feature_cici_map(term_feature_cici(i).term)=i;
    term_feature_pmh_map(term_feature_pmh(i).term)=i;
    term_feature_gss_map(term_feature_gss(i).term)=i;
    term_feature_gsss_map(term_feature_gsss(i).term)=i;
    
    term_feature_xh_map(term_feature_xh(i).term)=i;
term_feature_dfshmdfsh_map(term_feature_dfshmdfsh(i).term)=i;
term_feature_efsh_map(term_feature_efsh(i).term)=i;
term_feature_sorh_map(term_feature_sorh(i).term)=i;
term_feature_mih_map(term_feature_mih(i).term)=i;
term_feature_cch_map(term_feature_cch(i).term)=i;
term_feature_igh_map(term_feature_igh(i).term)=i;
term_feature_pfsh_map(term_feature_pfsh(i).term)=i;
term_feature_ginith_map(term_feature_ginith(i).term)=i;
term_feature_ginih_map(term_feature_ginih(i).term)=i;
term_feature_dfssh_map(term_feature_dfssh(i).term)=i;
term_feature_ndmh_map(term_feature_ndmh(i).term)=i;
term_feature_cdmh_map(term_feature_cdmh(i).term)=i;
term_feature_dpmh_map(term_feature_dpmh(i).term)=i;
term_feature_cmfsh_map(term_feature_cmfsh(i).term)=i;
term_feature_mmrh_map(term_feature_mmrh(i).term)=i;
term_feature_crfh_map(term_feature_crfh(i).term)=i;
term_feature_poissonh_map(term_feature_poissonh(i).term)=i;
term_feature_cicih_map(term_feature_cicih(i).term)=i;
term_feature_gsshgsssh_map(term_feature_gsshgsssh(i).term)=i;

end



destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['save ', strcat(destination_fpath,'features.mat'), '  term_feature_am_tf term_feature_dfs term_feature_phdnm_f2 term_feature_gi term_feature_ig term_feature_mi term_feature_chi2 term_feature_df term_feature_gi_original term_feature_ig_original term_feature_chi2_original term_feature_poisson term_feature_pbweighting term_feature_tfrf term_feature_tfrr term_feature_pfs term_feature_dfss term_feature_ndm term_feature_mdfs term_feature_cdm term_feature_dpm term_feature_mor term_feature_cmfs term_feature_mmr term_feature_efs term_feature_cici term_feature_pmh term_feature_gss term_feature_gsss term_feature_xh term_feature_dfshmdfsh term_feature_efsh term_feature_sorh term_feature_mih term_feature_cch term_feature_igh term_feature_pfsh term_feature_ginith term_feature_ginih term_feature_dfssh term_feature_ndmh term_feature_cdmh term_feature_dpmh term_feature_cmfsh term_feature_mmrh term_feature_crfh term_feature_poissonh term_feature_cicih term_feature_gsshgsssh;'])
eval(['save ', strcat(destination_fpath,'document_frequencies.mat'), '  doc_freq_of_terms document_frequency_map'])
eval(['save ', strcat(destination_fpath,'weighting_index_maps.mat'), '  term_feature_dfs_map term_feature_gi_original_map term_feature_ig_original_map term_feature_mi_map term_feature_ig_map term_feature_chi2_original_map term_feature_poisson_map term_feature_pbweighting_map term_feature_tfrf_map term_feature_tfrr_map term_feature_pfs_map term_feature_dfss_map term_feature_ndm_map term_feature_mdfs_map term_feature_cdm_map term_feature_dpm_map term_feature_mor_map term_feature_cmfs_map term_feature_mmr_map term_feature_efs_map term_feature_cici_map term_feature_pmh_map term_feature_gss_map term_feature_gsss_map term_feature_xh_map term_feature_dfshmdfsh_map term_feature_efsh_map term_feature_sorh_map term_feature_mih_map term_feature_cch_map term_feature_igh_map term_feature_pfsh_map term_feature_ginith_map term_feature_ginih_map term_feature_dfssh_map term_feature_ndmh_map term_feature_cdmh_map term_feature_dpmh_map term_feature_cmfsh_map term_feature_mmrh_map term_feature_crfh_map term_feature_poissonh_map term_feature_cicih_map term_feature_gsshgsssh_map;'])


end