#!/bin/bash

# Make sure to run this script while inside of 'src' directory, not from root jest-roblox

project_config_name="default.project.json"

for json_file in $(find . -name "$project_config_name")
do
  project_name=$(grep -o '"name": *"[^"]*"' $json_file | grep -o '"[^"]*"$')
  project_name=$(echo "$project_name" | tr -d '"')
  project_dir=$(dirname $json_file)
  project_dir_name=$(basename $(dirname $json_file))

  if [ "$project_name" == "$project_dir_name" ]; then
      echo "$project_name was already made flat"
  else
      echo "Flatifying $project_dir_name to $project_name ..."
      mv ${project_dir}/src/* $project_dir

      mkdir ${project_dir}/"__project"
      mv ${project_dir}/src/ ${project_dir}/"__project"
      mv $json_file ${project_dir}/"__project"/__$project_config_name
      mv ${project_dir}/README.md ${project_dir}/"__project"
      
      mv ${project_dir} $(dirname ${project_dir})/"$project_name"
  fi
done

echo "Finished Flatifying"