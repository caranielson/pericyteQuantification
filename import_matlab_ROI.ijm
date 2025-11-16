//roiManager("Delete");

//run("Table... ", "open=[Y:/Cara data/SwDI Pericyte Quantification/roi_analysis/10/10-tdTomato-dapi_visual layer 4 chunk 2.csv]");


xPerimeter = Table.getColumn("xPerimeter");
yPerimeter = Table.getColumn("yPerimeter");
title = Table.title;
makeSelection("polygon", xPerimeter, yPerimeter);
run("ROI Manager...");
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", title);
//run("Duplicate...", " ");
//setBackgroundColor(0, 0, 0);
//run("Clear Outside");


run("Measure");
run("Summarize Skeleton");