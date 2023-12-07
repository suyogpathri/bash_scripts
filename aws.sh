#!/bin/bash

set -e

AMI_IDS=''
# Find the Jenkins instances
INSTANCES=$(aws ec2 describe-instances --region eu-central-1 --filters 'Name=tag:Name,Values=Jenkins*' --query "Reservations[*].Instances[*].{Instance:InstanceId}" --output text)

# Loop through the list of instances

for id in ${INSTANCES[@]}; do
  # Get the name of image
  NAME=$(aws ec2 describe-instances --region eu-central-1 --instance-id $id --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --output text)

  # Create Image of the current instance
  RUNING_AMI=$(aws ec2 create-image --region eu-central-1 --instance-id $id --name "$NAME"-"$(date '+%d-%m-%Y-%H-%M-%S')" --no-reboot --description "Backup Image of "$NAME --output text)
  AMI_IDS=$AMI_IDS" "$RUNING_AMI
done

for AMI_ID in ${AMI_IDS[@]}; do
  until [ $(aws ec2 describe-images --region eu-central-1 --image-ids $AMI_ID --query "Images[].[State]" --output text) = *"pending"* ]; do
    echo "Backup is running for AMI "$AMI_ID
    #sleep 60s
    if [ $(aws ec2 describe-images --region eu-central-1 --image-ids $AMI_ID --query "Images[].[State]" --output text) = "available" ]; then
      echo "Backup Finished for AMI "$AMI_ID

      # Find the old backup image
      AMI=$(aws ec2 describe-images --region eu-central-1 --owners 474975247937 --filters "Name=name,Values=Jenkins*" --query 'sort_by(Images, &CreationDate)[:1].ImageId' --output text)
      
      # Find the backup's snapshots
      SNAPSHOT=$(aws ec2 describe-snapshots --region eu-central-1 --filters "Name=description,Values=*$AMI*" --query "Snapshots[*].SnapshotId" --output text)
      
      # Delete both old AMI and snapshots
      aws ec2 deregister-image --region eu-central-1 --image-id $AMI
      aws ec2 delete-snapshot --region eu-central-1 --snapshot-id $SNAPSHOT
      break
    fi
  done
done