# LetR © Andrey Karpov

param (
 [string]$Source = $PSScriptRoot, [string]$M = "*", [switch]$D, [switch]$B, [switch]$F, [switch]$S, [switch]$I, [switch]$R, $Z = 3
)

[Console]::CursorVisible = $false

$U = 0; $E = 0; $N = 0; $C = 0; $CD = 0; $SI = $I; $FI = $false; $P = ""

$Source = $Source.TrimEnd('\'); $Source = $Source.ToLower(); 

if ($Z -gt 4) { 
 $Z = 3
}

if ($D -and $B) {
 $D = $false; $B = $false;
}

# Mark of the Web (MotW)

$ZO = @(
 "[ZoneTransfer]"
 "ZoneId=$Z"
# "ReferrerUrl=www.localhost.com"
# "HostUrl=www.localhost.com/file"
# "AppZoneId=0"
# "HostIpAddress=1.1.1.1"
# "LastWriterPackageFamilyName=DFZ"
)

$DP = @{
 Filter = $M
 Recurse = $R
}

Function Zone {
 param ( $ZI )
 if ($ZI -is [string]) {
  $ZP = $ZI.Split('=')
 } else {
  $ZL = $ZI | Where-Object { $_.StartsWith('ZoneId=') }
  $ZP = $ZL.Split('=') 
 }
 return [int]$ZP[1]
}

Function ZoneInfo {
 param ( [int]$Zone )
 switch ($Zone) {
  0 { $Info = "Local Computer" }
  1 { $Info = "Local Intranet" }
  2 { $Info = "Trusted Sites" }
  3 { $Info = "Internet" }
  4 { $Info = "Restricted Sites" }
  default { $Info = "Unknown Zone" } 
 } return $Info
}

Function PN {    
 param ( [string]$N )
 if ($global:I) {
  if ($global:SI) {
   Write-Host " $N " -NoNewLine -ForegroundColor DarkYellow
   $global:SI = $false
  } else { 
   Write-Host " $N " -NoNewLine -ForegroundColor Magenta 
   $global:SI = $true
  }
 } else {
  Write-Host " $N " -NoNewLine -ForegroundColor DarkYellow
 }
}

Function PD {
 if (($global:CP -ne $Source) -and ($global:CP -ne $global:P)) {
  $W = $global:CP.Replace($Source + '\',''); $global:CD++
  Write-Host " $($W.ToUpper())" -NoNewLine -ForegroundColor Cyan
  Write-Host " $global:CD" -ForegroundColor Green
  $global:P = $_.DirectoryName
 }
}

Function PH {
 if (!$global:FI) {
  if ($global:D) {
   Write-Host "`n The files unblocking procedure has been started....`n" -ForegroundColor Cyan
  } elseif ($global:B) {
   Write-Host "`n The files blocking procedure has been started...`n" -ForegroundColor Yellow
  } else {
   Write-Host "`n Start Scanning Files...`n" -ForegroundColor DarkCyan
  }
  $global:FI = $true
 }
}

Function FA {
 param ( [string]$A )
 if ($A -band [System.IO.FileAttributes]::System) { Write-Host "s" -NoNewLine -ForegroundColor Red } else { Write-Host " " -NoNewLine }
 if ($A -band [System.IO.FileAttributes]::Hidden) { Write-Host "h" -NoNewLine -ForegroundColor Cyan } else { Write-Host " " -NoNewLine }
 if ($A -band [System.IO.FileAttributes]::ReadOnly) { Write-Host "r" -NoNewLine -ForegroundColor Yellow } else { Write-Host " " -NoNewLine }
 if ($A -band [System.IO.FileAttributes]::Archive) { Write-Host "a" -NoNewLine -ForegroundColor DarkGray } else { Write-Host " " -NoNewLine }
}

Function PB {
 PH; PD; FA $FF; PN $_.Name
}

try {
 
 Resolve-Path $Source -ErrorAction Stop | Out-Null
 
 if (Test-Path -LiteralPath $Source -PathType Container) {
  
  if (Get-ChildItem -LiteralPath $Source @DP -File -Force -ErrorAction SilentlyContinue | Select-Object -First 1) {
   
   Write-Host "`n Directory used: " -NoNewLine -ForegroundColor White; Write-Host $Source -ForegroundColor Cyan
   
   Get-ChildItem -LiteralPath $Source @DP -File -Force -ErrorAction SilentlyContinue | ForEach-Object { 
   
    $CP = $_.DirectoryName.ToLower()

    try {

     $FF = (Get-Item -LiteralPath $_.FullName -Force -ErrorAction Stop).Attributes

     $FZ = Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue
     
     if ($FZ) { 
      $ZI = Get-Content -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction Stop
      $EQZ = Zone ($ZI)
     } 
   
     if ($FZ -and !($B -and $F)) {
      try { 
       if (($D -and !$F) -or ($D -and $F -and ($EQZ -eq $Z))) { PB
        Unblock-File -LiteralPath $_.FullName -ErrorAction Stop
        if (-not (Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue)) { 
         Write-Host "Unlocked!" -ForegroundColor Cyan
         $U++; $C++
        } else {
         Write-Host "Blocked" -NoNewLine -ForegroundColor Yellow
         Write-Host " Failure" -ForegroundColor Red
         $E++; $C++
        }
       } elseif (($D -and !$S) -or ($B -and !$S) -or ($S -and ($EQZ -eq $Z) -and !$B) -or (!$S -and !$D -and !$B)) { PB
        Write-Host "Blocked" -NoNewLine -ForegroundColor Yellow
        Write-Host " $(ZoneInfo ($EQZ)) " -NoNewLine -ForegroundColor DarkCyan
        Write-Host $([string]::new('*',$EQZ)) -ForegroundColor Gray
        if ($B) { $N++ } elseif (!$D) { $U++ }      
       }
      } catch [System.UnauthorizedAccessException] {
       Write-Host "Access Denied!" -ForegroundColor Red
       $E++
      } catch [System.IO.IOException] {
       Write-Host "File is Locked!" -ForegroundColor Red
       $E++
      } catch {
       Write-Host " Error:" $_.Exception.Message -ForegroundColor Red
       $E++
      }
     } elseif ($B) {
       try {
        if ((!$FZ -and !$F) -or ($FZ -and ($EQZ -ne $Z))) { PB
         Set-Content -LiteralPath $_.FullName -Stream Zone.Identifier -Value $ZO -ErrorAction Stop
         if (Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue) {
          Write-Host "Blocked!" -ForegroundColor Yellow
          $U++; $C++
         } else {
          Write-Host "Failure!" -ForegroundColor Red
          $E++; $C++
         }
        } elseif (!$S) { PB
         if ($FZ) {
          Write-Host "Blocked" -NoNewLine -ForegroundColor Yellow
          Write-Host " $(ZoneInfo ($EQZ)) " -NoNewLine -ForegroundColor DarkCyan
          Write-Host $([string]::new('*',$EQZ)) -ForegroundColor Gray
         } else {
          Write-Host "Not Blocked" -ForegroundColor Green   
         }
         $N++ 
        } 
       } catch {
        if (!$FZ) {
         Write-Host "Not Blocked" -NoNewLine -ForegroundColor Green
         $C++
        } else {
         Write-Host "Blocked" -NoNewLine -ForegroundColor Yellow
        }
        Write-Host " Access Denied!" -ForegroundColor Red
        $E++       
       }
     } elseif (!$F -and !$S) { PB
       Write-Host "Not Blocked" -ForegroundColor Green
       $N++
     }
     
    } catch {
     PH; PD; FA $FF; PN $_.Name
     Write-Host "Reading Error!" $_.Exception.Message -ForegroundColor Red
     $E++
    }

   } | Out-Null

  } else {
   if ($M.Length -gt 1) {
    Write-Host "`n  Files matching the mask ""$M"" were not found in this directory!" -NoNewLine -ForegroundColor Cyan
   } else {
    Write-Host "`n  No files were found in this directory!" -NoNewLine -ForegroundColor Yellow
   }
   $FI = $true
  }

  if (($U + $E + $N) -or (($F -or $S) -and !$FI) -or ($F -and $D)) {
   if ($D) { 
    Write-Host "`n Processing is completed!`n" -ForegroundColor Cyan
    if ($U + $C) {
     Write-Host " Total files processed: " -NoNewLine -ForegroundColor White
     Write-Host $U -NoNewLine -ForegroundColor Cyan
     Write-Host " from " -NoNewLine -ForegroundColor White
     Write-Host $C -NoNewLine -ForegroundColor Yellow
     Write-Host " files, total " -NoNewLine -ForegroundColor White
     Write-Host $($U + $E + $N) -NoNewLine -ForegroundColor DarkYellow
     Write-Host " files" -NoNewLine -ForegroundColor White
    } else {
     if ($F) {
      Write-Host " There are no files to process..." -NoNewLine -ForegroundColor Yellow
     } else {
      Write-Host " There are no blocked files!" -NoNewLine -ForegroundColor Yellow
     }
    }
   } elseif ($B) {
    Write-Host "`n Processing is completed!`n" -ForegroundColor Yellow
    if ($U + $C) {
     Write-Host " Total files blocked: " -NoNewLine -ForegroundColor White
     Write-Host $U -NoNewLine -ForegroundColor Yellow
     Write-Host " from " -NoNewLine -ForegroundColor White
     Write-Host $C -NoNewLine -ForegroundColor Cyan
     Write-Host " files, total " -NoNewLine -ForegroundColor White
     Write-Host $($U + $E + $N) -NoNewLine -ForegroundColor DarkYellow
     Write-Host " files, blocking zone: " -NoNewLine -ForegroundColor White
     Write-Host $(ZoneInfo $Z) -NoNewLine -ForegroundColor DarkCyan  
    } else {
     if ($F) {
      Write-Host " There are no files to process..." -NoNewLine -ForegroundColor Cyan
     } else {
      Write-Host " There are no unlocked files!" -NoNewLine -ForegroundColor Cyan
     }
    } 
   } else {
    Write-Host "`n File Scanning Completed!`n" -ForegroundColor DarkCyan
    if ($U + $C) {
     Write-Host " Total files scanned: " -NoNewLine -ForegroundColor White
     Write-Host $($U + $N) -NoNewLine -ForegroundColor Green
     Write-Host " from " -NoNewLine -ForegroundColor White
     Write-Host $($U + $E + $N) -NoNewLine -ForegroundColor DarkYellow
     if ($U -and !($F -or $S)) { 
      Write-Host " files, of which blocked " -NoNewLine -ForegroundColor White
      Write-Host $U -NoNewLine -ForegroundColor Yellow
     } 
    Write-Host " files" -NoNewLine -ForegroundColor White
    } else {
     if ($S) {
      Write-Host " No files with zone ""$(ZoneInfo $Z)"" were found in this directory!" -NoNewLine -ForegroundColor Cyan 
     } else {
      Write-Host " No locked files were found in this directory!" -NoNewLine -ForegroundColor Cyan
     }
    }   
   }    
   if ($E) { 
    Write-Host ", with errors " -NoNewLine -ForegroundColor White
    Write-Host $E -NoNewLine -ForegroundColor Red
    Write-Host " files" -NoNewLine -ForegroundColor White
   }
  }
 } else {
  
  Write-Host "`n  This script only works with directories!" -NoNewLine -ForegroundColor Yellow  

 }

} catch {

 Write-Host "`n  $($_.Exception.Message)" -NoNewLine -ForegroundColor Red 

}

Write-Host "`n`n Press enter to exit or just close the window..." -ForegroundColor White

Read-Host

[Console]::CursorVisible = $true
