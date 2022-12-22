// ImageJ Macro for Mitotracker Analysis
//Quantitative Imaging of Mitotracker-Red for PDOE/KD








// Select images folder
dir = getDirectory("Choose a Directory ");

// Inicialize choice variables
CHANNEL1 = newArray("none","ch00","ch01","ch02","ch03","ch04","ch05");
CHANNEL2 = newArray("ch00","ch01","ch02","ch03","ch04","ch05");
QUESTION = newArray("Yes","No");

// Choose image channels and threshold value
Dialog.create("Mitotracker analysis parameters");
Dialog.addChoice("Fluorescent Tag channel:  ", CHANNEL2, "ch00");
Dialog.addChoice("Mitotracker channel:  ", CHANNEL2, "ch01");
Dialog.show();

// Feeding variables from dialog choices
chA = Dialog.getChoice();
chB = Dialog.getChoice();


time0 = getTime();
setBatchMode(true);

// Folder management
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
if (hour<10) {hours = "0"+hour;}
else {hours=hour;}
if (minute<10) {minutes = "0"+minute;}
else {minutes=minute;}
if (month<10) {months = "0"+(month+1);}
else {months=month+1;}
if (dayOfMonth<10) {dayOfMonths = "0"+dayOfMonth;}
else {dayOfMonths=dayOfMonth;}


var Folder = 0;
results_Dir = dir + "Results "+year+"-"+months+"-"+dayOfMonths+" "+hours+"h"+minutes+ File.separator;
File.makeDirectory(results_Dir);

FluorescentTag_images_Dir = results_Dir + "Tag Images" + File.separator;
Folder = FluorescentTag_images_Dir;
newFolder();
Mitotracker_images_Dir = results_Dir + "Mitotracker Images" + File.separator;
Folder = Mitotracker_images_Dir;
newFolder();
Filtered_images_Dir = results_Dir + "Filtered images" + File.separator;
Folder = Filtered_images_Dir;
newFolder();



// Open and save images as 8 bits
listDir = getFileList(dir);
var s = 0;
for (i = 0; i < listDir.length; i++) {
	if (endsWith(listDir[i], chA+".tif")) {
		open(dir + listDir[i]);
		s=getTitle;
		run("8-bit");
		run("Grays");
		saveAs("tiff", FluorescentTag_images_Dir + substring(s,0,lengthOf(s)-9) + "_chA_8bits");
		close(); }
	if (endsWith(listDir[i], chB+".tif")) {
		open(dir + listDir[i]);
		s=getTitle;
		run("8-bit");
		run("Grays");
		saveAs("tiff", Mitotracker_images_Dir + substring(s,0,lengthOf(s)-9) + "_chB_8bits");
		close(); }
}



// MT analysis
listFTag = getFileList(FluorescentTag_images_Dir);
listMT = getFileList(Mitotracker_images_Dir);


var histoDir=0;
for (h = 0, j = h; h < listMT.length; h++, j++) {
	Name=newArray(listFTag.length);
	open(FluorescentTag_images_Dir+listFTag[h]);
	name = getTitle;
	Name[j] = substring(name,0,lengthOf(name)-14);
	rename("Image_1a.tif");
	run("Threshold...");
	setThreshold(9, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	//run("Close");
	run("Create Selection");
	open(Mitotracker_images_Dir+listMT[j]);
	run("Restore Selection");
	run("Clear Outside");
	saveAs("tiff", Filtered_images_Dir + Name[j] + "_filtered");
}


	//run("MiNA Analyze Morphology");
	//run("script:/Applications/Fiji.app/scripts/MiNA_Analyze_Morphology.py");














/*

open("/Users/Sean/Downloads/205-selected/205-PSDOE-GFP-MT-63X-8_ch00.tif");
selectWindow("205-PSDOE-GFP-MT-63X-8_ch00.tif");
run("8-bit");
setAutoThreshold("Default dark no-reset");
//run("Threshold...");
//setThreshold(9, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Close");
run("Create Selection");
open("/Users/Sean/Downloads/205-selected/205-PSDOE-GFP-MT-63X-8_ch01.tif");
selectWindow("205-PSDOE-GFP-MT-63X-8_ch01.tif");
run("Restore Selection");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("8-bit");
run("MiNA Analyze Morphology");
run("script:/Applications/Fiji.app/scripts/MiNA_Analyze_Morphology.py");
selectWindow("DUP_binary");
selectWindow("205-PSDOE-GFP-MT-63X-8_ch01.tif");

*/



/////////////////Functions///////////////////////////

function newFolder() {					// This function creates a folder, removing any existing file in a folder with the same name
	File.makeDirectory(Folder);
	listFolder = getFileList(Folder);
	for (i = 0; i < listFolder.length; i++) {
		File.delete(Folder+listFolder[i]); }
}



















