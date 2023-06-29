echo "Enter Resource_group name" 
read $resource_group
echo "Enter Virtual Machine name" 
read $vm_name

# Get the metadata for the instance
metadata=$(az vm show -g $resource_group -n $vm_name --query "osProfile" -o json)

# Prints metadata
echo $metadata
