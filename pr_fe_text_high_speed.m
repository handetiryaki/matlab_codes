%===================================================================
% Feature Extraction for Text
%===================================================================
function pr_fe_text_high_speed(dataset,issamedataset,tokenization_type,usestopwordremoval,uselowercase, usestemming)


%clc
%clear all

disp('Starting feature extraction of texts...');

% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5;
DATASET_REUTERS_PARTIAL = 6; 
DATASET_NEWS3=7;
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


% -----------------------------------------------------------------
% Define state: 0 or 1
% -----------------------------------------------------------------
train_set = 1;

% Set dataset type
dataset_type = dataset;

% Pre-Item List (used in term defining)
global term_list_pre;
global term_existence_map;
global stopword_list_map;
global destination_fpath;
global resfoldername;

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
    resfoldername='experiments_with_folders';
elseif dataset_type==DATASET_REUTERS_FOLDERS_ALL
    resfoldername='experiments_with_reuters_folders_all';
elseif dataset_type==DATASET_SPAM
    resfoldername='experiments_with_spam';
elseif dataset_type==DATASET_NEWS2C
    resfoldername='experiments_with_news2c';
end



destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');



term_list_pre   = struct('CLASS', {}, 'NAME', {},'FREQ', {}, 'MUTUAL_INFO', {}, 'CHI2', {}, 'IG', {},'IG_FOR_TERM', {},'GINI_INDEX', {}, 'GINI_INDEX_FOR_TERM', {},'DFS', {},'PHD_NM_F2', {},'POISSON', {},'AM_TF', {},'MOR', {},'PB_TERM_WEIGHT',{},'TF_RF', {},'TF_RR', {},'DF', {}, 'APPEARANCE', {}, 'MARKED', {}, 'PFS', {}, 'DFSS', {}, 'NDM', {}, 'MDFS', {}, 'CDM', {}, 'DPM', {}, 'CMFS', {}, 'MMR', {}, 'EFS', {}, 'CICI', {},'PMH', {},'GSS', {}, 'GSSS', {},'XH', {}, 'DFSHMDFSH', {}, 'EFSH', {}, 'SORH', {}, 'MIH', {}, 'CCH', {}, 'IGH', {}, 'PFSH', {}, 'GINITH', {}, 'GINIH', {}, 'DFSSH', {}, 'NDMH', {}, 'CDMH', {}, 'DPMH', {}, 'CMFSH', {}, 'MMRH', {}, 'CRFH', {}, 'POISSONH', {}, 'CICIH', {}, 'GSSHGSSSH', {});
term_existence_map = containers.Map();

if (dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS3 || dataset_type == DATASET_MININEWS20)
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

elseif dataset_type == DATASET_NEWS20
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
 elseif dataset_type == DATASET_NEWS2C
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
elseif (dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL)
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
elseif (dataset_type == DATASET_REUTERS_FOLDERS)
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
elseif (dataset_type == DATASET_REUTERS_FOLDERS_ALL)
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
elseif dataset_type == DATASET_SPAMSMSTR 
    % Stopword list
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end        
elseif dataset_type == DATASET_SPAMSMSENG
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
 elseif dataset_type == DATASET_SPAMEMAILTR 
    % Stopword list
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end        
elseif dataset_type == DATASET_WEBKB
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
elseif dataset_type == DATASET_OHSUMED_SINGLELABEL_VERSION
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end  

elseif dataset_type == DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end     
elseif dataset_type == DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION
    
    % Stopword list
    stopword_list={'a','acaba','altý','ama','ancak','artýk','asla','aslýnda','az','b','bana','bazen','bazý','bazýlarý','bazýsý','belki','ben','beni','benim','beþ','bile','bir','birçoðu','birçok','birçoklarý','biri','birisi','birkaç','birkaçý','birþey','birþeyi','biz','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunu','bunun','burada','bütün','c','ç','çoðu','çoðuna','çoðunu','çok','çünkü','d','da','daha','de','deðil','demek','diðer','diðeri','diðerleri','diye','dokuz','dolayý','dört','e','elbette','en','f','fakat','falan','felan','filan','g','gene','gibi','ð','h','hâlâ','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','hepsine','hepsini','her','her biri','herkes','herkese','herkesi','hiç','hiç kimse','hiçbiri','hiçbirine','hiçbirini','ý','i','için','içinde','iki','ile','ise','iþte','j','k','kaç','kadar','kendi','kendine','kendini','ki','kim','kime','kimi','kimin','kimisi','l','m','madem','mý','mý','mi','mu','mu','mü','mü','n','nasýl','ne','ne kadar','ne zaman','neden','nedir','nerde','nerede','nereden','nereye','nesi','neyse','niçin','niye','o','on','ona','ondan','onlar','onlara','onlardan','onlarýn','onlarýn','onu','onun','orada','oysa','oysaki','ö','öbürü','ön','önce','ötürü','öyle','p','r','raðmen','s','sana','sekiz','sen','senden','seni','senin','siz','sizden','size','sizi','sizin','son','sonra','þ','þayet','þey','þeyden','þeye','þeyi','þeyler','þimdi','þöyle','þu','þuna','þunda','þundan','þunlar','þunu','þunun','t','tabi','tamam','tüm','tümü','u','ü','üç','üzere','v','var','ve','veya','veyahut','y','ya','ya da','yani','yedi','yerine','yine','yoksa','z','zaten','zira'};
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end      
        
    
elseif dataset_type == DATASET_CLASSIC3
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end    
elseif dataset_type == DATASET_BRITISHENGLISHSPAMSMS 
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'afloor', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end    
 elseif dataset_type == DATASET_SPAM
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'afloor', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end    
elseif dataset_type == DATASET_ENRON1
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end 
 elseif dataset_type == DATASET_ENRON1_PARTIAL 
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'parular', 'parularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end    
end


% Define dataset topics
global dataset_topics;
if dataset_type == DATASET_NEWS10

    % Original list
    %dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball'};
     %minor-major
    dataset_topics = { 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware'};   
    
    % Custom List
    %dataset_topics = {'alt.atheism'};
 
elseif dataset_type == DATASET_NEWS3

    % Original list
    dataset_topics = {'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x'};

    % Custom List
    %dataset_topics = {'alt.atheism'};
    
elseif dataset_type == DATASET_MININEWS20
    
    % Original list
    dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.polis.guns', 'talk.polis.mideast', 'talk.polis.misc', 'talk.religion.misc'};

    % Custom List
    %dataset_topics = {'alt.atheism'}; 

elseif dataset_type == DATASET_NEWS20

    % Original list
    %dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.politics.guns', 'talk.politics.mideast', 'talk.politics.misc', 'talk.religion.misc'};
    
    %major-minor
    dataset_topics = {'talk.politics.guns','talk.politics.mideast'};
    
    % Custom List
    %dataset_topics = {'alt.atheism'};

elseif (dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL)

    % Original Top-10 list
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
    % Custom List
    %dataset_topics = {'wheat', 'corn'};
     %major-minor pfs makale test
    %dataset_topics = {'ship', 'acq'};
    
elseif dataset_type == DATASET_REUTERS_FOLDERS

  dataset_topics = {'acq','earn', 'grain','money-fx'};
  
elseif dataset_type == DATASET_REUTERS_FOLDERS_ALL

  dataset_topics = {'acq', 'coffee', 'crude', 'earn', 'grain','interest','money-fx', 'ship', 'sugar', 'trade'};

elseif dataset_type == DATASET_REUTERS_TOP15
    % Original Top-15 list
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn', 'dlr', 'oilseed', 'money-supply', 'sugar', 'gnp'};
    %major-minor
    %dataset_topics = {'earn', 'gnp'};
    
elseif dataset_type == DATASET_REUTERS_TOP20
    % Original Top-20 list
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn', 'dlr', 'oilseed', 'money-supply', 'sugar', 'gnp', 'coffee', 'veg-oil', 'gold', 'nat-gas', 'soybean'};
    %major-minor
    %dataset_topics = {'earn', 'nat-gas'};
    
elseif dataset_type == DATASET_MILLIYET

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'astro', 'dunya', 'ekonomi', 'magazin', 'sanat', 'siyaset', 'spor', 'tv', 'yasam'};
elseif dataset_type == DATASET_SPAMSMSTR

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_SPAMSMSENG

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_WEBKB

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    %dataset_topics = {'course', 'faculty', 'project', 'student'};
    dataset_topics = {'project', 'student'};
elseif dataset_type == DATASET_CLASSIC3
    dataset_topics = {'cisi', 'med'};
    %dataset_topics = {'cisi', 'cran', 'med'};
elseif dataset_type == DATASET_OHSUMED_SINGLELABEL_VERSION
    %dataset_topics = {'C05', 'C08', 'C14', 'C15'};vers1
    %dataset_topics = {'C12', 'C16', 'C19', 'C22'};vers2
    %dataset_topics = {'C01', 'C04', 'C05', 'C23'};%vers3
    %dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18','C19', 'C20', 'C21', 'C22', 'C23'};
    dataset_topics = {'C14', 'C22'};%top10 
elseif dataset_type == DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION 
    %12 categories (v5.1)
    dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08','C09', 'C10', 'C14', 'C23'};
elseif dataset_type == DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION   
    %12 categories (v5.1)
    dataset_topics = {'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08','C09', 'C10', 'C14', 'C23'};      
elseif dataset_type == DATASET_SPAMSMSENG

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_BRITISHENGLISHSPAMSMS
    dataset_topics = {'spam', 'legitimate'}; 
elseif dataset_type == DATASET_SPAM
    dataset_topics = {'legitimate', 'spam',};   
elseif dataset_type == DATASET_SPAMEMAILTR
    dataset_topics = {'spam', 'legitimate'};     
elseif dataset_type == DATASET_ENRON1

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'ham'};
    
elseif dataset_type == DATASET_MININEWS20
    % Original list 20 category
    dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.polis.guns', 'talk.polis.mideast', 'talk.polis.misc', 'talk.religion.misc'};    
elseif dataset_type == DATASET_ENRON1_PARTIAL
    dataset_topics = {'spam', 'legitimate'};    
elseif dataset_type == DATASET_CATDOG
    dataset_topics = {'C1', 'C2', 'C3'}; 

end


destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['save ', strcat(destination_fpath,'stopword_list_map.mat'), '  stopword_list_map'])


% Init dataset
global NUM_CLASS;
NUM_CLASS=length(dataset_topics);

global dataset_class_idx;
dataset_class_idx = zeros(1, NUM_CLASS);

% Initializations
topic_cnt = 0;


% Process the selected dataset
if (dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS20 || dataset_type == DATASET_NEWS3)

    if (issamedataset==1)
        
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
%         % Define start/stop index
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
%  if curr_class == 1
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end
    

    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
    
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
  elseif dataset_type == DATASET_NEWS2C
       
    if (issamedataset==1)
    
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end
    

    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
    
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    
elseif dataset_type == DATASET_SPAMSMSTR
              

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\spamsms\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
          

        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;
        
        
        % Start processing files
        for idx=1:num_files
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
                    process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);

                    % Increment feature count for current class.
                    dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                end
 
        end
        
    end    

elseif dataset_type == DATASET_SPAMEMAILTR
    
    
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\spamemail\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        

        start_idx=floor(0.7*num_files)+1;
        stop_idx=num_files;
        
      
                
        
        % Start processing files
        for idx=1:num_files
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
            process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
    end    
elseif dataset_type == DATASET_ENRON1_PARTIAL
    
    
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\spamemail\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        %start_idx = 1;
        %stop_idx = num_files;
        
        train_set_ratio = 0.7;

        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;

        
        pat = '<[^>]*>';          
        
        % Start processing files
        for idx=1:num_files
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
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end   
            
           
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
    end     
    
 elseif dataset_type == DATASET_ENRON1

    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    train_set_ratio=0.7;
    
    if issamedataset==1

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\enron1\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        % Define start/stop index
        if train_set == 1
            start_idx = 1;          
            stop_idx=floor(num_files*train_set_ratio);           
        elseif train_set == 2
            start_idx = floor(num_files*train_set_ratio)+1;
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
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------
            %curr_text
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end  
    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
    
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    

elseif dataset_type == DATASET_OHSUMED_SINGLELABEL_VERSION %OHSUMED DATASET
    
    
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\ohsumed\all-docs-singlelabel\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
       %vers3 -------------------- 
%        if curr_class == 1 
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
        %vers3 -------------------- 
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

        
%          train_set_ratio = 0.7;
% 
%          start_idx=floor(train_set_ratio*num_files)+1;
%          stop_idx=num_files;
%         
%         
%         %pat = '<[^>]*>';          
%         
%         % Start processing files
%         for idx=1:num_files
%            if (idx<start_idx || idx >stop_idx)
%                                
%             % Display topic count for tracking
%             topic_cnt = topic_cnt + 1;
%             if (mod(topic_cnt, 1000) == 0)
%                 disp(topic_cnt);
%             end
%             
%             % Open current file
%             file_path = [class_path '\' dir_data(idx + 2).name];
%             curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
%           
%             % Init current text
%             curr_text = [];
%            
%            
%             
%             while 1
%                 curr_line = fgets(curr_fid);
%                 
%                 % If EOF is encountered, finish process and close file
%                 if curr_line < 0
%                     fclose(curr_fid);
%                     break;
%                 end
%                 
%                 % Add current line to curr_text
%                 curr_text = [curr_text curr_line];
%                 
%             end   
%             
   
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
   

elseif dataset_type == DATASET_MININEWS20 %20 MINI NEWSGROUPS DATASET
        
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\mini_news20\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        
        train_set_ratio = 0.7;
        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;
           
        
        % Start processing files
        for idx=1:num_files
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
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end   
             
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
    end 
    
     %% CAT DOG DATASET %%
    
elseif dataset_type == DATASET_CATDOG %MINI CATDOG DATASET

   for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\experimentaldata\catdogfish2\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        %train_set_ratio = 1.0;
        train_set_ratio = 0.7;
        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;
           
        
        % Start processing files
        for idx=1:num_files
           if (idx<start_idx || idx >stop_idx)
                               
            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 3) == 0)
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
   end    
     


elseif dataset_type == DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION %MEDLINETR ENGLISH ABSTRACTS DATASET
    
    
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\medlinetr_engabstract\all_docs_v5_1_english\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        train_set_ratio = 0.7;

        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;
        
        
        % Start processing files
        for idx=1:num_files
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
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end   
     
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
    end    
    
elseif dataset_type == DATASET_MEDLINETR_TRABSTRACT_SINGLELABEL_VERSION %MEDLINETR ENGLISH ABSTRACTS DATASET
    
    
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\turkish\medlinetr_engabstract\all_docs_v5_1_turkish\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
               

         start_idx=floor(0.7*num_files)+1;
         stop_idx=num_files;
 
        
        
        %pat = '<[^>]*>';          
        
        % Start processing files
        for idx=1:num_files
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
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end   
                
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
        
    end        
    
    
elseif dataset_type == DATASET_CLASSIC3 %CLASSIC3 DATASET
    
    
   for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\classic3_full\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
                

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
      
        
%         % Start processing files
%         for idx=1:num_files
%            if (idx<start_idx || idx >stop_idx)
%                                
%             % Display topic count for tracking
%             topic_cnt = topic_cnt + 1;
%             if (mod(topic_cnt, 1000) == 0)
%                 disp(topic_cnt);
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
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end   
              
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------            
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
    
elseif dataset_type == DATASET_BRITISHENGLISHSPAMSMS
    
      

    for curr_class=1:length(dataset_topics)
           
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\spamsms\britishenglishdata\' char(dataset_topics(curr_class)) '.txt'];      
        
        curr_fid = fopen(class_path, 'r', 'n', 'UTF-8');
        file = textscan(curr_fid, '%s', 'delimiter', '\n','whitespace', '');
        fclose(curr_fid);
        lines = file{1};
        num_files=length(lines);
        

        train_set_ratio = 0.7;
        
        start_idx=floor(train_set_ratio*num_files)+1;
        stop_idx=num_files;
                            
        
        curr_fid = fopen(class_path, 'r', 'n', 'UTF-8');
        idx=1;
        while 1
                curr_line = fgets(curr_fid);

                if curr_line<0
                    fclose(curr_fid);
                    break;
                end

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
                    process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);

                    % Increment feature count for current class.
                    dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                end
            idx=idx+1;
            
        end                     
        
    end     
 elseif dataset_type == DATASET_SPAM %4827 legitimate, 747 spam
   
    
    dataset_topics = {'legitimate', 'spam'};
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
        class_path = ['C:\datasets\text\english\spamsms\' char(dataset_topics(curr_class))];
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

%for all topics
        
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
%         
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
%             
%             result=process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text,term_feature);
%             
%             if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
%                     train_matrix=[train_matrix;result];
%                     topic_matrix=[topic_matrix;curr_class];                                                             
%             else%prepare test matrix within test documents
%                     test_matrix=[test_matrix;result];
%                     topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
%             end
%             
%         end
%         
%     end   
% -----------------------------------------------------------------
                    % Process current text
                    % -----------------------------------------------------------------
                    % curr_line
                    process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);

                    % Increment feature count for current class.
                    dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                end
            idx=idx+1;
            
        end                     
       
elseif (dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_TOP15 || dataset_type == DATASET_REUTERS_TOP20)
    
    
    if (issamedataset==1)
    
    for cnt=1:22
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        fpath=['C:\DATASETS\TEXT\ENGLISH\reuters-21578\reut2-' file_name '.sgm'];
        %fid = fopen(fpath, 'r','UTF-8');
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
                                    
                                end                                                               
                                
                                % -----------------------------------------------------------------
                                % Process current text
                                % -----------------------------------------------------------------
                                process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
                                
                                % Increment feature count for current class.
                                dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                                
                            end
                        end
                    end
            end
        end
        
        % Close file
        fclose(fid);
        
    end
    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
    
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    
elseif dataset_type == DATASET_REUTERS_FOLDERS %DATASET DIVIDED INTO FOLDERS TRAIN TEST 
    
    if (issamedataset==1)
   
 
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
                    if (mod(topic_cnt, 10) == 0)
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;	
						                                                              
                end    
			else%prepare test matrix within test documents
                for idx=start_idx_test:stop_idx_test          
				  % Display topic count for tracking
                    topic_cnt = topic_cnt + 1;
                    if (mod(topic_cnt, 10) == 0)
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
                    end
						   
					                                    
                 end
 end
 
     term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
   
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    
    elseif dataset_type == DATASET_REUTERS_FOLDERS_ALL %DATASET DIVIDED INTO FOLDERS TRAIN TEST TOGETHER
    
      
 
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           end
        end
                    
                    
					
elseif dataset_type == DATASET_WEBKB %WEBKB 4 UNIVERSITY DATASET
    
    if (issamedataset==1)
    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['C:\datasets\text\english\webkb_4category\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        %start_idx = 1;
        %stop_idx = num_files;
        
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
            stop_idx = 352;
            elseif train_set == 2
            start_idx = 353;
            stop_idx = num_files;
            end
        elseif curr_class == 2 
            if train_set == 1
            start_idx = 1;
            stop_idx = 1148;
            elseif train_set == 2
            start_idx = 1149;
            stop_idx = num_files;
            end
%         elseif curr_class == 3
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 82;
%             elseif train_set == 2
%             start_idx = 83;
%             stop_idx = 164;
%             end
%         elseif curr_class == 4
%             if train_set == 1
%             start_idx = 1;
%             stop_idx = 820;
%             elseif train_set == 2
%             start_idx = 821;
%             stop_idx = num_files;
%             end
        end
        
        
        pat = '<[^>]*>';     
        
         % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 100) == 0)
                disp(topic_cnt);
            end
      
%         % Start processing files
%         for idx=1:num_files
%            if (idx<start_idx || idx >stop_idx)
%                                
%             % Display topic count for tracking
%             topic_cnt = topic_cnt + 1;
%             if (mod(topic_cnt, 100) == 0)
%                 disp(topic_cnt);
%             end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r', 'n', 'UTF-8');
          
            % Init current text
            curr_text = [];
           
%             %remove header of email
%             strlen=-1;
%             while strlen~=0
%                 tmp_line = fgets(curr_fid);
%                 tmp_line = strtrim(tmp_line);
%                 strlen=length(tmp_line);                
%             end   
           
            
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
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
           
        end
        
    end     
    
    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
   
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end

 elseif dataset_type == DATASET_REUTERS_PARTIAL
    
    
    if (issamedataset==1)
    
    for cnt=1:6
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        fpath=['C:\datasets\text\experimentaldata\mullass\reuters-21578-partial-1\reut2-' file_name '.sgm'];
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
                                    
                                end                                                               
                                
                                % -----------------------------------------------------------------
                                % Process current text
                                % -----------------------------------------------------------------
                                process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);
                                
                                % Increment feature count for current class.
                                dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                                
                            end
                        end
                    end
            end
        end
        
        % Close file
        fclose(fid);

        
    end
    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])   
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    
    

    
elseif dataset_type == DATASET_SPAMSMSENG
    
    
    if (issamedataset==1)        
       
        
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
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------
            process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class);

            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1; 
        end
        % Close file
        fclose(fid);                       
                            
                        
                    
        


        
    term_list_pre_unique_without_calculations=term_list_pre;
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
    
    
    
    else%if terms are already extracted, just load terms from .mat file
        destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
        eval(['load ', strcat(destination_fpath,'term_list_pre_unique_without_calculations.mat'), '  term_list_pre_unique_without_calculations'])
        eval(['load ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])
        eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
        term_list_pre=term_list_pre_unique_without_calculations;
        eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
        NUM_CLASS=length(dataset_class_idx);
    end
    
    
end


    % Save terms and phrases
    destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
    eval(['save ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

    
    % Compute mutual information of terms
    
    disp('Computing mutual information...');
    mutual_info;    
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])


    % Compute chi2 values of terms
    
    disp('Computing chi2 value...');
    chi2;

    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

    
    % Compute phd novel method formula 1 values of terms
    
    disp('Computing phd novel method formula 1 value...');
    dfs;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

    
    % Compute phd novel method formula 2 values of terms
    
    disp('Computing phd novel method formula 2 value...');
    phd_novel_method_f2;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    % Compute index values of terms
    
    disp('Computing gini index value...');
    gini_index;    
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute gini index for term values
    
    disp('Computing gini index for term value...');
    gini_index_for_term;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
     disp('Computing AM value according to TF...');
     ambiguity_measure_tf; 
       
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    disp('Computing MOR value...');
    mullass_odds_ratio;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    disp('Computing PROBABILITY BASED value...');
    probability_based_term_weighting;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    
    disp('Computing TF-RF value...');
    TFRF_term_weighting;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    disp('Computing TF-RR value...');
    TFRR_term_weighting;

    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    % Compute information gain values of terms
    
    disp('Computing IG value...');
    info_gain;    
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute information gain for term values
    
    disp('Computing information gain for term value...');
    info_gain_for_term;
    
        % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute poisson distribution for term values
    
    disp('Computing poisson distribution for term value...');
    poisson_distribution;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    
    disp('Computing Document Frequency value...');
    document_frequency;
        
       
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute DFSS values of terms
    
    disp('Computing dfss value...');
    dfss;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
 
    
    % Compute PFS values of terms
    
    disp('Computing pfs value...');
    pfs;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute NDM values of terms
    
    disp('Computing NDM value...');
    ndm;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute MDFS values of terms
    
    disp('Computing MDFS value...');
    mdfs;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
     % Compute CDM values of terms
    
    disp('Computing CDM value...');
    cdm;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
 
     % Compute DPM values of terms
    
    disp('Computing DPM value...');
    dpm;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
     % Compute CMFS values of terms
    
    disp('Computing CMFS value...');
    cmfs;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
     % Compute MMR values of terms
    
    disp('Computing MMR value...')
    mmr;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
     % Compute EFS values of terms
    
    disp('Computing EFS value...');
    efs;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute CICI values of terms
    
    disp('Computing CICI value...');
    cici;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute PMH values of terms
    
    disp('Computing PMH value...');
    pmh;
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute GSS values of terms
    
    disp('Computing GSS value...');
    gss;% simple version of Chi-square method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute GSSS values of terms
    
    disp('Computing GSSS value...');
    gsss; % square of GSS method 
    
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

    % Compute XH values of terms
    
    disp('Computing XH value...');
    xh;% transformed version of Chi-square method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute DFSHMDFSH values of terms
    
    disp('Computing DFSHMDFSH value...');
    dfshmdfsh; % transformed version of DFS and MDFS method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute EFSH values of terms
    
    disp('Computing EFSH value...');
    efsh;% transformed version of EFS method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute SORH values of terms
    
    disp('Computing SORH value...');
    sorh; % transformed version of OR method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
 
   % Compute MIH values of terms
    
    disp('Computing MIH value...');
    mih;% transformed version of Mutual Info method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute CCH values of terms
    
    disp('Computing CCH value...');
    cch; % transformed version of Correlation Coeffient method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute IGH values of terms
    
    disp('Computing IGH value...');
    igh;% transformed version of Info Gain method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute PFSH values of terms
    
    disp('Computing PFSH value...');
    pfsh; % transformed version of PFS method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
   % Compute GINITH values of terms
    
    disp('Computing GINITH value...');
    ginith;% transformed version of Gini Index for Term method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute GINIH values of terms
    
    disp('Computing GINIH value...');
    ginih; % transformed version of Gini Index method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute DFSSH values of terms
    
    disp('Computing DFSSH value...');
    dfssh;% transformed version of DFSS method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute NDMH values of terms
    
    disp('Computing NDMH value...');
    ndmh; % transformed version of NDM method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute CDMH values of terms
    
    disp('Computing CDMH value...');
    cdmh;% transformed version of CDM method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute DPMH values of terms
    
    disp('Computing DPMH value...');
    dpmh; % transformed version of DPM method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute CMFSH values of terms
    
    disp('Computing CMFSH value...');
    cmfsh;% transformed version of CMFS method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute MMRH values of terms
    
    disp('Computing MMRH value...');
    mmrh; % transformed version of MMR method 

    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % CRFH 46
% POISSONH 47
% CICIH 48
% GSSHGSSSH 49

    % Compute CRFH values of terms
    
    disp('Computing CRFH value...');
    crfh;% transformed version of RF method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute POISSONH values of terms
    
    disp('Computing POISSONH value...');
    poissonh; % transformed version of POISSON method 
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute CICIH values of terms
    
    disp('Computing CICIH value...');
    cicih;% transformed version of CICI method
    
    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])
    
    % Compute GSSHGSSSH values of terms
    
    disp('Computing GSSHGSSSH value...');
    gsshgsssh; % transformed version of GSS and GSSS method 

    % Save terms and phrases
    eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

    
    % Display number of items in each class
    dataset_class_idx    
    

disp('Done...');

return;


%===================================================================
% Process Current English Text
%===================================================================
function process_curr_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class)

% Globals
global term_list_pre;
global term_existence_map;
global stopword_list_map;
global destination_fpath;
global resfoldername;

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

% Initially no term is marked for appearance in current text
for wrd=1:length(term_list_pre)
    term_list_pre(wrd).MARKED = 0;
end


% Process word list in current text
for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    curr_word = char(curr_word);
    
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
        
            
        % -----------------------------------------------------------------
        % Add current term to the term list.
        % -----------------------------------------------------------------


        % Search term set for current word
        num_item = length(term_list_pre);

        term_and_class=char(strcat(strcat(curr_word,'_'), int2str(curr_class)));

        % If term is already in the list, increment its freq.
        if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            term_list_pre(term_index).FREQ = term_list_pre(term_index).FREQ + 1;

            % If the term is not marked before, increment
            % appearance count.
            if term_list_pre(term_index).MARKED == 0
                term_list_pre(term_index).APPEARANCE = term_list_pre(term_index).APPEARANCE + 1;
                term_list_pre(term_index).MARKED = 1;
            end

        else
            %add to word list
            %term_existence_map(char(term_and_class))=num_item + 1;
            term_existence_map(term_and_class)=num_item + 1;
            term_list_pre(num_item + 1).CLASS = curr_class;
            term_list_pre(num_item + 1).NAME = curr_word;
            term_list_pre(num_item + 1).FREQ = 1;
            term_list_pre(num_item + 1).MARKED = 1;
            term_list_pre(num_item + 1).APPEARANCE = 1;
        end
 
        
                       
                  
    end
    
end
destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['save ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])

return;



%===================================================================
% Process Current Turkish Text
%===================================================================
function process_curr_turkish_text(tokenization_type,usestopwordremoval, uselowercase, usestemming, curr_text, curr_class)

% Globals
global term_list_pre;
global term_existence_map;
global stopword_list_map;
global destination_fpath;
global resfoldername;


if uselowercase==1
    % Make all text lowercase
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


% Initially no term is marked for appearance in current text
for wrd=1:length(term_list_pre)
    term_list_pre(wrd).MARKED = 0;
end


% Process word list in current text
for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    curr_word=char(curr_word);
    
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
        
            % -----------------------------------------------------------------
            % Add current term to the term list.
            % -----------------------------------------------------------------
            
            
            % Search term set for current word
            num_item = length(term_list_pre);
            
            term_and_class=char(strcat(strcat(curr_word,'_'), int2str(curr_class)));
            
            % If term is already in the list, increment its freq.
            if isKey(term_existence_map,term_and_class)==1
                term_index=term_existence_map(term_and_class);
                term_list_pre(term_index).FREQ = term_list_pre(term_index).FREQ + 1;

                % If the term is not marked before, increment
                % appearance count.
                if term_list_pre(term_index).MARKED == 0
                    term_list_pre(term_index).APPEARANCE = term_list_pre(term_index).APPEARANCE + 1;
                    term_list_pre(term_index).MARKED = 1;
                end
                
            else
                %add to word list
                term_existence_map(term_and_class)=num_item + 1;
                term_list_pre(num_item + 1).CLASS = curr_class;
                term_list_pre(num_item + 1).NAME = curr_word;
                term_list_pre(num_item + 1).FREQ = 1;
                term_list_pre(num_item + 1).MARKED = 1;
                term_list_pre(num_item + 1).APPEARANCE = 1;
            end
        
    
    end
end

destination_fpath=strcat('C:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\');
eval(['save ', strcat(destination_fpath,'term_existence_map.mat'), '  term_existence_map'])

return;


%===================================================================
% Compute Mutual Information
%===================================================================
function mutual_info()

% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% MI(term, category) = log (A * N / (A + C) * (A + B))
% MI(x, y) = sumx sumy p(x,y) * log (p(x,y) / (p(x) * p(y)))

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute mutual information for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)
    
    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end
    
    % Init
    curr_mutual_info = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    
    
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    
    % Compute mutual information of current term for regarding class
    for class=term_list_pre(wrd).CLASS
    
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        
        res = log2((N11 * N) / ((N11 + N01) * (N11 + N10)));

        % Assign mutual information if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_mutual_info(class) = res;
        end        
    end
        
    % Get mutual information for current term in current class
    term_list_pre(wrd).MUTUAL_INFO = curr_mutual_info(term_list_pre(wrd).CLASS);
    
end

% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])


return


%===================================================================
% Compute Poisson Distribution
%===================================================================
function poisson_distribution()

% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute poisson distribution for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)
    
    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end
    
    % Init
    curr_poisson = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    total_freq_for_class = zeros(1, NUM_CLASS);

    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
            total_freq_for_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    
    
    % Compute poisson distribution of current term for regarding class
    for class=term_list_pre(wrd).CLASS
    
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);

        %lambda=(N11+N10)/N;
        lambda=sum(total_freq_for_class)/N;
        a_hat=(N11+N01)*(1-exp(-lambda));
        b_hat=(N11+N01)*(exp(-lambda));
        c_hat=(N10+N00)*(1-exp(-lambda));
        d_hat=(N10+N00)*(exp(-lambda));
        
        a=N11;
        b=N01;
        c=N10;
        d=N00;

        part1=(a-a_hat)^2/a_hat;
        part2=(b-b_hat)^2/b_hat;
        part3=(c-c_hat)^2/c_hat;
        part4=(d-d_hat)^2/d_hat;
        
        res = part1+part2+part3+part4;
        
        % Assign poisson distribution if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_poisson(class) = res;
        end        
    end
        
    % Get poisson distribution for current term in current class
    term_list_pre(wrd).POISSON = curr_poisson(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])


return

%===================================================================
% Compute DFSS (Discriminative and semantic features selection)
%===================================================================
function dfss()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% DFSS=
% Formula is taken from "Zong, W., Wu, F., Chu, L. K., & Sculli, D. (2015).
% A discriative and semantic feature selection method for text categorization. International Journal of Production Economics, 165, 215-222."



global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DFSS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_dfss = zeros(1, NUM_CLASS);
    
    %According to document frequency
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    %According to term frequency
    appearence_in_class_tf = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class_tf(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    
    % Compute DFSS_FS value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        

        N11_tf = appearence_in_class_tf(class);
        N10_tf = sum(appearence_in_class_tf(other_classes));
        
        if (N11 == 0)
            N11 = 0.001;
        end 
        
        if (N10 == 0)
            N10 = 0.001;
        end 
        
        part1a=N11_tf/N11;
        part1b=N10_tf/N10;
        
        if (isnan(part1a) || isinf(part1a)) 
            part1a=0; 
        end 
        
        if (isnan(part1b)|| isinf(part1b)) 
            part1b=0.001; 
        end 
        
%         if (part1b == 0)
%             part1b = 0.001;
%         end 

        part1 = part1a/part1b;
        
        if (isnan(part1)|| isinf(part1)) 
            part1=0; 
        end 
        
        
        part2a= N11/(N11+N01);
        part2b= N11/(N11+N10);
        
        if (isnan(part2a) || isinf(part2a)) 
            part2a=0; 
        end 
        
        if (isnan(part2b)|| isinf(part2b)) 
            part2b=0; 
        end 
        
        part2 = part2a*part2b;
        
        part3a=N11/(N11+N10);
        part3b=N01/(N01+N00);
        
        if (isnan(part3a) || isinf(part3a)) 
            part3a=0; 
        end 
        
        if (isnan(part3b)|| isinf(part3b)) 
            part3b=0; 
        end 
        
        part3 = abs(part3a-part3b);
       
        res = part1*part2*part3; 
        
        
        


       
         
        
        
        % Assign DFSS_FS if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_dfss(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DFSS = curr_dfss(term_list_pre(wrd).CLASS);
    
end


%===================================================================
% Compute Probabilistic Feature Selection
%===================================================================
function pfs()

% N is observed frequency


% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
%
% PFS(term, category) = (((A / (A + C))+(A /(A+B)))/ ((A + C)/N)) + 
%((((N-A-B-C) / (B + (N-A-B-C)))+((N-A-B-C)/((N-A-B-C)+C)))/ ((B + (N-A-B-C))/N))


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute PFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_pfs = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        dnm1 = N11 + N01;
        dnm2 = N10 + N00;
        
        if dnm1 == 0
            dnm1 = 0.1;
        end

        if dnm2 == 0
            dnm2 = 0.1;
        end

        res = (((N11 / (N11 + N01))+(N11/(N11+N10)))/ ((dnm1)/N)) + (((N00 / (N10 + N00))+(N00/(N00+N01)))/ ((dnm2)/N));  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_pfs(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).PFS = curr_pfs(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Normalized Difference Measure
%===================================================================
function ndm()

% N is observed frequency


% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
%
% NDM(term, category) = abs((A/(A+C))-(B/(N-A-C)))/min(A/(A+C),B/(N-A-C))


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute NDM value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ndm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute NDM value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1=N11/(N11+N01);
        part2=N10/(N10+N00);
        
        if (isnan(part1) || isinf(part1)) 
            part1=0; 
        end 
        
        if (isnan(part2)|| isinf(part2)) 
            part2=0; 
        end 
        
        denom = min(part1,part2);
        
        if denom == 0
            denom = 0.001;
        end

        res = abs(part1-part2)/denom;  
        % Assign NDM if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_ndm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).NDM = curr_ndm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute PHD Novel Method Formula 1
%===================================================================
function dfs()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% PHDNMV1(term, category) = log (P(t|c)/P(t))+P(t|c)
% equivalent
% PHDNMV1(term, category) = (A / (A + C) + (A / (A + B)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        res = ((N11 / (N11 + N10)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DFS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute PMH (Proposed Method Hande)
%===================================================================
function pmh()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)



global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute PMH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        

        res = ((N11*N00-N01*N10)/(N11*N00-N10*(N01-1)))/(N01/(N11*N00-N01*(N10-1))+N10/(N10+N00)+1); 
        %((ad-bc)/(ad-c(b-1)))/((b/(ad-b(c-1))+(c/(c+d))+1);
        
        %res = ((N11 / (N11 + N10)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).PMH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute GSS (simple version of Chi-square method)
%===================================================================
function gss()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)



global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GSS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        % ad-bc/N^2
        res = ((N11*N00)-(N10*N01))/N*N;
        
        %res = ((N11 / (N11 + N10)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).GSS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute GSSS (square of GSS method)
%===================================================================
function gsss()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)



global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GSSS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        % ad-bc/N^2
        res = ((N11*N00)-(N10*N01))*((N11*N00)-(N10*N01))/N*N*N*N;
        
        %res = ((N11 / (N11 + N10)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).GSSS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Class Discriminating Measure (CDM) 
%===================================================================
function cdm()
%some extensions to modified ambiguity measure


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CDM value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1= N11/(N11+N01);
        part2= N10/(N10+N00);
        
        
        if (isnan(part1) || isinf(part1)) 
            part1=0; 
        end 
        
        if (isnan(part2)|| isinf(part2) || part2==0)  
            part2=0.001; 
        end 
        
        part3 = part1/part2;
        
%         if (isnan(part3)|| isinf(part3)) 
%             part3=0; 
%         end 
        
        part4=log2(part3);
        
        if (isnan(part4)|| isinf(part4)) 
            part4=0; 
        end 
        
        res = abs(part4);
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CDM = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Discriminative Power Measure (DPM) 
%===================================================================
function dpm()
%some extensions to modified ambiguity measure


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DPM value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        

        res = abs((N11/(N11+N01))-(N10/(N10+N00)));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DPM = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Comprehensively Measure Feature Selection (CMFS) 
%===================================================================
function cmfs()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CMFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        %N00 = N - (N11 + N10 + N01);
        

        res = ((N11+N01)/N)*(N11/(N11+N01))*(N11/(N11+N10));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CMFS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Max-Min Ratio (MMR) 
%===================================================================
function mmr()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute MMR value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1a=N11/(N11+N01);
        part1b=N10/(N10+N00);
        
        if (isnan(part1a) || isinf(part1a)) 
            part1a=0.2; 
        end 
        
        if (isnan(part1b)|| isinf(part1b)) 
            part1b=0.2; 
        end 
        
        part1 = abs(part1a-part1b);
        
        part2 = min(part1a,part1b);
        
        if (isnan(part2)|| isinf(part2) || part2 == 0) 
            part2=0.2; 
        end
        
        part3 = max(part1a,part1b);
        
        part4 = part1/part2;
        
        if (isnan(part4)|| isinf(part4)) 
            part4=0; 
        end

        res = part4*part3;
        
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).MMR = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Extensive Feature Selector (EFS) 
%===================================================================
function efs()
%some extensions to modified ambiguity measure


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute EFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1= N11/(N11+N01);
        part2= N01/(N11+N01);
        part3= N10/(N10+N00);
        part4= N11/(N11+N10);
        part5= N10/(N11+N10);
        part6= N01/(N01+N00);
        
        if (isnan(part1) || isinf(part1)) 
            part1=0; 
        end 
        
        if (isnan(part2)|| isinf(part2)) 
            part2=0; 
        end 
        
        if (isnan(part3)|| isinf(part3)) 
            part3=0; 
        end 
        
        if (isnan(part4)|| isinf(part4))  
            part4=0; 
        end 
        
        if (isnan(part5)|| isinf(part5)) 
            part5=0; 
        end 
        
        if (isnan(part6)|| isinf(part6))  
            part6=0; 
        end 
        
        res = (part1/(part2+part3+1))*(part4/(part5+part6+1));
        

        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).EFS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Class-index corpus-index (CICI) 
%===================================================================
function cici()
%some extensions to modified ambiguity measure


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

 %%cici(t)=(P(t|c)*P(t_not|c_not)-P(t|c_not)*P(t_not|c))*(P(t,c)*P(t_not,c_not)-P(t,c_not)*P(t_not,c))
 
 %%cici(t)= ((N11*N00-N10*N01)^2)/((N11+N01)*(N10+N00)*N^2)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CICI value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
         %%cici(t)= ((N11*N00-N10*N01)^2)/((N11+N01)*(N10+N00)*N^2)
        
        part1= (N11*N00-N10*N01)^2;
        part2= (N11+N01)*(N10+N00)*N^2;
        
        
        if (isnan(part2)|| isinf(part2)) 
            part2=0; 
        end 
        
        res = part1/part2;
        
     
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
                                                   
    end
        
    term_list_pre(wrd).CICI = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute MDFS
%===================================================================
function mdfs()
%some extensions to modified ambiguity measure


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%



global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute Modified DFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        res = ((N11 / (N11 + N10))*(N00 / (N00 + N01)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).MDFS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return




%===================================================================
% Compute PHD Novel Method Formula 2
%===================================================================
function phd_novel_method_f2()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N01 (B) : The number of times category occurs without term
% N10 (C) : The number of times term occurs without category
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% PHDNMV1(term, category) = log (P(t|c)/P(t))+P(t|c)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute Modified PHD Novel Method Formula 2 value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm2 = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        %res1 = radtodeg(asin((N11/(N11+N01))-(N10 / (N00 + N10))));%arcsin(P(t|c)-P(t|c_not))) 
        %res2 =(1-(N10/(N00+N10))^2)*((N11/(N01+N11)-(N10/(N00+N10)))^2);%(1-P(t|c_not))^2*(P(t|c)-P(t|c_not)^2
        %res3=(((N11)/(sqrt(N11+N10)*sqrt(N11+N01))));%Ochiai similarity en buyuk
        %res4=((N11/(N01+N10+N11)));%jaccard index en buyuk
        %res5=((2*N11)/(2*N11+N10+N01));%dice similarity en buyuk
        %res6=(((N11*N00)-(N01*N10))/(sqrt((N11+N01)*(N10+N00)*(N01+N00)*(N11+N10))));%phi coefficient en buyuk
        %res7=(((N11*N00))/(sqrt((N11+N01)*(N10+N00)*(N01+N00)*(N11+N10))));%Sokal and Sneath Similarity Measure 5 coefficient en buyuk
        %res8=((N11/(N11+N01))+(N11/(N11+N10))+(N00/(N01+N00))+(N00/(N10+N00)))/4;%Sokal and Sneath Similarity Measure 4 coefficient en buyuk
        %res9=(N11+N00)/(N11+N00+2*(N10+N01));%Rogers and Tanimoto Similarity Measure en buyuk
        %res10=((N11/N11+N01)+(N11/N11+N10))/2;%Kulczynski Similarity Measure 2 en buyuk
        %res11=((N11+N00)-(N10+N01))/(N11+N01+N10+N00);%Hamann Similarity Measure en buyuk
        %Goodman and Kruskal Lambda en buyuk baslangic
        %t1=max(N11,N01)+max(N10,N00)+max(N11,N10)+max(N01,N00);
        %t2=max(N11+N10,N01+N00)+max(N11+N01,N10+N00);
        %res12=(t1-t2)/(2*(N11+N01+N10+N00)-t2);%Goodman and Kruskal Lambda en buyuk bitis
        %Anderberg’s D (Similarity) en buyuk baslangic
        %t1=max(N11,N01)+max(N10,N00)+max(N11,N10)+max(N01,N00);
        %t2=max(N11+N10,N01+N00)+max(N11+N01,N10+N00);
        %res13=(t1-t2)/(2*(N11+N01+N10+N00));%Anderberg’s D (Similarity) en buyuk bitis
        %res14=(sqrt(N11*N00)-sqrt(N01*N10))/(sqrt(N11*N00)+sqrt(N01*N10));%Yule’s Y Coefficient en buyuk
        %res15=(N11*N00-N01*N10)/(N11+N01+N10+N00)^2;%Dispersion Similarity en buyuk
        %res16=N11/max(N11+N10,N11+N01);%BRAUN BANQUE en buyuk


        classprob=dataset_class_idx(class)/sum(dataset_class_idx);

        
        
        res=(N11/(N11+N10))*(N11/(N11+N10+N01));%toplam
        
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm2(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).PHD_NM_F2 = curr_phdnm2(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return





%===================================================================
% Compute Chi-Square
%===================================================================
function chi2()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% chi2MI(x, y) = sumx sumy (Nxy - Exy)^2 / Exy

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute chi2 value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_chi2 = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute chi2 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        

        % Calculate expected frequencies
        E11 = N * ((N11 + N10) / N) * ((N11 + N01) / N);
        E10 = N * ((N10 + N11) / N) * ((N10 + N00) / N);
        E01 = N * ((N01 + N00) / N) * ((N01 + N11) / N);
        E00 = N * ((N00 + N01) / N) * ((N00 + N10) / N);
        
        % Calculate chi2 value
        curr_chi2(class) = ((N00 - E00)^2 / E00) + ...
            ((N01 - E01)^2 / E01) + ...
            ((N10 - E10)^2 / E10) + ...
            ((N11 - E11)^2 / E11);
        
        
    end
    
    
    % Get chi2 value for current term in current class
    term_list_pre(wrd).CHI2 = curr_chi2(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])




%===================================================================
% Compute Gini Index according to binary settings
%===================================================================
function gini_index()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category C
% N01 (C) : The number of times category occurs without term  B
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% GINI_INDEX=1/((N11+N10)^2)*( (N11^2)/(N11+N01) )^2+( (N10^2)/(N10+N00) )^2)
% Formula is taken from "Comparison of metrics for feature selection in
% imbalanced text classification", Ogura et al.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINI INDEX value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_gi = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);
        
        

        part1 = 1/((N11+N10)^2);      
        part2=((N11^2)/(N11+N01))^2;
        part3=((N10^2)/(N10+N00))^2;
        
        % Calculate Gini Index value
        curr_gi(class) = part1*(part2+part3);
        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).GINI_INDEX = curr_gi(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])



%===================================================================
% Compute Gini Index
%===================================================================
function gini_index_for_term()


% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% GINI_INDEX=((N11)/(N11+N01) )^2)*((N10)/(N10+N00)^2)
% Formula is taken from "Comparison of metrics for feature selection in
% imbalanced text classification", Ogura et al.
% scores for term calculated by addition of all class values

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINI INDEX value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_gi = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        
        res = ((N11/(N11+N01))^2)*((N11 / (N11 + N10))^2);
        
        
        
        % Calculate Gini Index value
        curr_gi(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).GINI_INDEX_FOR_TERM = curr_gi(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return



%===================================================================
% Compute Ambiguity Measure
%===================================================================
function ambiguity_measure_tf()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% AM=tf(t,c)/tf(t)
% AM=N11/(N11+N01)
% Formula is taken from ambiguity measure paper Nazli Goharian et. al

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% -----------------------------------------------------------------
% Compute AM value for each term regarding class
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_am= zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    % Compute AM value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));                        
              
        % Calculate Ambiguity Measure
        curr_am(class) = N11/(N11+N10);         
                                                      
    end   
    
    % Get AM value for current term in current class
    term_list_pre(wrd).AM_TF = curr_am(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return
%===================================================================
% Compute Document Frequency Measure
%===================================================================
function document_frequency()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute Document Frequency value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_df = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    % Compute Document Freq value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);        
        
        % Calculate Document Frequency Measure
        curr_df(class) = N11;
        
                                                      
    end
        
    % Get DF value for current term in current class
    term_list_pre(wrd).DF = curr_df(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Multi Class Odds Ratio
%===================================================================
function mullass_odds_ratio()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% MOR=
% Formula is taken from "Feature selection for text classification with
% naive bayes", Chen et al.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute MOR value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_mor= zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute MOR value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        
        
        
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);
        
        part1=N11/(N11+N01);
        part2=N10/(N00+N10);
        
        
%         if (isnan(part1) || isinf(part1) || part1==0) 
%             part1=0.2; 
%         end 
        
        if (isnan(part2)|| isinf(part2) || part2==0) 
            part2=0.2; 
        end 
        
        part3 = log(part1/part2);
        
        if (isnan(part3)|| isinf(part3) || part3==0) 
            part3=0.2; 
        end 
        
        p3= 1-part2;
        
        p4= 1-part1;
        
%         if (isnan(p3)|| isinf(p3) || p3 ==0) 
%              p3=0.2; 
%          end
        
         if (isnan(p4)|| isinf(p4) || p4 ==0) 
             p4=0.2; 
         end
         
         part4 = log(p3/p4);
         
         if (isnan(part4)|| isinf(part4)|| part4==0)  
            part4=0.2; 
        end 
        
        
        part5 = part3+part4;
        
        res = abs(part5);
        
        
%         part3=part1*(1-part2);
%         part4=part2*(1-part1);
%         
%         part5= part3/part4;
%         
%         if (isnan(part5)|| isinf(part5)) 
%             part5=0; 
%         end 
%         
%         part6 = log(part5);
%         
%         if (isnan(part6)|| isinf(part6))
%             part6=0; 
%         end 
        
        % Calculate Multi Class Odds Ratio Measure
        %curr_mor(class) = abs(log(formula));
        curr_mor(class) = res;        
                                                      
    end
        
    % Get MOR value for current term in current class
    term_list_pre(wrd).MOR = curr_mor(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Probability based term weight
%===================================================================
function probability_based_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% PB_Weight = max(TF *  log(1 + (N11/N10)*(N11/N01) )

% Liu, Y., Loh, H. T., & Sun, A. (2009). Imbalanced text classification: A term weighting approach. Expert systems with Applications, 36(1), 690-701.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute PROBABILITY BASED SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_pb = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        
        part1 = 1;
        part2 = (N11/N10)*(N11/N01);
        
        res = log10(part1 + part2);
        
        
        
        % Calculate Gini Index value
        curr_pb(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).PB_TERM_WEIGHT = curr_pb(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute RF value for TF-RF term weight
%===================================================================
function TFRF_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% TF-RF = max(TF *  log2 (2 + (N11/N01) )

% Lan, M., Tan, C. L., Su, J., & Lu, Y. (2009). Supervised and traditional term weighting methods for automa text categorization. Pattern Analysis and Machine Intelligence, IEEE Transactions on, 31(4), 721-735.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute TF-RF SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_TFRF = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        
        part1 = 2;
        part2 = (N11/N01); % (N11/max(1,
        res = log2(part1 + part2);
        
        
        
        % Calculate Gini Index value
        curr_TFRF(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).TF_RF = curr_TFRF(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute RR value for TF-RR term weight
%===================================================================
function TFRR_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% TF-RR = log (tf + 1) * log2( (P(t|c)/P(t|c_not)) + 2 )

% Ko, Y. (2015). A new term?weighting scheme for text classification using the odds of positive and negative class probabilities. Journal of the Association for Information Science and Technology.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute TF-RF SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_TFRR = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);        
        
        
        part1 = (N11/(N11+N01));
        part2 = (N10/(N10+N00));
        res = log2((part1 / part2) + 2);
        
        
        
        % Calculate Gini Index value
        curr_TFRR(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).TF_RR = curr_TFRR(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute Information Gain
%===================================================================
function info_gain()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% IG = e(pos,neg) – [Pword.e(tp,fp) + Pword'.e(fn,tn)]

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute IG value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ig = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute IG value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
                
        % IG = e(pos,neg) – [Pword.e(tp,fp) + Pwordnot.e(fn,tn)]
        % IG = prm1       - [Pword.prm2     + Pwordnot.prm3    ]
        
        tmp_x = N11 + N01;
        tmp_y = N10 + N00;
        prm1 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));
        
        tmp_x = N11;
        tmp_y = N10;
        prm2 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));
        
        tmp_x = N01;
        tmp_y = N00;
        prm3 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));

        Pword = (N11 + N10) / N;
        Pwordnot = 1 - Pword;
        
        % Calculate IG value
        curr_ig(class) = prm1 - (Pword * prm2 + Pwordnot * prm3);
    end
        
    % Get IG value for current term in current class
    term_list_pre(wrd).IG = curr_ig(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute Information Gain
%===================================================================
function info_gain_for_term()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% IG = e(pos,neg) – [Pword.e(tp,fp) + Pword'.e(fn,tn)]

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute IG value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ig = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute IG value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
                
        % IG = e(pos,neg) – [Pword.e(tp,fp) + Pwordnot.e(fn,tn)]
        % IG = prm1       - [Pword.prm2     + Pwordnot.prm3    ]
        

        tmp_x = N11 + N01;
        tmp_y = N10 + N00;
        prm1 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));
        
        tmp_x = N11;
        tmp_y = N10;
        prm2 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));
        
        tmp_x = N01;
        tmp_y = N00;
        prm3 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));

        Pword = (N11 + N10) / N;
        Pwordnot = 1 - Pword;
        
        % Calculate IG value
        curr_ig(class) = prm1 - (Pword * prm2 + Pwordnot * prm3);
        
        
    end
        
    % Get IG value for current term in current class
    term_list_pre(wrd).IG_FOR_TERM = curr_ig(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return
%===================================================================
% Compute transformed version of Chi-square method 
%===================================================================
function xh()

% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute XH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute XH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        res = 1+((N11*N00-N01*N10)/(N11+N10)*(N11+N01));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).XH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return
    
%===================================================================
% Compute transformed version of DFS and MDFS method 
%===================================================================
function dfshmdfsh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DFSHMDFSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute DFSHMDFSH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        res = (N11/(N11+N01)*(N11+N10))/((N10/(N10+N00))+1);
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DFSHMDFSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of EFS method 
%===================================================================
function efsh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute EFSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute EFSH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1 = (N11/(N11+N01))/((N10/(N10+N00))+1);
        
        part2 = (N11/(N11+N01)*(N11+N10))/(((N10*(N11+N10))/(N10+N11))+1);

        res = part1 * part2;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).EFSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of OR method 
%===================================================================
function sorh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute SORH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute SORH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = log2(2+((N11*N00)/(max(1,N01)*max(1,N10))));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).SORH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of Mutual Info method 
%===================================================================
function mih()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute MIH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute MIH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = log2(2+((N11*N)/(max(1,N11+N01)*max(1,N11+N10))));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).MIH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of Correlation Coeffient method 
%===================================================================
function cch()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CCH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute CCH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        res = 1+((N11*N00-N01*N10)/(N11+N10)*(N11+N01));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CCH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of Info Gain method 
%===================================================================
function igh() 
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute IGH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute IGH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1 = (N11/(N11+N01))*log2((N11*N)/(N11+N10)*(N11+N01));
        
        part2 = (N10/(N10+N00))*log2((N10*N)/(N11+N10)*(N10+N00));

        res = part1 - part2;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).IGH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return
    
%===================================================================
% Compute transformed version of PFS method 
%===================================================================
function pfsh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute PFSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute PFSH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1 = (N11/(N11+N01))+(N11/((N11+N01)*(N11+N10)));
        
        part2 = (N11+N01); 
        
        part3 = 1/(N10+N00);

        res = (part1/part2)+part3;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).PFSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of Gini Index for Term method 
%===================================================================
function ginith()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINITH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINITH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1 = N11/(N11+N01);
        
        part2 = N11/((N11+N01)*(N11+N10));
        
        res = part1*part2;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).GINITH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of Gini Index method 
%===================================================================
function ginih()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINIH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINIH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1 = 1/(N11+N10);
        
        part2 = (((N11*N11)/(N11+N01))+((N10*N10)/(N10+N00)));
        
        res = part1*part2;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).GINIH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of DFSS method 
%===================================================================
function dfssh() 
        
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DFSSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    %According to term frequency
    appearence_in_class_tf = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class_tf(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    
    % Compute DFSSH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        N11_tf = appearence_in_class_tf(class);
        N10_tf = sum(appearence_in_class_tf(other_classes));

        
        part1 = ((N11_tf*(N11+N01))/N11)/((N10_tf*(N10+N00))/max(1,N10));
        
        part2 = N11/((N11+N01)*(N11+N10));

        part3 = N11/(N11+N01);
        
        res = part1*part2*part3;
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DFSSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

    
%===================================================================
% Compute transformed version of NDM method 
%===================================================================
function ndmh()
% N is observed frequency


% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
%
% NDM(term, category) = abs((A/(A+C))-(B/(N-A-C)))/min(A/(A+C),B/(N-A-C))


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute NDMH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ndm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute NDM value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1=N11/(N11+N01);
        part2=N10/(N10+N00);
        
       
       denom = max(1,min(part1,part2));
       

        res = abs(part1-part2)/denom;  
        % Assign NDM if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_ndm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).NDMH = curr_ndm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of CDM method 
%===================================================================
function cdmh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CDMH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute CDMH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = log2(abs(2+((N11/(N11+N01))/(max(1,N11+N01)*max(1,N11+N10)))));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CDMH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of DPM method 
%===================================================================
function dpmh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DPMH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute DPMH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = (N11/(max(1,N11+N01)))-(N10/(max(1,N10+N00)));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DPMH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of CMFS method 
%===================================================================
function cmfsh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CMFSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute CMFSH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = (N11*N11)/((N11+N01)*(N11+N01)*(N11+N10));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CMFSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return


%===================================================================
% Compute transformed version of MMR method 
%===================================================================
function mmrh()
%some extensions to modified ambiguity measure

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute MMRH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        part1a=N11/(N11+N01);
        part1b=N10/(N10+N00);
        
        
        
        part1 = abs(part1a-part1b);
        
        part2 = max(1,min(part1a,part1b));
        
       part3 = max(part1a,part1b);
        
        part4 = part1/part2;
        
        res = part4*part3;
        
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).MMRH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of RF method 
%===================================================================
function crfh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CRFH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute CRFH value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        res = log2(2+((N11/(N11*N01))/(max(1,N10)/(N10+N00))));
        
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).CRFH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of POISSON method 
%===================================================================
function poissonh()
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute POISSONH for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)
    
    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end
    
    % Init
    curr_poisson = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    total_freq_for_class = zeros(1, NUM_CLASS);

    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
            total_freq_for_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    
    
    % Compute poisson distribution of current term for regarding class
    for class=term_list_pre(wrd).CLASS
    
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);

        %lambda=(N11+N10)/N;
        lambda=sum(total_freq_for_class)/N;
        a_hat=(N11/(N11+N01))*(1-exp(-lambda));
        %b_hat=(N11+N01)*(exp(-lambda));
        c_hat=(N10/(N10+N00))*(1-exp(-lambda));
        %d_hat=(N10+N00)*(exp(-lambda));
        
        a=N11;
        %b=N01;
        c=N10;
        %d=N00;

        part1=(a-a_hat)^2/a_hat;
        %part2=(b-b_hat)^2/b_hat;
        part3=(c-c_hat)^2/c_hat;
        %part4=(d-d_hat)^2/d_hat;
        
        res = part1-part3;
        
        % Assign poisson distribution if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_poisson(class) = res;
        end        
    end
        
    % Get poisson distribution for current term in current class
    term_list_pre(wrd).POISSONH = curr_poisson(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])


return


%===================================================================
% Compute transformed version of CICI method 
%===================================================================
function cicih()
% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute CICIH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
         res = ((N11*N00)-(N01*N10))/(N11+N10);
        
        
     
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
                                                   
    end
        
    term_list_pre(wrd).CICIH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return

%===================================================================
% Compute transformed version of GSS and GSSS method 
%===================================================================
function gsshgsssh()
% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;
global destination_fpath;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GSSHGSSSH value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 1000) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
         res = (N11*N00)-(N01*N10);
        
        
     
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
                                                   
    end
        
    term_list_pre(wrd).GSSHGSSSH = curr_phdnm(term_list_pre(wrd).CLASS);
    
end


% Save terms
eval(['save ', strcat(destination_fpath,'term_list_pre.mat'), '  term_list_pre'])

return



