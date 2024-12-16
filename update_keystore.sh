#!/bin/bash
#chmod +x update_keystore.sh

# List of Elasticsearch container names
CONTAINERS=("elastics3snapshot-es01-1" "elastics3snapshot-es02-1" "elastics3snapshot-es03-1")

# Check for required environment variables
if [ -z "$S3_ACCESS_KEY" ] || [ -z "$S3_SECRET_KEY" ]; then
  echo "Error: Please set S3_ACCESS_KEY and S3_SECRET_KEY environment variables before running the script."
  echo "Example: export S3_ACCESS_KEY=your_access_key"
  echo "         export S3_SECRET_KEY=your_secret_key"
  exit 1
fi

# Function to safely add credentials to the keystore
add_to_keystore() {
  local container=$1
  local key=$2
  local value=$3

  # Remove the key if it already exists
  if docker exec "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore list | grep -q "$key"; then
    echo "Key $key already exists in $container. Removing it..."
    docker exec "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore remove "$key" &>/dev/null
    if [ $? -ne 0 ]; then
      echo "Failed to remove $key from $container. Skipping..."
      return 1
    fi
  fi

  # Add the key to the keystore
  echo "Adding $key to $container..."
  printf "%s" "$value" | docker exec -i "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore add -x "$key" &>/dev/null
  if [ $? -ne 0 ]; then
    echo "Failed to add $key to $container. Please check the logs."
    return 1
  fi
}

# Iterate over each container
for container in "${CONTAINERS[@]}"; do
  echo "Processing container: $container"

  # Ensure the keystore exists
  if ! docker exec "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore list &>/dev/null; then
    echo "Creating keystore in $container..."
    docker exec "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore create &>/dev/null
    if [ $? -ne 0 ]; then
      echo "Failed to create keystore in $container. Skipping..."
      continue
    fi
  else
    echo "Keystore already exists in $container. Skipping creation."
  fi

  # Add S3 credentials to the keystore
  add_to_keystore "$container" "s3.client.default.access_key" "$S3_ACCESS_KEY"
  add_to_keystore "$container" "s3.client.default.secret_key" "$S3_SECRET_KEY"

  # List keystore entries to confirm
  echo "Keystore entries in $container:"
  docker exec "$container" /usr/share/elasticsearch/bin/elasticsearch-keystore list
  echo ""
done

echo "Keystore updates completed for all containers!"
