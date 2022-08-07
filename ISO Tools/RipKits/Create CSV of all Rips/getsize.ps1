switch((ls -r|measure -sum Length).Sum) {
  {$_ -gt 1GB} {
    '{0:0.0} GB' -f ($_/1GB)|Out-File -Encoding utf8 -FilePath "$PSScriptRoot\size.txt"
    break
  }
  {$_ -gt 1MB} {
    '{0:0.0} MB' -f ($_/1MB)|Out-File -Encoding utf8 -FilePath "$PSScriptRoot\size.txt"
    break
  }
  {$_ -gt 1KB} {
    '{0:0.0} KB' -f ($_/1KB)|Out-File -Encoding utf8 -FilePath "$PSScriptRoot\size.txt"
    break
  }
  default { "$_ bytes" }
}