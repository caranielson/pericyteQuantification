# pericyteQuantification
1.	Ilastik
a.	Create a pixel classification project. 
b.	In ‘Input Data’ upload the images you want to analyze (PNG works best). 
c.	In ‘Select Features’ check every box up to sigma = 5.00.
d.	In ‘Training’ create a label for each object.
i.	For PDGFRBCre-tdTomato animals I create a label for pericyte soma, pericyte processes, arterioles, and background. 
e.	Train the algorithm by drawing each label onto your images. 
f.	Click ‘Live Update’ to see what the probability maps currently look like. 
i.	Toggle the eyes in the bottom left menu to see the predictions for each label. Look at the prediction for each, not the segmentation.
g.	In ‘Prediction Export’ click ‘Choose Export Image Settings.’
i.	Convert to Data Type: unsigned 8-bit
ii.	Renormalize [min,max] from: 0 - 1 to 0 - 255.
iii.	Format: tif.
iv.	File: select folder you want the data to save to.
h.	Click ‘Export All’ to export the probability maps for all the uploaded images. 


2.	FIJI
a.	Upload the probability map exported from Ilastik.
b.	Split the channels. 
c.	Save pericyte soma channel, make sure each file ends in _0.tiff 
i.	This just makes sure that the file is processed properly in the next step.


3.	CellProfiler
a.	Open the file pericyteAnalysis.cpproj. 
b.	In ‘Images’ upload all pericyte probability masks (files that end in _0.tiff).
c.	In ‘SaveImages’ specify where you want the files to save in ‘Output file location.’
d.	Click Analyze all in bottom left.
e.	Binary pericyte masks will save to selected folder and all files will end in PericyteMask.tiff
f.	If you don’t like the output you can mess with the threshold and diameter filters in ‘IdentifyPrimaryObjects.’
i.	Diameter filter = ‘Typical diameter of objects, in pixel units (Min,Max).’
ii.	Threshold filter = ‘Manual threshold.’


4.	MATLAB 
a.	Make sure the files pericyteAnalysis.m and pericyteAnalysis.fig are in the same folder.
b.	Open pericyteAnalysis.m. 
c.	In line 255, set the scale of your images. 
i.	Change 1538*1538 to whatever your images are in pixels/mm (change both numbers). 
d.	Click green run arrow in top toolbar and a GUI will appear.
e.	Click ‘Load Original Image’ and select your original image with all channels intact.
i.	Image will appear within the axes. 
f.	Click ‘Load Pericyte Mask’ and select the pericyte mask exported from CellProfiler.
i.	Done loading when the path appears at the bottom in the ‘Mask Path’ box. 
g.	Load markers for pericyte cell bodies
i.	Click ‘Detect Pericytes’ to show all pericyte cell bodies picked up from the machine learning pipeline.
OR
ii.	Click ‘Load Saved Counts’ if you have already edited the counts for an image.
h.	Go through and check the image for quality.
i.	Click ‘Remove Pericytes’ to delete objects that aren’t pericytes. Instructions will appear above the images. 
ii.	Click ‘Add Pericytes’ to manually add pericytes that were missed. Instructions will appear above the image
i.	Click ‘Recount Total Pericytes’ to update the pericyte count after adding or removing cells.
j.	Click ‘Save Counts’ to save the new pericyte soma locations after adding or removing cells (saves as ‘filename_pericyteCounts.mat’). 
k.	To draw ROI’s for regional analysis:
i.	Click ‘Draw ROI’ and specify a name for your ROI. 
ii.	Click ‘Count Pericytes in ROI’ and yellow crosshairs will appear on each detected pericyte and the number of pericytes will be displayed on the top. Will need to click this again if you do any more adding/removing after this step.
iii.	Data will save to the directory you are working in. The file will be called pericyteQuantification.mat. Open this file with MATLAB to see all your saved data. If you recounted cells in the ROI, the current number is the one closest to the bottom of the list. ROI coordinates will also be saved so vessel density can be calculated in imageJ.


5.	Vessel Density analysis in ImageJ.
a.	Make sure you have the lectin channel saved individually. 
b.	Open the ‘skeletonize.ijm’ macro.
c.	Click run and you’ll be prompted to select the lectin channel to run the analysis on.
i.	The final skeleton will save to the same folder. 
d.	Select Analyze>Skeleton>Summarize skeleton to get the total vascular length.  
e.	For vessel density analysis on ROI’s from ImageJ:
i.	Open the ‘import_matlab_ROI.ijm’ macro. 
ii.	Open the skeletonized lectin image. 
iii.	Select File>Import>Table and select ROI file exported from MATLAB.
iv.	Run the ‘import_matlab_ROI.ijm’ macro.
v.	Record the ROI area and skeleton length. 
