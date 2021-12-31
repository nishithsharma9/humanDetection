clc; clear;

%% Creating HOG Vectors for Training Images

TrainFileNames = [];
TrainFileLabel = [];
TrainFileClassLabel = [];

% Positive Training Images
% Reading files from directory
Files=dir('TrainPositive*.bmp');
hogPositiveVector = [];
for k=1:length(Files)
    TrainFileNames = [TrainFileNames ; {Files(k).name}];
    TrainFileLabel = [TrainFileLabel ; {'Human'}];
    % Positive images have 1 Class
    TrainFileClassLabel = [TrainFileClassLabel ; 1 ];
    FileName = strcat(Files(k).folder,'/',Files(k).name);
    
    % Generating HOG Vector
    hog = hog_vector(FileName,false,Files(k).name);
    hogPositiveVector = [hogPositiveVector; hog];
end

% Negative Training Images
% Reading files from directory
Files=dir('TrainNegative*.bmp');
hogNegativeVector = [];
for k=1:length(Files)
    TrainFileNames = [TrainFileNames ; {Files(k).name}];
    TrainFileLabel = [TrainFileLabel ; {'Non-Human'}];
    % Negative images have 0 Class
    TrainFileClassLabel = [TrainFileClassLabel ; 0 ];
    FileName = strcat(Files(k).folder,'/',Files(k).name);
    
    % Generating HOG Vector
    hog = hog_vector(FileName,false,Files(k).name);
    hogNegativeVector = [hogNegativeVector; hog];
end


%% Creating HOG Vectors for Test Images
TestFileNames=[];
TestFileLabel=[];

% Positive Test Images
% Reading files from directory
Files=dir('TestPositive*.bmp');
hogTestPositiveVector = [];
for k=1:length(Files)
    TestFileNames = [TestFileNames ; {Files(k).name}];
    TestFileLabel = [TestFileLabel ; {'Human'}];
    FileName = strcat(Files(k).folder,'/',Files(k).name);
    
    % Generating HOG Vector
    hog = hog_vector(FileName,true,Files(k).name);
    hogTestPositiveVector = [hogTestPositiveVector; hog];
end

% Negative Test Images
% Reading files from directory
Files=dir('TestNegative*.bmp');
hogTestNegativeVector = [];
for k=1:length(Files)
    TestFileNames = [TestFileNames ; {Files(k).name}];
    TestFileLabel = [TestFileLabel ; {'Non-Human'}];
    FileName = strcat(Files(k).folder,'/',Files(k).name);
    
    % Generating HOG Vector
    hog = hog_vector(FileName,true,Files(k).name);
    hogTestNegativeVector = [hogTestNegativeVector; hog];
end


%% Collating data

% Training Images data
% First 10 are 1(HumanClass). Last 10 are 0(nonHumanClass)
TrainData = [hogPositiveVector; hogNegativeVector];

% Test Images data
% First 5 are 1(HumanClass). Last 5 are 0(nonHumanClass)
TestData = [hogTestPositiveVector ; hogTestNegativeVector];


%% Running 3-KNN on the test images using train images
[predictedClassLabels neighbourLabel neighborIds neighborDistances] = kNearestNeighbors(TrainData,TrainFileClassLabel, TestData, 3)

% Collating the result using neighbour indexes returned from KNN
result = [TestFileNames TestFileLabel TrainFileNames(neighborIds(:,1)) TrainFileLabel(neighborIds(:,1)) TrainFileNames(neighborIds(:,2)) TrainFileLabel(neighborIds(:,2)) TrainFileNames(neighborIds(:,3)) TrainFileLabel(neighborIds(:,3))];

%% Print results:

fprintf("The results are displayed below with all relevant data:\n\n")
for i = 1:length(result)
    fprintf("TestImage: "+ TestFileNames(i)+" | Correct Classification: "+TestFileLabel(i)+"\n");
    fprintf("\t1NN: "+ TrainFileNames(neighborIds(i,1))+" | Distance: "+neighborDistances(i,1)+" | Classification: "+TrainFileLabel(neighborIds(i,1))+"\n");
    fprintf("\t2NN: "+ TrainFileNames(neighborIds(i,2))+" | Distance: "+neighborDistances(i,2)+" | Classification: "+TrainFileLabel(neighborIds(i,2))+"\n");
    fprintf("\t3NN: "+ TrainFileNames(neighborIds(i,3))+" | Distance: "+neighborDistances(i,3)+" | Classification: "+TrainFileLabel(neighborIds(i,3))+"\n");
    fprintf("    Prediction From 3NN: "+ predictedClassLabels(i)+"\n\n\n");
end