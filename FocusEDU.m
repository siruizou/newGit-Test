% cd;
clear;
clc;
close all;
dirName = '/Users/happierthree/Desktop/FocusGroup_0607/';
%device = {'A066','B482','BB74','BF42','BFC8','C95A','C912','8C2A',...
   % '8960','B81E','BE64','C00A','C57E','C494','BF42'}; %'C922' no
   % connection,
cd (dirName);
files = dir(fullfile(dirName));
labels_alltime=[];
labels_allindex=[];
for i=1:length(files)
    if ~isempty(strfind(files(i).name,'ATTENTION')) && isempty(strfind(files(i).name,'C922')) ...
            && ~isempty(strfind(files(i).name,'.log')) && isempty(strfind(files(i).name,'BFC8')) ...
            && isempty(strfind(files(i).name,'A066'))  && isempty(strfind(files(i).name,'C912'))
        % C912 is removed because this subject's label4 and label5?s
        % difference is only ~40 increase, while other subjects usually
        % have ~100 increase. 
    fileName_att = strcat(dirName,files(i).name);
    data  = dlmread(fileName_att,'\t',1,0);
    time0 = data(1,1);
    time = data(:,1) - time0;
    Att = data(:,2);
    %plot each subject's attention score
%     fig=figure(i);
%     hold on;
%     plot(time,data(:,2));
%     xlabel('Time/sec');
%     xlim([0 2600]);
%     ylabel('Attention Scores');
%     ylim([0 100]);
%     title([files(i).name(24:27),' ','Attention Score']);
    %load corresponding EEG file to get label info
    fileName_event = strcat(dirName,files(i).name(1:27),'_EEG.log');
    delimiter = '\t';
    startRow = 2;   
    formatSpec = '%f%f%f%s%s%[^\n\r]'; % [^\n\r] means Exclude characters inside the brackets, reading until the first matching character.  
    fileID = fopen(fileName_event,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    labels = [dataArray{1:end-1}];
    labels_rawtime = double(labels(:,1)) - double(labels(1,1));
    labels_stamp = labels(:,4);
    labels_name ={'Label1','Label2','Label3','Label4','Label5','Label6','Label7','Label8','Label9','Label10'};
    labels_index = [];
    for j=1:length(labels_name)
        search = strcat('Label', num2str(j));
        temp = find(strcmp(labels_stamp,search), 1, 'first');
        labels_index = [labels_index; temp];
    end
    labels_time = labels_rawtime(labels_index);
    %plot([labels_time';labels_time'],ylim,'r');
    %save([filess(i).name(24:27),'.mat'],'time', 'Att');
    %saveas(fig,files(i).name(24:27),'png');
    labels_alltime = [labels_alltime labels_time];
    labels_allindex = [labels_allindex labels_index];
    end
end

% labels_diff = diff(labels_alltime);
% a = max(labels_diff,[],2) - min(labels_diff,[],2);
% diff = max(labels_alltime,[],2)-min(labels_alltime,[],2);
