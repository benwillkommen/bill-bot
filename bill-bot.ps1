﻿import-module ($psscriptroot + "\lib\movewindow.ps1")
import-module ($psscriptroot + "\lib\embiggen.ps1")
import-module ($psscriptroot + "\lib\SetConsoleFont.psm1")

set-consolefont 0
move-window
embiggen

get-content ($psscriptroot + "\data\bill-ascii.txt")

Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

$requestCountFileName = ".\request-count-" + (Get-Date -Format "dd-MM-yyyy") + ".txt"
$jokesCacheFileName = ".\jokes-cache.json"

if(-not (Test-Path $requestCountFileName))
{
    "0" | Out-File -FilePath $requestCountFileName
}

$requestCount = 0 + (Get-Content $requestCountFileName)

if(-not (Test-Path $jokesCacheFileName))
{
    $defaultJokes = "['A man received a phone call one day, and the caller asked if he had lost a parrot. He said that he had indeed lost the bird, but wanted to know how the caller located him.The called said that the bird had landed on his balcony and kept repeating, \'Hi, you have reached 555-1234. I can\'t come to the phone right now, please leave a message at the tone.\'']"
    $defaultJokes | Out-File -FilePath $jokesCacheFileName
}

$cachedJokes = Get-Content -Path $jokesCacheFileName | ConvertFrom-Json

if($requestCount -ge 8)
{
    $speak.Speak("Sorry, you've exceeded the joke API request limit. Here is a cached joke.")
    $speak.Speak($cachedJokes[(Get-Random -Minimum 0 -Maximum $cachedJokes.Length)])
}
else{
    $uri = "https://webknox-jokes.p.mashape.com/jokes/random"
    $headers = @{"X-Mashape-Key" = $env:JokesAPIKey; "Accept" = "application/json"}
    $response = Invoke-WebRequest -Headers $headers -Uri $uri

    $requestCount = 1 + $requestCount
    $requestCount | out-file -FilePath $requestCountFileName

    $joke = ($response | Convertfrom-Json).joke
    $cachedJokes + $joke | ConvertTo-Json -Compress | Out-File -FilePath $jokesCacheFileName

    Write-Host $joke 
    $speak.Speak($joke)
}


