// Prompt user to open the desired image
waitForUser("Please open the desired image, then click 'OK' to continue.");

// Ensure an image is open before proceeding
if (nImages == 0) {
    exit("No image is open! Please open an image and run the macro again.");
}

// Store the image title (remove extensions if present)
originalImage = getTitle();
originalTitle = replace(originalImage, ".tif", "");
originalTitle = replace(originalTitle, ".tiff", "");

// Define the base directory where the new folder will be created
baseDir = "D:/Desktop/PhD Project/Course Progress/4to Sem/GP_MSSR_Analysis/Automated Fiji Analysis/Riken_n2_240417/"; // Change as needed

// Define the custom directory name for analysis results
customFolder = "MSSR&Corr_Results"; 

// Create the output directory path
outputDir = baseDir + customFolder;

// Ensure proper path formatting
outputDir = replace(outputDir, "\\", "/");

// Create the directory if it doesn’t exist
File.makeDirectory(outputDir);

// Select the first ROI in the ROI Manager
roiManager("Select", 0);

// Create a rectangle selection (initial position)
makeRectangle(321, 410, 180, 180);

// Allow user to manually adjust the rectangle
waitForUser("Adjust the rectangle selection, then click 'OK' to continue.");

// Store the manually adjusted rectangle coordinates
getSelectionBounds(x, y, w, h);

// Switch to Channel 1 before duplication
run("Set Slice...", "slice=1");

// Duplicate the selected area (Channel 1)
run("Duplicate...", "title=Channel_1");

// MSSR Analysis of midpiece
run("MSSR Analysis");
selectImage("Channel_1");

// Wait for user confirmation 
waitForUser("Wait until the MSSR plugin has finished processing, then click OK to continue.");

// Continue processing after MSSR is done
mssrImage = "Channel_1_MSSRa3f4o1_bicubic.tif";
selectImage(mssrImage);

// Ensure the correct selection is applied
makeRectangle(8, 7, 512, 512);

// Allow user to manually adjust the rectangle
waitForUser("Adjust the rectangle selection, then click 'OK' to continue.");

// Duplicate the selected area (MSSR_midpiece)
run("Duplicate...", "title=MSSR_midpiece");

// Ensure MSSR_midpiece is selected before processing
selectImage("MSSR_midpiece");

// **Ensure MSSR_midpiece matches expected size for FD Math**
getDimensions(width, height, channels, slices, frames);
expectedWidth = 512;
expectedHeight = 512;

if (width != expectedWidth || height != expectedHeight) {
    run("Size...", "width=512 height=512 interpolation=Bicubic");
    print("Resized MSSR_midpiece to match FD Math expected dimensions.");
}

// Set the MSSR image scale
selectImage("MSSR_midpiece");
run("Set Scale...", "distance=29.1261 known=1 unit=micron");

// Correlation analysis for midpiece diameter measurement
run("FD Math...", "image1=MSSR_midpiece operation=Correlate image2=MSSR_midpiece result=Result do");

// Ensure line selection is set correctly
makeLine(231, 236, 281, 280);

// Allow user to manually adjust the line
waitForUser("Adjust the line selection, then click 'OK' to continue.");

// Plot Profile after line selection
run("Plot Profile");

// ------------------------------
// SAVE MSSR_midpiece IMAGE
// ------------------------------
selectImage("MSSR_midpiece");

// Define processing suffix for MSSR_midpiece
processSuffix_MSSR = "_MSSR_Midpiece";

// Construct filename and full path
mssrFilename = outputDir + "/" + originalTitle + processSuffix_MSSR + ".tif";

// Save MSSR_midpiece image
saveAs("Tiff", mssrFilename);
print("MSSR_midpiece saved at: " + mssrFilename);

// ------------------------------
// SAVE PLOT PROFILE AS IMAGE (TIFF)
// ------------------------------

// Get the Plot Profile window and save it
plotImageTitle = "Plot of Result";
selectWindow(plotImageTitle);

// Construct filename for the TIFF image
plotTIFFFilename = outputDir + "/" + originalTitle + "_PlotProfile.tif";

// Save the plot profile as an image
saveAs("Tiff", plotTIFFFilename);
print("Plot Profile image saved at: " + plotTIFFFilename);

// Notify user
print("All files successfully saved in: " + outputDir);