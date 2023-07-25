
# delete a file or folder
# $Path the path
function delete {
  param(
    [Parameter()] [string] $Path
  )
  if (Test-Path -Path $Path -PathType Any) {
    Remove-Item -Recurse -Force $Path
    Write-Host "dlete $Path"
  }
}