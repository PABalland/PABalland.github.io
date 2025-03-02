import os

def convert_jpg_to_lowercase(directory):
    # Walk through the directory and its subdirectories
    for root, dirs, files in os.walk(directory):
        for file in files:
            # Check if the file has an uppercase .JPG extension
            if file.endswith(".JPG"):
                # Create the new file name with lowercase extension
                new_file = file[:-4] + ".jpg"
                # Get the full paths for renaming
                old_path = os.path.join(root, file)
                new_path = os.path.join(root, new_file)
                # Rename the file
                os.rename(old_path, new_path)
                print(f"Renamed: {old_path} -> {new_path}")

# Specify the directory containing the files
directory = "C:/Users/leon.wolf/Desktop/cases"

# Call the function
convert_jpg_to_lowercase(directory)