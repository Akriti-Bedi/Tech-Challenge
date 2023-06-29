function Get-NestedObjectValue {
    param (
        [Parameter(Mandatory = $true)]
        [Object]$Object,
        
        [Parameter(Mandatory = $true)]
        [String]$Key
    )
    
    $keys = $Key -split '/'
    $value = $Object
    
    foreach ($k in $keys) {
        if ($value -isnot [System.Collections.IDictionary]) {
            throw "Invalid key or object structure"
        }
        
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
