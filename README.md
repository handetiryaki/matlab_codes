# matlab_codes
fsm experiments

%classifier_script_expdata is the starter function. 

%function [ z ] = classifier_script_expdata(dataset_type,isterm_extraction_done,tokenization_type,usestopwordremoval, uselowercase, usestemming)

%EXTERNAL PROGRAM IMPORTANT PARAMETERS

%-----------------------%
% DATASET_REUTERS = 1;
% DATASET_MILLIYET = 2;
% DATASET_NEWS10 = 3;
% DATASET_NEWS20 = 4;
% DATASET_SPAMSMSTR = 5;
% DATASET_REUTERS_PARTIAL = 6;
% DATASET_WEBKB = 9;
% DATASET_ENRON1 = 10;
% DATASET_BRITISHENGLISHSPAMSMS = 11;
% DATASET_SPAMEMAILTR = 12;
% DATASET_ENRON1_PARTIAL = 13;
% DATASET_CLASSIC3 = 14;
% DATASET_OHSUMED_SINGLELABEL_VERSION = 17;
% DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION = 18;
% DATASET_MININEWS20 = 19;
% DATASET_REUTERS_TOP15 = 21;
% DATASET_REUTERS_TOP20 = 22;
% DATASET_CATDOG = 23;
% DATASET_REUTERS_FOLDERS = 24;
% DATASET_REUTERS_FOLDERS_ALL = 25;
% DATASET_SPAM = 26;
% DATASET_NEWS2C = 27;

% param2(isterm_extraction_done)
%-----------------------%
% isterm_extraction_done = 0 (skip feature extraction, features are already extracted)
% isterm_extraction_done = 1 (extract features)


% param3(tokenization_type)
%-----------------------%
%tokenization_type=0; (alphanumeric - keep letters and numbers)
%tokenization_type=1; (alphabetic - (keep letters only)

% param4(usestopwordremoval)
%-----------------------%
% usestopwordremoval=0; (Skip this process)
% usestopwordremoval=1; (Remove stopwords)


% param5(uselowercase)
%-----------------------%
% uselowercase=0; (Skip this process)
% uselowercase=1; (convert to lowercase)

% param6(usestemming)
%-----------------------%
% usestemming=0; (Skip this process)
% usestemming=1; (make stemming)

% function parameters for analysis

% param(term_weighting_scheme)
%-----------------------%
% term_weighting_scheme=0 (BINARY)
% term_weighting_scheme=1 (TF)
% term_weighting_scheme=2 (TF-IDF)
% term_weighting_scheme=3 (TF-IG)
% term_weighting_scheme=4 (TF-MI)
% term_weighting_scheme=5 (TF-AMB_MEASURE)
% term_weighting_scheme=7 (TF-DFS)
% term_weighting_scheme=9 (TF-GI_orj)
% term_weighting_scheme=10 (TF-IG_orj)
% term_weighting_scheme=11 (TF-CHI2)
% term_weighting_scheme=12 (TF-POISSON)
% term_weighting_scheme=13 (TF-PROBABILITY BASED WEIGHT)
% term_weighting_scheme=14 (TF-RF)
% term_weighting_scheme=15 (LOG TF-RF)
% term_weighting_scheme=16 (LOG TF-RR)
% term_weighting_scheme=17 (TF-PFS)
% term_weighting_scheme=18 (TF-DFSS)
% term_weighting_scheme=19 (TF-NDM)
% term_weighting_scheme=20 (TF-MDFS)
% term_weighting_scheme=21 (TF-CDM)
% term_weighting_scheme=22 (TF-DPM)
% term_weighting_scheme=23 (TF-CMFS)
% term_weighting_scheme=24 (TF-MMR)
% term_weighting_scheme=25 (TF-EFS)
% term_weighting_scheme=26 (TF-CICI)
% term_weighting_scheme=27 (TF-PMH)
% term_weighting_scheme=28 (TF-GSS)
% term_weighting_scheme=29 (TF-GSSS)

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



% MDFS 20
% CDM 21
% DPM 22
% CMFS 23
% MMR 24
% EFS 25
% CICI 26
% PMH 27
% GSS 28
% GSSS 29

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

%feature_count=[50,100,300,500,1000,3000,5000];

%CLASSIFIER FUNCTIONS
%dtree_classifier_expdata.m
%knn_classifier_expdata.m
%mv_naivebayes_classifier_expdata.m
%roccio.m
%roccio_classifier_expdata.m
%svm_classifier_expdata.m



%SAMPLE CODE

function [ z ] = classifier_script_expdata(dataset_type,isterm_extraction_done,tokenization_type,usestopwordremoval, uselowercase, usestemming)

pr_fe_text_high_speed(dataset_type,isterm_extraction_done,tokenization_type,usestopwordremoval,uselowercase,usestemming);
custom_precalculations(dataset_type);

	for m=1:length(feature_count)
		for j=19:-1:7 % feature selection method
			for k=1:length(term_weighting_scheme)

data_matrix_construction_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,1,tokenization_type,usestopwordremoval,uselowercase, usestemming);
            data_matrix_construction_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,2,tokenization_type,usestopwordremoval,uselowercase, usestemming);
            for i=1:length(feature_count)
				svm_classifier_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming);
				knn_classifier_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming);
                dtree_classifier_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming);
                mv_naivebayes_classifier_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming);
                roccio_classifier_expdata(term_weighting_scheme(k),feature_count(m),j,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming);
				end
			end 
		end 
	end
	
	
	
	
	
