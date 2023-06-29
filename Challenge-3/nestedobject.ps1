function Get-NestedObjectValue($object, $key) {
  # Split the key into an array of strings.
  $key_parts = $key.Split("/")

  # Iterate through the key parts and get the value of the object at each level.
  $current_object = $object
  foreach ($key_part in $key_parts) {
    $current_object = $current_object.$key_part
  }

  # Return the value of the object.
  return $current_object
}

# Example 1
$object = {"a":{"b":{"c":"d"}}}
$key = "a/b/c"
$value = Get-NestedObjectValue($object, $key)
Write-Host $value
