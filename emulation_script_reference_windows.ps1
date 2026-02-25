# =============================================================================
# ADVERSARY EMULATION SCRIPT - REFERENCE TEMPLATE (Windows)
# =============================================================================
#
# This file is the EXPECTED OUTPUT FORMAT for Skill 10 (Adversary Emulation
# Script Generation). When Skill 10 runs, it produces a populated version of
# this structure, replacing all <PLACEHOLDER> fields with real values derived
# from the detection blueprint and threat intelligence.
#
# Threat Actor / Campaign : <THREAT_ACTOR_OR_CAMPAIGN>
# Detection Blueprint     : <PATH_OR_LINK_TO_BLUEPRINT.md>
# ATT&CK Techniques       : <T1XXX, T1XXX.XXX, ...>  (populate from blueprint)
# Atomic Test IDs         : <see phase blocks below>
# Platform                : Windows 10/11 / Windows Server
# PowerShell Version      : 5.1+ (PowerShell Core 7+ recommended)
# Author                  : <AUTHOR>
# Date                    : <DATE>
# Version                 : 1.0
#
# References:
#   Atomic Red Team      : https://github.com/redcanaryco/atomic-red-team
#   Invoke-AtomicRedTeam : https://github.com/redcanaryco/invoke-atomicredteam
#   ATT&CK Navigator     : https://mitre-attack.github.io/attack-navigator/
#   Threat Intel Source  : <URL_OR_REPORT_REFERENCE>
#
# =============================================================================
# !! SAFETY WARNINGS — READ BEFORE EXECUTING !!
# =============================================================================
#
#  1. Run ONLY on an ISOLATED test machine — NOT on production endpoints.
#  2. Ensure your EDR / AV agent is installed, active, and reporting to SIEM
#     BEFORE executing this script.
#  3. Notify your security team of the test window in advance.
#  4. Some tests download prerequisites (Mimikatz, ProcDump, Rclone, etc.)
#     — internet access is required unless atomics are staged offline.
#  5. Run this script with ADMINISTRATOR privileges.
#  6. Some tests temporarily disable security controls. Re-enable them and
#     confirm EDR health after cleanup.
#  7. Review each atomic test at https://atomicredteam.io before running to
#     understand exactly what it does and what artifacts it leaves behind.
#  8. A system snapshot or backup is strongly recommended before execution.
#
# =============================================================================

#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force

# ---------------------------------------------------------------------------
# CONFIGURATION — adjust paths and timing to match your environment
# ---------------------------------------------------------------------------

$AtomicsPath       = "C:\AtomicRedTeam\atomics"
$LogPath           = "$env:TEMP\emulation_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$SleepBetweenTests = 5   # seconds to pause between tests; increase if EDR is slow to report

Write-Host "`n[*] Adversary Emulation — $(Get-Date)" -ForegroundColor Cyan
Write-Host "[*] Threat: <THREAT_ACTOR_OR_CAMPAIGN>" -ForegroundColor Cyan
Write-Host "[*] Log   : $LogPath`n" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# STEP 1 — INSTALL / VERIFY INVOKE-ATOMICREDTEAM
# ---------------------------------------------------------------------------

Write-Host "[*] Checking Invoke-AtomicRedTeam..." -ForegroundColor Yellow

if (-not (Get-Module -ListAvailable -Name invoke-atomicredteam)) {
    Write-Host "[+] Installing invoke-atomicredteam and powershell-yaml..." -ForegroundColor Green
    Install-Module -Name invoke-atomicredteam, powershell-yaml -Scope CurrentUser -Force
} else {
    Write-Host "[+] invoke-atomicredteam already installed." -ForegroundColor Green
}

Import-Module invoke-atomicredteam -Force

# ---------------------------------------------------------------------------
# STEP 2 — INSTALL / VERIFY ATOMICS FOLDER
# ---------------------------------------------------------------------------

Write-Host "[*] Checking atomics folder at $AtomicsPath..." -ForegroundColor Yellow

if (-not (Test-Path $AtomicsPath)) {
    Write-Host "[+] Installing atomics folder..." -ForegroundColor Green
    IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicsfolder.ps1' -UseBasicParsing)
    Install-AtomicsFolder -Force
} else {
    Write-Host "[+] Atomics folder found." -ForegroundColor Green
}

Write-Host "`n[*] Prerequisites satisfied. Starting emulation in 5 seconds..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

# ===========================================================================
# PHASE 1: <TACTIC_NAME> (<TACTIC_ID>)
# ---------------------------------------------------------------------------
# Example phase header — Skill 10 generates one block per ATT&CK tactic,
# populated with the specific techniques from the detection blueprint.
#
# Typical phase sequence (delete phases not applicable to your threat):
#   Phase 1  : Reconnaissance          (TA0043)
#   Phase 2  : Initial Access          (TA0001)
#   Phase 3  : Execution               (TA0002)
#   Phase 4  : Persistence             (TA0003)
#   Phase 5  : Privilege Escalation    (TA0004)
#   Phase 6  : Defense Evasion         (TA0005)
#   Phase 7  : Credential Access       (TA0006)
#   Phase 8  : Discovery               (TA0007)
#   Phase 9  : Lateral Movement        (TA0008)
#   Phase 10 : Collection              (TA0009)
#   Phase 11 : Exfiltration            (TA0010)
#   Phase 12 : Command and Control     (TA0011)
#   Phase 13 : Impact                  (TA0040)
# ===========================================================================

Write-Host "`n[Phase 1] Discovery (TA0007)" -ForegroundColor Magenta

# --- T1082 — System Information Discovery -----------------------------------
# Atomic Test : #1 — System Info via systeminfo
# Why selected: Threat actor uses systeminfo for host profiling
# Sigma rule   : <win_discovery_systeminfo.yml>
Write-Host "  [*] T1082 — System Information Discovery" -ForegroundColor White
Invoke-AtomicTest T1082 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1082 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1082 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# --- T1069.001 — Permission Groups Discovery: Local -------------------------
# Atomic Test : #1 — net localgroup
# Why selected: Actor enumerates local admin group membership
# Sigma rule   : <win_discovery_local_groups.yml>
Write-Host "  [*] T1069.001 — Permission Groups Discovery (Local)" -ForegroundColor White
Invoke-AtomicTest T1069.001 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1069.001 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1069.001 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# --- T1069.002 — Permission Groups Discovery: Domain ------------------------
# Atomic Test : #1 — net group /domain
# Why selected: Actor maps domain admin and privileged groups
# Sigma rule   : <win_discovery_domain_groups.yml>
Write-Host "  [*] T1069.002 — Permission Groups Discovery (Domain)" -ForegroundColor White
Invoke-AtomicTest T1069.002 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1069.002 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1069.002 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# --- T1018 — Remote System Discovery ----------------------------------------
# Atomic Test : #3 — nltest /dclist
# Why selected: Actor uses nltest to map domain controllers
# Sigma rule   : <win_discovery_nltest_domainlist.yml>
Write-Host "  [*] T1018 — Remote System Discovery" -ForegroundColor White
Invoke-AtomicTest T1018 -TestNumbers 3 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1018 -TestNumbers 3 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1018 -TestNumbers 3 -Cleanup -PathToAtomicsFolder $AtomicsPath

# --- T1482 — Domain Trust Discovery -----------------------------------------
# Atomic Test : #1 — nltest /domain_trusts
# Why selected: Actor maps cross-domain trust relationships
# Sigma rule   : <win_discovery_domaintrust_nltest.yml>
Write-Host "  [*] T1482 — Domain Trust Discovery" -ForegroundColor White
Invoke-AtomicTest T1482 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1482 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1482 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# PHASE 2: Defense Evasion (TA0005)
# ===========================================================================

Write-Host "`n[Phase 2] Defense Evasion (TA0005)" -ForegroundColor Magenta

# --- T1562.001 — Impair Defenses: Disable or Modify Tools ------------------
# Atomic Test : #2 — Disable Microsoft Defender via registry
# Why selected: Actor disables Defender to avoid detection during execution
# Sigma rule   : <win_defender_disabled_via_registry.yml>
# NOTE        : Cleanup re-enables Defender automatically
Write-Host "  [*] T1562.001 — Impair Defenses: Disable or Modify Tools" -ForegroundColor White
Invoke-AtomicTest T1562.001 -TestNumbers 2 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1562.001 -TestNumbers 2 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1562.001 -TestNumbers 2 -Cleanup -PathToAtomicsFolder $AtomicsPath

# --- T1562.004 — Impair Defenses: Disable or Modify System Firewall --------
# Atomic Test : #1 — netsh advfirewall set allprofiles state off
# Why selected: Actor disables host firewall to enable lateral movement
# Sigma rule   : <win_firewall_disabled_via_netsh.yml>
Write-Host "  [*] T1562.004 — Disable System Firewall" -ForegroundColor White
Invoke-AtomicTest T1562.004 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1562.004 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1562.004 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# PHASE 3: Credential Access (TA0006)
# ===========================================================================

Write-Host "`n[Phase 3] Credential Access (TA0006)" -ForegroundColor Magenta

# --- T1003.001 — OS Credential Dumping: LSASS Memory -----------------------
# Atomic Test : #1 — ProcDump lsass.exe
# Why selected: Actor dumps LSASS to harvest domain credentials
# Sigma rule   : <win_lsass_dump_procdump.yml>
# Prereq       : ProcDump downloaded automatically by -GetPrereqs
Write-Host "  [*] T1003.001 — Credential Dumping: LSASS via ProcDump" -ForegroundColor White
Invoke-AtomicTest T1003.001 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1003.001 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1003.001 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# PHASE 4: Command and Control (TA0011)
# ===========================================================================

Write-Host "`n[Phase 4] Command and Control (TA0011)" -ForegroundColor Magenta

# --- T1219 — Remote Access Software ----------------------------------------
# Atomic Test : #3 — AnyDesk remote access install
# Why selected: Actor deploys AnyDesk as persistent C2 channel
# Sigma rule   : <win_remote_access_tool_anydesk.yml>
Write-Host "  [*] T1219 — Remote Access Software (AnyDesk)" -ForegroundColor White
Invoke-AtomicTest T1219 -TestNumbers 3 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1219 -TestNumbers 3 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1219 -TestNumbers 3 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# PHASE 5: Collection (TA0009)
# ===========================================================================

Write-Host "`n[Phase 5] Collection (TA0009)" -ForegroundColor Magenta

# --- T1560.001 — Archive Collected Data: Archive via Utility ---------------
# Atomic Test : #1 — Compress data with WinRAR (password-protected archive)
# Why selected: Actor stages exfiltration data in encrypted archives
# Sigma rule   : <win_archive_via_winrar_cmdline.yml>
# Prereq       : WinRAR downloaded automatically by -GetPrereqs
Write-Host "  [*] T1560.001 — Archive Collected Data via WinRAR" -ForegroundColor White
Invoke-AtomicTest T1560.001 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1560.001 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1560.001 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# PHASE 6: Exfiltration (TA0010)
# ===========================================================================

Write-Host "`n[Phase 6] Exfiltration (TA0010)" -ForegroundColor Magenta

# --- T1048.003 — Exfiltration Over Alternative Protocol: Unencrypted -------
# Atomic Test : #1 — Exfiltration via Rclone to cloud storage
# Why selected: Actor uses Rclone for data exfiltration to attacker-controlled storage
# Sigma rule   : <win_exfiltration_rclone.yml>
# Prereq       : Rclone downloaded automatically by -GetPrereqs
Write-Host "  [*] T1048.003 — Exfiltration Over Alternative Protocol (Rclone)" -ForegroundColor White
Invoke-AtomicTest T1048.003 -TestNumbers 1 -GetPrereqs -PathToAtomicsFolder $AtomicsPath
Invoke-AtomicTest T1048.003 -TestNumbers 1 -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
Start-Sleep -Seconds $SleepBetweenTests
Invoke-AtomicTest T1048.003 -TestNumbers 1 -Cleanup -PathToAtomicsFolder $AtomicsPath

# ===========================================================================
# SUMMARY
# ===========================================================================

Write-Host "`n[*] ==========================================================" -ForegroundColor Cyan
Write-Host "[*] Emulation run complete — $(Get-Date)" -ForegroundColor Cyan
Write-Host "[*] Execution log : $LogPath" -ForegroundColor Cyan
Write-Host "[*] ==========================================================" -ForegroundColor Cyan

Write-Host "`n[*] Atomic tests executed:" -ForegroundColor White
Write-Host "  T1082      Test #1  — System Information Discovery" -ForegroundColor White
Write-Host "  T1069.001  Test #1  — Permission Groups Discovery (Local)" -ForegroundColor White
Write-Host "  T1069.002  Test #1  — Permission Groups Discovery (Domain)" -ForegroundColor White
Write-Host "  T1018      Test #3  — Remote System Discovery (nltest)" -ForegroundColor White
Write-Host "  T1482      Test #1  — Domain Trust Discovery (nltest)" -ForegroundColor White
Write-Host "  T1562.001  Test #2  — Disable Microsoft Defender" -ForegroundColor White
Write-Host "  T1562.004  Test #1  — Disable Host Firewall" -ForegroundColor White
Write-Host "  T1003.001  Test #1  — LSASS Credential Dump (ProcDump)" -ForegroundColor White
Write-Host "  T1219      Test #3  — Remote Access Software (AnyDesk)" -ForegroundColor White
Write-Host "  T1560.001  Test #1  — Archive Data via WinRAR" -ForegroundColor White
Write-Host "  T1048.003  Test #1  — Exfiltration via Rclone" -ForegroundColor White

Write-Host "`n[*] Post-emulation validation steps:" -ForegroundColor Yellow
Write-Host "  1. Review EDR alert list — match against expected Sigma rule names above" -ForegroundColor Yellow
Write-Host "  2. Query SIEM for process creation events in the test window" -ForegroundColor Yellow
Write-Host "  3. Note any techniques that produced NO alert — open detection gaps" -ForegroundColor Yellow
Write-Host "  4. Verify EDR / Defender is re-enabled after cleanup" -ForegroundColor Yellow
Write-Host "  5. Archive this run's log: $LogPath" -ForegroundColor Yellow

Write-Host "`n[*] Atomic test reference pages:" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1082" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1069.001" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1069.002" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1018" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1482" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1562.001" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1562.004" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1003.001" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1219" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1560.001" -ForegroundColor White
Write-Host "  https://atomicredteam.io/atomic-red-team/atomics/T1048.003" -ForegroundColor White
