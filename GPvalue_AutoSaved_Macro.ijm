macro "Subtract and Add Measurements" {
    // Ensure two images are open
    if (nImages < 2) {
        exit("You must have at least two images open.");
    }

    // Get the original image title (assumes first image as reference)
    originalImageTitle = getTitle();
    originalImageTitle = replace(originalImageTitle, ".tif", ""); // Remove extension if present
    originalImageTitle = replace(originalImageTitle, ".tiff", "");

    // Define the processing suffix automatically
    processSuffix = "_GP"; // Modify this as needed

    // Define the base directory where the new folder will be created
    baseDir = "D:/Desktop/PhD Project/Course Progress/4to Sem/GP_MSSR_Analysis/Automated Fiji Analysis/Riken_n2_240417/"; // Change as needed

    // Define the custom directory name
    customFolder = "GP_Values"; // Modify this as needed

    // Create the output directory path
    outputDir = baseDir + customFolder;

    // Ensure proper path formatting
    outputDir = replace(outputDir, "\\", "/");

    // Create the directory if it doesn’t exist
    File.makeDirectory(outputDir);

    // Select first image and measure
    selectImage(1);
    run("Measure");
    v1 = getResult("Mean", nResults - 1);

    // Select second image and measure
    selectImage(2);
    run("Measure");
    v2 = getResult("Mean", nResults - 1);

    // Compute subtraction
    subtractedValue = v1 - v2;

    // Compute addition
    addedValue = v1 + v2;

    // Compute division (handle zero division case)
    if (addedValue != 0) {
        dividedValue = subtractedValue / addedValue;
    } else {
        dividedValue = "Undefined (division by zero)";
    }

    // Display results in log window
    print("Measurement subtraction result: " + subtractedValue);
    print("Measurement addition result: " + addedValue);
    print("Division (subtracted / added) result: " + dividedValue);

    // Get current row count before adding results
    currentRow = nResults;

    // Save results to Results Table (ensuring sequential rows)
    setResult("Metric", currentRow, "Subtracted Value");
    setResult("Value", currentRow, subtractedValue);

    setResult("Metric", currentRow + 1, "Added Value");
    setResult("Value", currentRow + 1, addedValue);

    setResult("Metric", currentRow + 2, "Divided Value");
    setResult("Value", currentRow + 2, dividedValue);

    updateResults();

    // Construct the full path for saving the Results Table
    resultsFilename = outputDir + "/" + originalImageTitle + processSuffix + ".csv";

    // Save the Results Table
    saveAs("Results", resultsFilename);
}
