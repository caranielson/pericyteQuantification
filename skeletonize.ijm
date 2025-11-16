path = File.openDialog("Select a File");
dir = File.getParent(path);
name = File.getName(path);
print("Path:", path);
print("Name:", name);
print("Directory:", dir);
open(path); 


imgName= substring(path,0,lengthOf(path)-4);
print(imgName);

fileName= substring(name,0,lengthOf(name)-4);
print(fileName);

run("Auto Local Threshold", "method=Niblack radius=15 parameter_1=0 parameter_2=0 white");
run("Despeckle");
run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
run("Dilate (3D)", "iso=255");
setOption("BlackBackground", true);
run("Skeletonize");

saveAs("PNG", imgName+"-skeleton-initial.png");

run("Fill Holes");
run("Options...", "iterations=1 count=5 black do=Erode");

saveAs("PNG", imgName+"-skeleton-initial-holes.png");

run("Analyze Particles...", "size=0-2000 display add");

open(imgName+"-skeleton-initial.png");
selectImage(fileName+"-skeleton-initial.png");


count = roiManager("count");

array = newArray(count);
  for (i=0; i<array.length; i++) {
      array[i] = i;
  }

roiManager("select", array);

roiManager("Fill");
setAutoThreshold("Default dark");
run("Threshold...");
setThreshold(1, 255);
run("Convert to Mask");

run("Skeletonize");
run("Options...", "iterations=7 count=7 black do=Erode");

saveAs("PNG", imgName+"-skeleton-final.png");