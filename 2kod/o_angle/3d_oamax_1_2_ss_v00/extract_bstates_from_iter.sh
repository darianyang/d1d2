#!/bin/bash
# go into an WE traj_segs iteration and grab each rst file
# put the rst files into new directory with updated file naming
# this new directory will be the new bstates for a follow-up simulation

ITER=traj_segs/001500
destination_dir=dry_3d_oamax_1_2_ss_v00_i1500

# Create a counter variable
counter=0

# Create the output file in the destination directory
output_file="$destination_dir/bstates.txt"

# make new dir if needed
mkdir -p $destination_dir

# Loop through immediate subdirectories in the source directory
for sub_dir in "$ITER"/*/; do
  # Remove the trailing slash
  sub_dir="${sub_dir%/}"  
  # If you want to extract just the directory name from path
  sub_dir_name=$(basename "$sub_dir")
  
  # Check if the seg.rst file exists in the subdirectory
  if [ -f "$sub_dir/seg-nowat.ncrst" ]; then
    # Copy the seg.rst file to the destination directory 
    # with the subdirectory name as the new filename
    cp -v "$sub_dir/seg-nowat.ncrst" "$destination_dir/${sub_dir_name}.rst"
    #echo "Copied and renamed $sub_dir/seg.rst to $destination_dir/${sub_dir_name}.rst"

    # Add the entry to the output file in the specified format
    echo "$counter 1 $destination_dir/${sub_dir_name}.rst" >> "$output_file"
    
    # Increment the counter
    counter=$((counter + 1))
  else
    echo "File seg.rst not found in ${sub_dir}"
  fi
done
