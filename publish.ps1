trap {
    write-host "Error found: $_" -f red
    exit 1
}
$root = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageJobName = $Env:PACKAGE_JOB_NAME
$packageJobNumber = $Env:PACKAGE_JOB_NUMBER

$versionUrl = "http://10.18.8.119:8080/job/$packageJobName/$packageJobNumber/artifact/tmp/pkgs/version.txt" 

$request = [System.Net.HttpWebRequest]::Create($versionUrl)
$request.Headers.Add([System.Net.HttpRequestHeader]::AcceptEncoding, "gzip,deflate")
$request.AutomaticDecompression = ([System.Net.DecompressionMethods]::GZip -bor [System.Net.DecompressionMethods]::Deflate)

Write-Host "Begin download version file from: $versionUrl"
$response = $request.GetResponse()
$sr = new-object System.IO.StreamReader $response.GetResponseStream()
$version = $sr.ReadToEnd()
$response.close()
$version = $version.trim()

Copy-Item "\\10.18.7.148\c$\nuget-servers\nuget-pkgs-tmp\NScaffold.NuDeploy\NScaffold.NuDeploy.$version.nupkg" "\\10.18.7.148\c$\nuget-servers\nuget-pkgs-integration\NScaffold.NuDeploy\"
