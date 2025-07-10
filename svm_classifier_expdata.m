function [ z ] = svm_classifier_expdata(term_weighting_scheme,feature_size,feature_selection_method,dataset_type,tokenization_type,usestopwordremoval,uselowercase,usestemming)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here


% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5;
DATASET_REUTERS_PARTIAL = 6;
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



% load train_matrix train_matrix topic_matrix;
% load test_matrix test_matrix topic_matrix_for_test;
% load dataset_class_idx dataset_class_idx;
% load term_feature term_feature;
% disp('testing phase started');

destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['load ', strcat(destination_fpath,'train_matrix.mat'), '  train_matrix topic_matrix'])
eval(['load ', strcat(destination_fpath,'test_matrix.mat'), '  test_matrix topic_matrix_for_test'])
eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
eval(['load ', strcat(destination_fpath,'term_feature.mat'), '  term_feature'])%DFS DEGERLERÝ DE BUNUN ICINDE

disp('testing phase started');

train_matrix=train_matrix(:,1:feature_size);
test_matrix=test_matrix(:,1:feature_size);
term_feature=term_feature(:,1:feature_size);


%LIBSVM Matlab Wrapper for 64 bit matlab
model=svmtrain(topic_matrix,train_matrix,'-t 0'); 
%model=svmtrain(topic_matrix,train_matrix,'-s 2'); % one class svm icin

[predicted_labels, ~, ~] = svmpredict(topic_matrix_for_test, test_matrix, model);
predicted_labels = predicted_labels';


num_true_classifications=0;
num_false_classifications=0;
confusion_matrix=zeros(length(dataset_class_idx),length(dataset_class_idx));
lentest=length(test_matrix(:,1));

for i=1:lentest
    indice_of_maximum=predicted_labels(1,i);
    
    if (indice_of_maximum==topic_matrix_for_test(i,1))
        num_true_classifications=num_true_classifications+1;
        confusion_matrix(indice_of_maximum,indice_of_maximum)=confusion_matrix(indice_of_maximum,indice_of_maximum)+1;
    else
        num_false_classifications=num_false_classifications+1;
        confusion_matrix(topic_matrix_for_test(i,1),indice_of_maximum)=confusion_matrix(topic_matrix_for_test(i,1),indice_of_maximum)+1;
    end            
end




%--------------------------------------------------------------------
% Compute Micro-F1
%--------------------------------------------------------------------
 
% Compute overall true positive
tp_value = sum(diag(confusion_matrix));
 
% Compute overall false positive
fp_value = 0;

NUM_CLASS=length(dataset_class_idx);
 
for class=1:NUM_CLASS
 
   % Get index of classes except current one
   class_idx = [1:NUM_CLASS];
   class_idx(class) = [];
 
   fp_value = fp_value + sum(confusion_matrix(class_idx, class));
 
end
 
% Compute overall false negative
fn_value = 0;
 
for class=1:NUM_CLASS
 
   % Get index of classes except current one
   class_idx = [1:NUM_CLASS];
   class_idx(class) = [];
 
   fn_value = fn_value + sum(confusion_matrix(class, class_idx));
 
end
 
% Compute precision
p_value = tp_value / (tp_value + fp_value);
 
% Compute recall
r_value = tp_value / (tp_value + fn_value);
 
% Compute Micro-F1
micro_F1 = 100 * (2 * p_value * r_value) / (p_value + r_value);
 
%--------------------------------------------------------------------
% Compute Macro-F1
%--------------------------------------------------------------------
 
% Init
F1_measures = [];
 
for class=1:NUM_CLASS
 
    % Get class index except current one
    class_idx = [1:NUM_CLASS];
    class_idx(class) = [];
 
    % Compute true positive
    tp_value = confusion_matrix(class, class);
 
    % Compute false positive
    fp_value = sum(confusion_matrix(class_idx, class));
 
    % Compute false negative
    fn_value = sum(confusion_matrix(class, class_idx));
 
    % Compute precision
    p_value = tp_value / (tp_value + fp_value);
 
    % Compute recall
    r_value = tp_value / (tp_value + fn_value);
 
    % Compute current F1 measure
    curr_F1 = 100 * (2 * p_value * r_value) / (p_value + r_value);
    if isnan(curr_F1)
        curr_F1 = 0;
    end
 
    F1_measures = [F1_measures curr_F1];
 
end
 
macro_F1 = mean(F1_measures);


%precision and recall calculation end



finalresults=['final_results' '_' num2str(dataset_type) '_' num2str(feature_selection_method) '_' num2str(term_weighting_scheme) '_' num2str(tokenization_type) '_' num2str(usestopwordremoval) num2str(uselowercase) num2str(usestemming) '_' num2str(length(term_feature))];
finalmatrix=['final_matrix' '_' num2str(dataset_type) '_' num2str(feature_selection_method) '_' num2str(term_weighting_scheme) '_'  num2str(tokenization_type) '_' num2str(usestopwordremoval) num2str(uselowercase) num2str(usestemming) '_' num2str(length(term_feature))];

filename = [finalresults 'statistics' '.txt'];

finalresults = [finalresults '.mat']; 
finalmatrix = [finalmatrix '.mat']; 


if dataset_type==DATASET_REUTERS
    resfoldername='experiments_with_reuters_21578';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reutersexperiments\svm\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reutersexperiments\svm\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reutersexperiments\svm\',filename);
elseif dataset_type==DATASET_MILLIYET
    resfoldername='experiments_with_milliyet_collection';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\milliyetexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\milliyetexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\milliyetexperiments\',filename);
elseif dataset_type==DATASET_SPAMSMSTR
    resfoldername='experiments_with_spamsmstr';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamsmstrexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamsmstrexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamsmstrexperiments\',filename);
elseif dataset_type==DATASET_REUTERS_PARTIAL
    resfoldername='experiments_with_reuters_partial';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reuterspartialexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reuterspartialexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\reuterspartialexperiments\',filename);
elseif dataset_type==DATASET_WEBKB
    resfoldername='experiments_with_webkb';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\webkbexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\webkbexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\webkbexperiments\',filename);    
elseif dataset_type==DATASET_BRITISHENGLISHSPAMSMS
    resfoldername='experiments_with_britishenglishspamsms';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\britishenglishspamsmsexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\britishenglishspamsmsexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\britishenglishspamsmsexperiments\',filename); 
elseif dataset_type==DATASET_SPAMEMAILTR
    resfoldername='experiments_with_spamemailtr';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailtrexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailtrexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailtrexperiments\',filename);  
elseif dataset_type==DATASET_ENRON1_PARTIAL
    resfoldername='experiments_with_spamemailenronpartial';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailenronpartialexperiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailenronpartialexperiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\spamemailenronpartialexperiments\',filename);
elseif dataset_type==DATASET_CLASSIC3
    resfoldername='experiments_with_classic3';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\classic3experiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\classic3experiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\classic3experiments\',filename);
elseif dataset_type==DATASET_NEWS10
    resfoldername='experiments_with_news10';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news10experiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news10experiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news10experiments\',filename);    
elseif dataset_type==DATASET_NEWS20
    resfoldername='experiments_with_news20';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news20experiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news20experiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\news20experiments\',filename);
elseif dataset_type==DATASET_MININEWS20
    resfoldername='experiments_with_mininews20';
    finalresults=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\mininews20experiments\',finalresults);
    finalmatrix=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\mininews20experiments\',finalmatrix);
    filename=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\mininews20experiments\',filename);  
elseif dataset_type==DATASET_OHSUMED_SINGLELABEL_VERSION
    resfoldername='experiments_with_ohsumed_singlelabel';
    finalresults=strcat('ohsumed_singlelabelexperiments\',finalresults);
    finalmatrix=strcat('ohsumed_singlelabelexperiments\',finalmatrix);
    filename=strcat('ohsumed_singlelabelexperiments\',filename);
elseif dataset_type==DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_engabstract_singlelabel';
    finalresults=strcat('medlinetr_engabstract_singlelabelexperiments\',finalresults);
    finalmatrix=strcat('medlinetr_engabstract_singlelabelexperiments\',finalmatrix);
    filename=strcat('medlinetr_engabstract_singlelabelexperiments\',filename);    
elseif dataset_type==DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_trabstract_singlelabel';
    finalresults=strcat('medlinetr_trabstract_singlelabelexperiments\',finalresults);
    finalmatrix=strcat('medlinetr_trabstract_singlelabelexperiments\',finalmatrix);
    filename=strcat('medlinetr_trabstract_singlelabelexperiments\',filename);     
elseif dataset_type==DATASET_ENRON1
    resfoldername='experiments_with_enron1';
    finalresults=strcat('enron1experiments\',finalresults);
    finalmatrix=strcat('enron1experiments\',finalmatrix);
    filename=strcat('enron1experiments\',filename); 
elseif dataset_type==DATASET_REUTERS_TOP15
    resfoldername='experiments_with_reuters_top15';
    finalresults=strcat('reuterstop15experiments\',finalresults);
    finalmatrix=strcat('reuterstop15experiments\',finalmatrix);
    filename=strcat('reuterstop15experiments\',filename);     
elseif dataset_type==DATASET_REUTERS_TOP20
    resfoldername='experiments_with_reuters_top20';
    finalresults=strcat('reuterstop20experiments\',finalresults);
    finalmatrix=strcat('reuterstop20experiments\',finalmatrix);
    filename=strcat('reuterstop20experiments\',filename);         
elseif dataset_type==DATASET_CATDOG
    resfoldername='experiments_with_catdog';
    finalresults=strcat('catdogexperiments\',finalresults);
    finalmatrix=strcat('catdogexperiments\',finalmatrix);
    filename=strcat('catdogexperiments\',filename);         
elseif dataset_type==DATASET_REUTERS_FOLDERS
    resfoldername='experiments_with_reuters_folders';
    finalresults=strcat('reutersfoldersexperiments\',finalresults);
    finalmatrix=strcat('reutersfoldersexperiments\',finalmatrix);
    filename=strcat('reutersfoldersexperiments\',filename);         
elseif dataset_type==DATASET_REUTERS_FOLDERS_ALL
    resfoldername='experiments_with_reuters_folders_all';
    finalresults=strcat('reutersfoldersallexperiments\',finalresults);
    finalmatrix=strcat('reutersfoldersallexperiments\',finalmatrix);
    filename=strcat('reutersfoldersallexperiments\',filename);         
elseif dataset_type==DATASET_SPAM
    resfoldername='experiments_with_spam';
    finalresults=strcat('spamexperiments\svm\',finalresults);
    finalmatrix=strcat('spamexperiments\svm\',finalmatrix);
    filename=strcat('spamexperiments\svm\',filename);         
elseif dataset_type==DATASET_NEWS2C
    resfoldername='experiments_with_news2c';
    finalresults=strcat('news2cexperiments\',finalresults);
    finalmatrix=strcat('news2cexperiments\',finalmatrix);
    filename=strcat('news2cexperiments\',filename);         
end        

fid_stat = fopen(filename, 'w');

accuracy=num_true_classifications/(num_true_classifications+num_false_classifications);
%save finalresults num_true_classifications num_false_classifications accuracy confusion_matrix predicted_labels;


%save finalmatrix train_matrix test_matrix term_feature;

eval(['save ', finalresults, '  num_true_classifications num_false_classifications accuracy confusion_matrix predicted_labels'])
eval(['save ', finalmatrix, '  train_matrix test_matrix term_feature'])


% File header
fprintf(fid_stat, '======================================================\r\n');
fprintf(fid_stat, 'TEXT DATASET STATS\r\n');
fprintf(fid_stat, '======================================================\r\n');

fprintf(fid_stat,'FSMethod:%d \r\n FCount:%d \r\n FSize:%d \r\n TClassification:%d \r\n FClassification:%d \r\n MicroF1:%6.3f \r\n MacroF1:%6.3f\r\n',feature_selection_method,length(term_feature),feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);

fprintf(fid_stat, '\r\nCONFUSION MATRIX\r\n');
fprintf(fid_stat, '------------------------------------------------------\r\n\r\n');

for idx=1:NUM_CLASS
    for idy=1:NUM_CLASS
        fprintf(fid_stat, '%d\t', confusion_matrix(idy,idx));
    end
    fprintf(fid_stat, '\r\n');
end

fprintf(fid_stat, '\r\n F MEASURE VALUES (CATEGORY BASED) \r\n');
fprintf(fid_stat, '------------------------------------------------------\r\n\r\n');

for i=1:NUM_CLASS
    fprintf(fid_stat, '%6.3f', F1_measures(i));
    fprintf(fid_stat, '\r\n');
end

fprintf(fid_stat, '\r\nFEATURE LIST TERMS\r\n');

for idx=1:length(term_feature)    
    fprintf(fid_stat, '%s \t ', char(term_feature(1,idx)));
    if mod(idx,10)==0
        fprintf(fid_stat, '\r\n');
    end
end

fclose(fid_stat);


result_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\svmres.txt');


fresid = fopen(result_fpath, 'a');
fprintf(fresid,'%d %d %d %d %d %d %d %d %d %d %6.3f %6.3f\n',term_weighting_scheme,feature_selection_method,length(term_feature),tokenization_type, usestopwordremoval,uselowercase,usestemming,feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);
fclose(fresid);

destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\','overall_result_table.mat');
eval(['save ', destination_fpath, '  micro_F1 p_value r_value macro_F1'])

end