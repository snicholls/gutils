#!/bin/sh
for project in $(gcloud projects list --format="value(projectId)")
do
   
  echo "Checking Project: $project"
   
  # Set the current project
   
  gcloud config set project $project
   
  # Get all instances in the current project including the zone
   
  instances=$(yes | gcloud compute instances list --format="value(name,zone)")
   
  # Check if there are any instances
   
  if [-z"$instances"]; then
       
    echo $project ",has_no_instances,has_no_licenses"
       
    echo $project ",has_no_instances,has_no_licenses" >> /tmp/gcp_instance.out
   
  else   
  # Loop through the instances and get their details
       
    echo "$instances"| while read instance zone;do
           
    # Get instance details, extract license information, and format the output
           
      license_info=$(gcloud compute instances describe $instance --zone=$zone --format="json"| awk -F'/' '/licenses/ {getline; print $NF; exit}' | sed 's/\",//;s/\"//')
           
      echo $project","$instance","$license_info
           
      echo $project","$instance","$license_info >> /tmp/gcp_instance.out
       
    done
   
  fi
done
