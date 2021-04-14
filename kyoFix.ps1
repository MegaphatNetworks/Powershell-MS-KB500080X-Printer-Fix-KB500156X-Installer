# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                                                   # # 
# #                                                                                                   # # 
# #                                  	 MS KB500080X System Patcher                             	  # # 
# #                                           by Gabriel Polmar                                       # # 
# #                                           Megaphat Networks                                       # # 
# #                                           www.megaphat.info                                       # #
# #                                                                                                   # # 
# #                                                                                                   # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

Function Say($something) {
	Write-Host $something 
}

Function SayB($something) {
	Write-Host $something -ForegroundColor darkblue -BackgroundColor white
}

SayB "Executing Patch Determination"

$OSInfo = (Get-ComputerInfo)
$OSW32 = (Get-WMIObject win32_operatingsystem)

Function Wait ($secs) {
	if (!($secs)) {$secs = 1}
	Start-Sleep $secs
}

Function isOSTypeHome {
	Return ($OSW32.Caption | select-string "Home")
}

Function getOSArch() {
	Return ($OSW32.OSArchitecture.Replace("-bit",""))
}

Function isOSTypePro {
	Return ($OSW32.Caption | select-string "Pro")
}

Function isOSTypeEnt {
	Return ($OSW32.Caption | select-string "Ent")
}

Function getWinVer {
	Return $($OSW32.version)
}

Function getWinVerMajor {
	Return ($OSW32.version.substring(0,$OSW32.version.indexof(".")))
}

function getMachineType() {
	Return ($OSInfo.OsProductType)
}

function getWin10Ver {
	Return ($OSInfo.WindowsVersion)
}

function getPSVerMajor() {
	return ((Get-Host).Version.Major)
}

Function isAdminLocal {
	Return (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
}

Function isAdminDomain {
	Return (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Domain Admins")
}

Function isElevated {
	Return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
}

Function regSet ($KeyPath, $KeyItem, $KeyValue) {
	$Key = $KeyPath.Split("\")
	ForEach ($level in $Key) {
		If (!($ThisKey)) {
			$ThisKey = "$level"
		} Else {
			$ThisKey = "$ThisKey\$level"
		}
		If (!(Test-Path $ThisKey)) {New-Item $ThisKey -Force -ErrorAction SilentlyContinue | out-null}
	}
	if ($KeyValue -ne $null) {
		Set-ItemProperty $KeyPath $KeyItem -Value $KeyValue -ErrorAction SilentlyContinue 
	} Else {
		Remove-ItemProperty $KeyPath $KeyItem -ErrorAction SilentlyContinue 
	}
}

Function regGet($Key, $Item) {
	If (!(Test-Path $Key)) {
		Return
	} Else {
		If (!($Item)) {$Item = "(Default)"}
		$ret = (Get-ItemProperty -Path $Key -Name $Item -ErrorAction SilentlyContinue).$Item
		Return $ret
	}
}

function isKbInstalled($hfid) {
	Return (get-hotfix | where {$_.hotfixid -eq $hfid} | select HotfixID).HotfixID
}

function findKbInstalled($hfid) {
	Return ($OSInfo.OsHotFixes | where {$_.hotfixid -eq $hfid} | select HotfixID).HotfixID
}


function getWUEXE() {
	if (!(Test-Path $env:systemroot\SysWOW64\wusa.exe)){
		Return "$env:systemroot\System32\wusa.exe"
	}  else {
		Return "$env:systemroot\SysWOW64\wusa.exe"
	}
}

function File-Exists($tFile) {
	if (!(Test-Path $tFile)) {Return $false} Else {Return $true}
}

function Elevate() {
	Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" elevate" -f $PSCommandPath) -Verb RunAs
}

# # # # # # # # # # # # # # # # # # # # 
# # # # BEGIN MAIN ROUTINES # # # # # # 
# # # # # # # # # # # # # # # # # # # #

if (isElevated -eq $false) {Elevate}

$winMver = getWinVerMajor
Say "Windows Version is $winMver"

$psMver = getPSVerMajor
Say "PowerShell Version is $psMver"

$PCType   = getMachineType
Say "This computer is a $PCType"

$w10ver = getWin10Ver
Say "Windows 10 Version $w10ver"

$WUEXE = getWUEXE
Say "Windows Update location acquired $WUEXE"

Say "Verifying system patch qualification"

If (!(regGet "HKLM:\SOFTWARE\MegaphatNetworks\KB500080X" "Patched")) {
	if ($winMver -eq 10) {
		#Does ths version of PS support our commands
		if ($psMver -ge '5') {
			if ($PCType -eq "Server") {
				# Response is or Server
				$ThisHF = "KB5000803"
				$newFixID = ""
				# $hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu"
				SayB "Not performing any action on a Server"
			} Else {
				Switch ($w10ver) {
					'2004' { # (version 2004)
						$ThisHF = 'KB5000802'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu" 
						$newFixID = "KB5001567"
						}
					'20H2' { # (version 20H2)
						$ThisHF = 'KB5000802'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu" 
						$newFixID = "KB5001567"
					} 
					'2009' { # (version 20H2)
						$ThisHF = 'KB5000802'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu" 
						$newFixID = "KB5001567"
					} 
					'1909' { # (version 1909)
						$ThisHF = 'KB5000808'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001566-x64_b52b66b45562d5a620a6f1a5e903600693be1de0.msu" 
						$newFixID = "KB5001566"
						} 
					'1903' { # (version 1909)
						$ThisHF = 'KB5000808'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001566-x64_b52b66b45562d5a620a6f1a5e903600693be1de0.msu" 
						$newFixID = "KB5001566"
						} 
					'1809' { # (version 1809)
						$ThisHF = 'KB5000809'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001568-x64_cbfb9504eda6bf177ad678c64b871a3e294514ce.msu" 
						$newFixID = "KB5001568"
					} 
					'1803' { # (version 1803)
						$ThisHF = 'KB5000822'
						$hfPatch = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001565-x64_18a2f1393a135d9c3338f35dedeaeba5a2b88b19.msu" 
						$newFixID = "KB5001565"
					} 
				}
			}
			$ihfi = (findKbInstalled $ThisHF) -or (isKbInstalled $ThisHF)
			if (($ihfi -eq $true) -and ($newFixID.length -gt 0)) {
				Say "HotFix ID $ThisHF has been found."
				Wait 1
				$outFile = $env:TEMP + "\" + $newFixID + ".msu"
				if (!(File-Exists $outfile)) {
					Say "Applying $newFixID to the system"
					Say "Downloading $hfPatch"
					Invoke-WebRequest -Uri $hfPatch -OutFile $outFile
					Say "Installing $outFile"
					Start-Process -FilePath $WUEXE -ArgumentList "$outFile /quiet /norestart" -Wait
					Say "System has been successfully patched.  Rebooting in 3 seconds..."
					regSet "HKLM:\SOFTWARE\MegaphatNetworks\KB500080X" "Patched" 1
					Wait 3
					# Restart-Computer
				} Else {
					Say "This system has already been patched"
				}
			} ElseIf (($ihfi -eq $true) -and ($newFixID.length -eq 0)) {
				Say "Not applying any fix on a server"
			} Else {
				Say "HotFix $ThisHF is NOT installed on this system"
			}
		} Else {Say "Wrong Version of PowerShell " + $psMver }
	}
}
# End of Script
