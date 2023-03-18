
$currentDirectory = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)


$files = Get-ChildItem -Path $currentDirectory\files\ -Recurse -Include *.csv

foreach ($file in $files){
    
    $objectname = (Get-Item $file).BaseName

    #$file = "$f"

    $dat = get-content $file

    $headers = $dat | select -first 1

    $headers = $headers -split ","

    $dt = Import-Csv $currentDirectory\mapping.csv

    $row = 0
    $headers| foreach-object {
            $head_name = $_

            $dt|Where-Object {$_.filename -eq $objectname}| ForEach-Object  {
                $filename = $_.filename
                $lower = $_.lower
                $value = $_.value 
                
                $r = $head_name.ToLower()
                 
             

                if(($head_name.ToLower() -eq $lower) -and ($objectname -eq $filename) -and ($head_name -cne $value)) 
                {
                     $headers[$row] = $value  
                     Write-Output ("Changed header in file $filename from $head_name to $value")
                     
                }
            
            }
    $row++
    }

    $headers = $headers -join ","

    $dat[0] = $headers

    $dat | set-content $file

   }
