function [predictedClassLabel neighbourLabel neighborIds neighborDistances] = kNearestNeighbors(dataMatrix, dataLabels,queryMatrix, k)

%% Initialize all the matrix to store different data to be returned
neighborIds = zeros(size(queryMatrix,1),k);
neighbourLabel = zeros(size(queryMatrix,1),k);
predictedLabel = zeros(size(queryMatrix,1),1);
predictedClassLabel=[];
neighborDistances = neighborIds;
numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);

%% Similarity computation for distance
for i=1:numQueryVectors

    % Histogram intersection sum(min(test,train))/sum(train)
    similarity = sum(min(repmat(queryMatrix(i,:),numDataVectors,1),dataMatrix)')./sum(dataMatrix');

    % Sort in decreasing order of similarity
    [sortval sortpos] = sort(similarity,'descend');

    % Get relevant data point based on sorting order
    neighborIds(i,:) = sortpos(1:k);
    neighbourLabel(i,:) = dataLabels(neighborIds(i,:));
    neighborDistances(i,:) = sortval(1:k);

end

%% Prediction is where more labels of same sign
predictedLabel = sum(neighbourLabel')';
predictedLabel(predictedLabel<2)=0;
predictedLabel(predictedLabel>=2)=1;

% From 0-1 Lables, build back Human and Non-Human classification
for i = 1:length(predictedLabel)
    if(predictedLabel(i)==1)
        predictedClassLabel=[predictedClassLabel; {"Human"}];
    else
        predictedClassLabel=[predictedClassLabel; {"Non-Human"}];
    end
end

%% Return the results
predictedClassLabel;
neighbourLabel;
neighborDistances;
neighborIds;