#!/bin/bash
# go into an WE traj_segs iteration and grab each rst file
# put the rst files into new directory with updated file naming
# this new directory will be the new bstates for a follow-up simulation

WE=1d_oamax_v00
cd $WE
ITER=traj_segs/000100
destination_dir=1d_oamax_v00_i100_bs

# Create a counter variable
counter=0

# make new dir if needed
mkdir -p $destination_dir

# For the output file in the destination directory
output_file="$destination_dir/bstates.txt"

# Loop through immediate subdirectories in the source directory
for sub_dir in "$ITER"/*/; do
  # Remove the trailing slash
  sub_dir="${sub_dir%/}"  
  # If you want to extract just the directory name from path
  sub_dir_name=$(basename "$sub_dir")
  
  # Check if the seg.rst file exists in the subdirectory
  if [ -f "$sub_dir/seg.rst" ]; then
    # Copy the seg.rst file to the destination directory 
    # with the subdirectory name as the new filename
    cp -v "$sub_dir/seg.rst" "$destination_dir/${sub_dir_name}.rst"
    #echo "Copied and renamed $sub_dir/seg.rst to $destination_dir/${sub_dir_name}.rst"

    # Add the entry to the output file in the specified format
    echo "$counter 1 $destination_dir/${sub_dir_name}.rst" >> "$output_file"
    
    # Increment the counter
    counter=$((counter + 1))
  else
    echo "File seg.rst not found in ${sub_dir}"
  fi
done
