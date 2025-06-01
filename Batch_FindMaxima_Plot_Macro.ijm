// Ask the user to select a folder containing the plot files
inputdir = getDirectory("Select the folder containing the plot files");

// Get the list of files in the folder
fileList = getFileList(inputdir);

// Initialize row index for Results Table
rowIndex = 0;

// Iterate through each file in the folder
for (f = 0; f < lengthOf(fileList); f++) {
    filePath = inputdir + fileList[f];

    // Open the file
    open(filePath); 
    
    // Get plot data (X and Y values)
    Plot.getValues(xValues, yValues);
    
    // Initialize variables
    numPoints = lengthOf(yValues);
    maximaX = newArray();
    maximaY = newArray();
    threshold = 0; // Modify if needed
    
    // Find maxima
    for (i = 1; i < numPoints - 1; i++) {
        if (yValues[i] > yValues[i - 1] && yValues[i] > yValues[i + 1] && yValues[i] > threshold) {
            // Store maxima values
            maximaX = Array.concat(maximaX, xValues[i]);
            maximaY = Array.concat(maximaY, yValues[i]);
        }
    }
    
    // Ensure at least one maximum is found
    if (lengthOf(maximaX) == 0) {
        print("No maxima detected above the threshold for: " + fileList[f]);
        close();
        continue;
    }
    
    // Save maxima values to Results Table
    for (i = 0; i < lengthOf(maximaX); i++) {
        setResult("File", rowIndex, fileList[f]);  // Store file name
        setResult("X", rowIndex, maximaX[i]);  // Store X values
        //setResult("Y", rowIndex, maximaY[i]);  // Store Y values
        rowIndex++;  // Increment row index manually
    }
    
    updateResults();
    
    // Close the processed plot
    close();
}

print("Batch processing complete!");
