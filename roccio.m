function [ predicted_labels] = roccio( train_matrix, topic_matrix, test_matrix, dataset_class_idx, term_feature )
%ROCCÝO Summary of this function goes here
%   Detailed explanation goes here
NUM_CLASS=length(dataset_class_idx);
term_count=length(term_feature);
centroid_matrix=zeros(length(dataset_class_idx),length(train_matrix));
distance_matrix=zeros(1,length(dataset_class_idx));

%her bir klass için centroidleri hesapla
for class=1:NUM_CLASS   
centroid_matrix(class,1:term_count)=mean(train_matrix(find(topic_matrix==class),:));
end 


%her bir test dokümanýnýn centroidlere olan uzaklýðýný bul
for test_count=1:size(test_matrix,1)

    for cent_count=1:size(centroid_matrix,1)    
      
        distance_matrix(cent_count) = sum((test_matrix(test_count,1:term_count)-centroid_matrix(cent_count,1:term_count)).^2).^0.5;
    end
% uzaklýk deðerlerinden en düþük olana göre klasý ata
    [Min_distance,Index]=min(distance_matrix);
    predicted_labels(test_count)=Index;
end

end

