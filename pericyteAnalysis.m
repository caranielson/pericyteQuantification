%% MATLAB GUI to quantify pericyte numbers in tissue sections
% Reads in the original raw image and a binary pericyte mask created with
% Ilastik and CellProfiler. User draws a region of interest, gives the ROI
% a label, and the program counts the number of pericytes inside the ROI.
% The user can then check the quality of this output and manually add or
% remove pericytes to improve accuracy of quantification. User can save ROI
% information to a .mat file named pericyteQuantification.mat'

% Original script created by Wen Mai Wong 2019
% Recreated by Cara Nielson 8/30/2022 
% Edited 9/15/2022
%%


function varargout = pericyteAnalysis(varargin)
% PERICYTEANALYSIS MATLAB code for pericyteAnalysis.fig
%      PERICYTEANALYSIS, by itself, creates a new PERICYTEANALYSIS or raises the existing
%      singleton*.
%
%      H = PERICYTEANALYSIS returns the handle to a new PERICYTEANALYSIS or the handle to
%      the existing singleton*.
%
%      PERICYTEANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERICYTEANALYSIS.M with the given input arguments.
%
%      PERICYTEANALYSIS('Property','Value',...) creates a new PERICYTEANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pericyteAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pericyteAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pericyteAnalysis

% Last Modified by GUIDE v2.5 23-Aug-2024 15:35:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pericyteAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @pericyteAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pericyteAnalysis is made visible.
function pericyteAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pericyteAnalysis (see VARARGIN)

% Choose default command line output for pericyteAnalysis
handles.output = hObject;
set(handles.countPericytesInROI,'Enable','off')
set(handles.saveCounts,'Enable','off')
set(handles.addPericytes,'Enable','off')
set(handles.removePericytes,'Enable','off')
set(handles.drawROI,'Enable','off')
set(handles.loadPericyteMask,'Enable','off')
set(handles.countPericytes,'Enable','off')
set(handles.loadSavedCounts,'Enable','off')
set(handles.recountPericytes,'Enable','off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pericyteAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pericyteAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadOriginalImage.
function loadOriginalImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadOriginalImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[chosenfile, chosenpath] = uigetfile('*.tiff; *.png', 'Select an image');
if ~ischar(chosenfile)
    return
end
filename = fullfile(chosenpath, chosenfile);
set(handles.displayOriginalImagePath, 'String', filename)

sampleName = chosenfile;
sampleName = erase(sampleName, ".png");

%display image
axes(handles.axes1);
imshow(filename);
image1 = fullfile(chosenpath, chosenfile);
handles.image1 = imread(image1);
image1 = imread(image1);
handles.image1 = image1;

handles.sampleName = sampleName;
set(handles.loadOriginalImage,'Enable','off')
set(handles.loadPericyteMask,'Enable','on')
set(handles.loadSavedCounts,'Enable','on')
guidata(hObject,handles)

% --- Executes on button press in loadPericyteMask.
function loadPericyteMask_Callback(hObject, eventdata, handles)
% hObject    handle to loadPericyteMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[chosenfile, chosenpath] = uigetfile('*.tiff; *.png','Select an image');
if ~ischar(chosenfile)
    return
end
image2 = fullfile(chosenpath, chosenfile);
set(handles.displayPericyteMaskPath, 'String', image2)
%image2 = imshow(image2);
handles.image2 = imread(image2);
image2 = imread(image2);
handles.image2 = image2;
set(handles.loadPericyteMask,'Enable','off')
set(handles.countPericytes,'Enable','on')
set(handles.loadSavedCounts,'Enable','on')
guidata(hObject,handles)


function displayOriginalImagePath_Callback(hObject, eventdata, handles)
% hObject    handle to displayOriginalImagePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of displayOriginalImagePath as text
%        str2double(get(hObject,'String')) returns contents of displayOriginalImagePath as a double


% --- Executes during object creation, after setting all properties.
function displayOriginalImagePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayOriginalImagePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function displayPericyteMaskPath_Callback(hObject, eventdata, handles)
% hObject    handle to displayPericyteMaskPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of displayPericyteMaskPath as text
%        str2double(get(hObject,'String')) returns contents of displayPericyteMaskPath as a double


% --- Executes during object creation, after setting all properties.
function displayPericyteMaskPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayPericyteMaskPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drawROI.
function drawROI_Callback(hObject, eventdata, handles)
% hObject    handle to drawROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

label = inputdlg({'Label'},...
              'Insert label for ROI', [1 50]);
      
sampleName = handles.sampleName;

%axis('image', 'on'); 
%colormap gray;
g = gcf;

%g.WindowState = 'maximized';
drawnow;
% Give user instructions for how to draw the ROI:
caption = sprintf('Click to draw ROI vertices. Finish drawing by selecting first vertex. Adjust points if needed.  Double-click inside when finished');
title(caption);
%message = sprintf('Click to draw ROI vertices. Finish drawing by selecting first vertex.\nThen adjust points if needed.\nDouble-click inside when finished');
%uiwait(helpdlg(message));
% Draw ROI.  Be sure to accept the  2nd and 3rd output arguments, which are the coordinates you clicked on.
[binaryImage, xPerimeter, yPerimeter] = roipoly;
% The ROI disappeared, so draw perimeter onto original image using xPerimeter and yPerimeter.
hold on
roi = plot(xPerimeter, yPerimeter, 'y.-', 'LineWidth', 2, 'MarkerSize', 15); 
title('');

filename1 = string(label);
filename2 = '.csv';
filename = append(sampleName,'_',filename1, filename2); 
T = table(xPerimeter, yPerimeter,'VariableNames', {'xPerimeter','yPerimeter'});
writetable(T, filename);
%save(filename, 'xPerimeter', 'yPerimeter')

set(handles.countPericytes,'Enable','off')
set(handles.countPericytesInROI,'Enable','on')
handles.roi = roi;
handles.xPerimeter = xPerimeter;
handles.yPerimeter = yPerimeter;
handles.label = label;
guidata(hObject,handles);


% --- Executes on button press in detectPericytes.
function countPericytes_Callback(hObject, eventdata, handles)
% hObject    handle to countPericytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image2 = handles.image2;
image2 = im2bw(image2,0.5);
%xPerimeter = handles.xPerimeter;
%yPerimeter = handles.yPerimeter;
image1 = handles.image1;
image1 = im2bw(image1,0.5);
colormap gray;
g = gcf;

if ndims(image2) > 1
	image2 = image2(:,:,1);
end


props = regionprops(image2, 'centroid');



centroids = vertcat(props.Centroid);
%centroids = cat(1,props.Centroid);
numspots = numel(props); % count objects
fprintf('Found %d total pericytes.\n', numspots);

xCentroids = centroids(:,1);
yCentroids = centroids(:,2);



%[in,on] = inpolygon(xCentroids,yCentroids,xPerimeter,yPerimeter);
%saveCentroidsIn = xCentroids(in);
handles.xCentroids = xCentroids;
handles.yCentroids = yCentroids;
%numSpotsInROI = numel(saveCentroidsIn);



%numel(xCentroids(on))
%numel(xCentroids(~in))
%imshow(image2); %hold on
%plot(centroids(:,1),centroids(:,2),'x')

%roi = plot(xPerimeter, yPerimeter, 'y.-', 'LineWidth', 2, 'MarkerSize', 15);
% %roi = roipoly(image2,xPerimeter,yPerimeter);
% newimage = imcrop(image2, roi);
%imshow(newimage)

%plotROI = plot(xPerimeter,yPerimeter,'y.-', 'LineWidth', 2, 'MarkerSize', 15);
%areaOfROI = polyarea(xPerimeter,yPerimeter);
%areaOfROI_mm = areaOfROI/(1538*1538);
%pericytesPerArea = numSpotsInROI/areaOfROI_mm;

%caption = sprintf('Found %d pericytes inside ROI (%d pericytes/mm^2)', numSpotsInROI, pericytesPerArea);
%title(caption);

%hold on
%plotCentroids = plot(saveCentroidsIn,yCentroids(in),'x', 'color', 'm', 'linewidth', 4);

hold on
plotCentroids = plot(xCentroids,yCentroids,'x', 'color', 'y', 'linewidth', 1);

%handles.saveCentroidsIn = saveCentroidsIn;
%handles.areaOfROI_mm = areaOfROI_mm;
handles.plotCentroids = plotCentroids;
handles.xCentroids = xCentroids;
handles.yCentroids = yCentroids;
%handles.plotROI = plotROI;
handles.centroids = centroids;
%label = handles.label;

set(handles.countPericytes,'Enable','off')
set(handles.loadSavedCounts,'Enable','off')
set(handles.addPericytes,'Enable','on')
set(handles.removePericytes,'Enable','on')
set(handles.drawROI,'Enable','on')
set(handles.saveCounts,'Enable','on')

guidata(hObject,handles);


% --- Executes on button press in addPericytes.
function addPericytes_Callback(hObject, eventdata, handles)
% hObject    handle to addPericytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotCentroids = handles.plotCentroids;
xCentroids = handles.xCentroids;
yCentroids = handles.yCentroids;
%xPerimeter = handles.xPerimeter;
%yPerimeter = handles.yPerimeter;
%saveCentroidsIn = handles.saveCentroidsIn;

% Give user instructions for how to draw the ROI:
caption = sprintf('Position crosshairs over pericyte and click to add. Press ENTER when done.');
title(caption);

global keyIsPressed

keyIsPressed = 0;

set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~keyIsPressed 
        [x, y] = ginput(1);
        plot(x,y);
        %[in,on] = inpolygon(x,y,xPerimeter,yPerimeter);
        if numel(x) == 1
            plot(x,y,'x','color','y');
            plotCentroids.XData(end+1) = x;
            plotCentroids.YData(end+1) = y;
        end
%         if numel(x(in)) ~= 1 && ~isempty(x)
%             message = sprintf('Not inside ROI.');
%             uiwait(helpdlg(message));
%         end
        if isempty(x)
            break
        end
end

title('');
centroidsUpdated = xCentroids;
handles.centroidsUpdated = centroidsUpdated;
handles.plotCentroids = plotCentroids;
handles.xCentroids = xCentroids;
handles.yCentroids = yCentroids;
%handles.saveCentroidsIn = saveCentroidsIn;
set(handles.recountPericytes,'Enable','on')
guidata(hObject,handles);

function myKeyPressFcn(hObject, event)
global keyIsPressed
keyIsPressed  = 1;
disp('key is pressed')

% --- Executes on button press in recountPericytes.
function recountPericytes_Callback(hObject, eventdata, handles)
% hObject    handle to recountPericytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
title('');
plotCentroids = handles.plotCentroids;
%areaOfROI_mm = handles.areaOfROI_mm;
newCentroids = numel(plotCentroids.XData);
%newPericytesPerArea = newCentroids/areaOfROI_mm;
fprintf('Found %d total pericytes.\n', newCentroids);

%caption = sprintf('Found %d pericytes inside ROI (%d pericytes/mm^2)', newCentroids, newPericytesPerArea);
%title(caption);

handles.plotCentroids = plotCentroids;
set(handles.saveCounts,'Enable','on')
guidata(hObject,handles);
% newCentroidCount = evalin('base', 'centroids');
% numSpotsInROI = numel(newCentroidCount);
% newCentroids = evalin('base','addedCentroids');
% newSpotsInROI = numel(newCentroids);
% newSpots = newSpotsInROI + numSpotsInROI;
% fprintf('Found %d pericytes inside ROI.\n', newSpots);


% --- Executes on button press in removePericytes.
function removePericytes_Callback(hObject, eventdata, handles)
% hObject    handle to removePericytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotCentroids = handles.plotCentroids;
xCentroids = handles.xCentroids;
yCentroids = handles.yCentroids;

%saveCentroidsIn = handles.saveCentroidsIn;

caption = sprintf('Click and drag to draw a box over pericytes to delete. Selected perictytes will be marked with a red dot. Right click and select remove.');
title(caption);
%set(plotCentroids,'XDataSource','saveCentroidsIn');
%linkdata on;
brush on;

centroidsUpdated = xCentroids;
handles.centroidsUpdated = centroidsUpdated;
handles.plotCentroids = plotCentroids;
handles.xCentroids = xCentroids;
handles.yCentroids = yCentroids;
%handles.saveCentroidsIn = saveCentroidsIn;
set(handles.recountPericytes,'Enable','on')
guidata(hObject,handles);


% --- Executes on button press in countPericytesInROI.
function countPericytesInROI_Callback(hObject, eventdata, handles)
% hObject    handle to countPericytesInROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% image2 = handles.image2;
% image2 = im2bw(image2,0.5);

xPerimeter = handles.xPerimeter;
yPerimeter = handles.yPerimeter;
plotCentroids = handles.plotCentroids;
sampleName = handles.sampleName;
% xCentroids = handles.xCentroids;
% yCentroids = handles.yCentroids;
% 
% if ndims(image2) > 1
% 	image2 = image2(:,:,1);
% end


%areaOfROI_mm = handles.areaOfROI_mm;
newCentroids = numel(plotCentroids.XData);
%newPericytesPerArea = newCentroids/areaOfROI_mm;


% props = regionprops(image2, 'centroid');
% 
% centroids = vertcat(props.Centroid);
% centroids = cat(1,props.Centroid);
% numspots = numel(props); % count objects
% fprintf('Found %d pericytes.\n', numspots);
% 
% xCentroids = centroids(:,1);
% yCentroids = centroids(:,2);


[in,on] = inpolygon(plotCentroids.XData,plotCentroids.YData,xPerimeter,yPerimeter);
saveCentroidsIn = plotCentroids.XData(in);
% handles.xCentroids = xCentroids;
% handles.yCentroids = yCentroids;
numSpotsInROI = numel(saveCentroidsIn);
fprintf('Found %d pericytes inside ROI.\n', numSpotsInROI);

%numel(xCentroids(on))
%numel(xCentroids(~in))
%imshow(image2); %hold on
%plot(centroids(:,1),centroids(:,2),'x')

%roi = plot(xPerimeter, yPerimeter, 'y.-', 'LineWidth', 2, 'MarkerSize', 15);
% %roi = roipoly(image2,xPerimeter,yPerimeter);
% newimage = imcrop(image2, roi);
%imshow(newimage)

plotROI = plot(xPerimeter,yPerimeter,'y.-', 'LineWidth', 2, 'MarkerSize', 15);
areaOfROI = polyarea(xPerimeter,yPerimeter);
areaOfROI_mm = areaOfROI/(1538*1538);
pericytesPerArea = numSpotsInROI/areaOfROI_mm;

caption = sprintf('Found %d pericytes inside ROI (%d pericytes/mm^2)', numSpotsInROI, pericytesPerArea);
title(caption);

% hold on
% plotCentroids = plot(saveCentroidsIn,yCentroids(in),'x', 'color', 'm', 'linewidth', 4);
% 

%save pericyte numbers 
handles.saveCentroidsIn = saveCentroidsIn;
handles.areaOfROI_mm = areaOfROI_mm;
handles.plotCentroids = plotCentroids;
handles.plotROI = plotROI;

%handles.centroids = centroids;
label = handles.label;

set(handles.countPericytes,'Enable','off')

plotCentroids = handles.plotCentroids;

areaOfROI_mm = handles.areaOfROI_mm;

saveCentroidsIn = handles.saveCentroidsIn;
numSpotsInROI = numel(saveCentroidsIn);
pericytesPerArea = numSpotsInROI/areaOfROI_mm;

fileNameToLoad = append(sampleName, '_pericyteQuantification.mat');
matFileToLoad = fileNameToLoad;
if exist(matFileToLoad,'file') 
   % file exists so load it and append the new ROI to it
   fileData = load(matFileToLoad);
   pericyteData = fileData.pericyteData;
else
   pericyteData = struct('label',{},'numberPericytes',{}, 'pericytesPerSquareMillimeter', {});
end

currentLabel = handles.label;
currentNumberPericytes = numSpotsInROI;
currentPericytesPerArea = pericytesPerArea;
currentArea = areaOfROI_mm;
pericyteData(end+1).label = currentLabel;
pericyteData(end).numberPericytes = currentNumberPericytes;
pericyteData(end).pericytesPerSquareMillimeter = currentPericytesPerArea;
pericyteData(end).areaOfROI = currentArea;
save(matFileToLoad,'pericyteData');

guidata(hObject,handles);


% --- Executes on button press in loadSavedCounts.
function loadSavedCounts_Callback(hObject, eventdata, handles)
% hObject    handle to loadSavedCounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sampleName = handles.sampleName;
fname = append(sampleName, '_pericyteCounts.mat');
load (fname, "xCentroids")
load (fname, "yCentroids")
xCentroids = xCentroids(:,1);
yCentroids = yCentroids(:,1);

hold on
plotCentroids = plot(xCentroids,yCentroids,'x', 'color', 'y', 'linewidth', 1);

handles.plotCentroids = plotCentroids;
handles.xCentroids = xCentroids;
handles.yCentroids = yCentroids;

set(handles.countPericytes,'Enable','off')
set(handles.loadSavedCounts,'Enable','off')
set(handles.addPericytes,'Enable','on')
set(handles.removePericytes,'Enable','on')
set(handles.drawROI,'Enable','on')

colormap gray;
g = gcf;

guidata(hObject,handles);

% --- Executes on button press in saveCounts.
function saveCounts_Callback(hObject, eventdata, handles)
% hObject    handle to saveCounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotCentroids = handles.plotCentroids;
xCentroids = plotCentroids.XData;
yCentroids = plotCentroids.YData;
sampleName = handles.sampleName;

xCentroids = xCentroids';
yCentroids = yCentroids';


fileAppend = '_pericyteCounts.mat';
filename = append(sampleName, fileAppend); 
save(filename', 'xCentroids','yCentroids')


set(handles.countPericytes,'Enable','off')
set(handles.loadSavedCounts,'Enable','off')
set(handles.addPericytes,'Enable','on')
set(handles.removePericytes,'Enable','on')
set(handles.drawROI,'Enable','on')

guidata(hObject,handles);
