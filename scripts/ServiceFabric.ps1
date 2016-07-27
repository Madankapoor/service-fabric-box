$path = Resolve-Path "."
$zipfile = "Microsoft.Azure.ServiceFabric.WindowsServer.zip"

wget http://go.microsoft.com/fwlink/?LinkId=730690 -OutFile $zipfile
#Expand-Archive -LiteralPath $zipfile -DestinationPath (Join-Path $path -ChildPath ([io.fileinfo] $zipfile | % basename))

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
Unzip (Resolve-Path $zipfile) (Join-Path (Resolve-Path $path) -ChildPath ([io.fileinfo] $zipfile | % basename))



