function KillThatProcess([string] $m_appName){

    $foundProcesses = 0

    try{
        $action = Get-Process $m_appName -ErrorAction Stop
        $validInput = 0
        $numOfProcesses = $action.Count
        $input = Read-Host("There are $numOfProcesses processes with the name $m_appName, proceed? Y/N")

        do{
            if($input.ToUpper() -eq "Y"){
                $action | spps
                $validInput = 1
            }elseif($input.ToUpper() -eq "N"){
                $validInput = 1
                break
            } else {
                Write-Host("Invalid input entered. Only Y or N are accepted")
            }
        }while($validInput -ne 1)

        $foundProcesses = 1

    } catch{
        Write-Host("There are no processes with the name of $m_appName. Exiting") -ForegroundColor Cyan
    }
    if($foundProcesses -eq 1){
        Bamboozle
    }
}
function ConvertImgToAsciiArt{
    param(
        [Parameter(Mandatory)][String]$Path,
        [ValidateRange(20,20000)][int]$MaxWidth=80,
        [float]$ratio= 1.5
    )


    Add-Type -AssemblyName System.Drawing
    $chars = '$#H&@*+;:-,. '.ToCharArray()
    $char = $chars.count

    $img = [Drawing.Image]::FromFile($Path)
    [int]$maxHeight = $img.Height/ ($img.Width/ $MaxWidth)/$ratio
    $bitmap = new-object Drawing.Bitmap($img, $MaxWidth, $maxHeight)

    [System.Text.StringBuilder]$strb = ""

    for([int]$y=0; $y -lt $bitmap.Height; $y++){
        for([int]$x=0; $x -lt $bitmap.Width; $x++){
            $pixel = $bitmap.GetPixel($x,$y)
            $brightness = $pixel.GetBrightness()
            [int]$offset = [Math]::Floor($brightness*$char)
            $ch = $chars[$offset]
            if(-not $ch){
                $ch = $chars[-1]
            }
            $null = $strb.Append($ch)
        }
        $null = $strb.Append("`r`n")
    }

    $img.Dispose()
    $strb.ToString()
}

function Bamboozle{
    Param(
        [Parameter(Mandatory=$false)] [string]$filePath = $(Get-Location)
    )

    $ASCIIRange = (97..122)
    $pathToImg = (Get-Location).ToString() + "\imgMsg.jpg"
    $outPath = "$env:temp\asciiart.txt"
    $selectedLetter = $ASCIIRange | Get-Random -Count 1 | % {[char] $_}

    if($filePath -match '\\$'){
        #do nothing file path is in correct format
    }else{
        $filePath = $filePath + '\'
    }

    #Use these lines if you also downloaded the hidden picture with the script
    #ConvertImgToAsciiArt -Path $pathToImg -MaxWidth 80 | Set-Content -Path $outPath -Encoding UTF8
    #Get-Content -Path $outPath

    Write-Host("The selected letter is $selectedLetter ¯\_(ツ)_/¯") -ForegroundColor Cyan -BackgroundColor DarkMagenta
    Write-Host("You did this to yourself (╯°□°)╯︵ llǝɥsɹǝʍoԀ") -ForegroundColor Cyan -BackgroundColor DarkMagenta
    Write-Host("Your files are belonging to me now ♪~ ᕕ(ᐛ)ᕗ") -ForegroundColor Cyan -BackgroundColor DarkMagenta

    
    $items = GetAllFiles $filePath $selectedLetter    
    $items | Remove-Item -WhatIf

    Read-Host("Done! :) Press any key to give up.")
    Start "https://www.youtube.com/watch?v=oHg5SJYRHA0"
}

function GetAllFiles{
    Param(
        $path,
        $letter
    )
    
    Get-ChildItem -Path $path*$letter*.*
}

KillThatProcess("notepad")
