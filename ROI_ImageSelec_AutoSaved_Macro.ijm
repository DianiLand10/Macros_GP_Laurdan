// Prompt user to open the desired image
waitForUser("Please open the desired image, then click 'OK' to continue.");

// Ensure an image is open before proceeding
if (nImages == 0) {
    exit("No image is open! Please open an image and run the macro again.");
}

// Store the image title
originalImage = getTitle();

// Select the first ROI in the ROI Manager
roiManager("Select", 0);

// Create a rectangle selection (initial position)
makeRectangle(321, 410, 180, 180);

// Allow user to manually adjust the rectangle
waitForUser("Adjust the rectangle selection, then click 'OK' to continue.");

// Store the manually adjusted rectangle coordinates
getSelectionBounds(x, y, w, h);

// Define the base directory where the new folder will be created
baseDir = "D:/Desktop/PhD Project/Course Progress/4to Sem/GP_MSSR_Analysis/Automated Fiji Analysis/BencilA_250425/";  // Change this path as needed

// Define the custom directory name
customFolder = "TwoChannels"; // Modify as needed

// Create the output directory path
outputDir = baseDir + customFolder;

// Ensure proper path formatting
outputDir = replace(outputDir, "\\", "/");

// Create the directory if it doesn’t exist
File.makeDirectory(outputDir);

// ---------------------------
// PROCESS CHANNEL 1
// ---------------------------
run("Set Slice...", "slice=1");
run("Duplicate...", "title=Channel_1");

// Ensure Channel_1 is active
selectImage("Channel_1");

// Construct filename and save
ch1Filename = outputDir + "/" + replace(originalImage, ".tif", "") + "_Ch1.tif";
saveAs("Tiff", ch1Filename);

// ---------------------------
// PROCESS CHANNEL 2
// ---------------------------
selectImage(originalImage);
makeRectangle(x, y, w, h);
run("Set Slice...", "slice=2");
run("Duplicate...", "title=Channel_2");

// Ensure Channel_2 is active
selectImage("Channel_2");

// Construct filename and save
ch2Filename = outputDir + "/" + replace(originalImage, ".tif", "") + "_Ch2.tif";
saveAs("Tiff", ch2Filename);

// ---------------------------
// CLEANUP & NOTIFICATION
// ---------------------------
selectImage(originalImage);
close();
print("Images saved successfully in: " + outputDir);
