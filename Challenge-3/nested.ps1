function Get-NestedObjectValue($Object, $Key) {
    
    $keys = $Key -split '/'
    $value = $Object
    
    foreach ($k in $keys) {
        
        if ($value.ContainsKey($k)) {
            $value = $value[$k]
        }
        else {
            throw "Key '$Key' not found"
        }
    }
    
    return $value
}

# Example usage:
$object = @{
    "a" = @{
        "b" = @{
            "c" = "d"
        }
    }
}

$key = "a/b/c"

$value = Get-NestedObjectValue -Object $object -Key $key
Write-Output $value
