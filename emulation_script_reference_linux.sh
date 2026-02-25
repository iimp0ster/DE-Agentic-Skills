#!/usr/bin/env bash
# =============================================================================
# ADVERSARY EMULATION SCRIPT - REFERENCE TEMPLATE (Linux / macOS)
# =============================================================================
#
# This file is the EXPECTED OUTPUT FORMAT for Skill 10 (Adversary Emulation
# Script Generation) when the target platform is Linux or macOS. Skill 10
# produces a populated version of this structure, replacing all <PLACEHOLDER>
# fields with real values derived from the detection blueprint and threat intel.
#
# Threat Actor / Campaign : <THREAT_ACTOR_OR_CAMPAIGN>
# Detection Blueprint     : <PATH_OR_LINK_TO_BLUEPRINT.md>
# ATT&CK Techniques       : <T1XXX, T1XXX.XXX, ...>
# Atomic Test IDs         : <see phase blocks below>
# Platform                : Linux (Ubuntu/RHEL/Debian) / macOS
# Requires                : PowerShell Core 7+ (pwsh) + Invoke-AtomicRedTeam
# Author                  : <AUTHOR>
# Date                    : <DATE>
# Version                 : 1.0
#
# References:
#   Atomic Red Team      : https://github.com/redcanaryco/atomic-red-team
#   Invoke-AtomicRedTeam : https://github.com/redcanaryco/invoke-atomicredteam
#   PowerShell Core      : https://github.com/PowerShell/PowerShell/releases
#   Threat Intel Source  : <URL_OR_REPORT_REFERENCE>
#
# =============================================================================
# !! SAFETY WARNINGS — READ BEFORE EXECUTING !!
# =============================================================================
#
#  1. Run ONLY on an ISOLATED test machine — NOT on production systems.
#  2. Ensure your EDR / SIEM agent is installed, active, and reporting
#     BEFORE executing this script.
#  3. Notify your security team of the test window in advance.
#  4. Some tests download prerequisites — internet access is required unless
#     atomics are staged offline.
#  5. Run with root / sudo where indicated.
#  6. Review each atomic test at https://atomicredteam.io before running to
#     understand exactly what it does and what artifacts it leaves behind.
#  7. A system snapshot or backup is strongly recommended before execution.
#
# =============================================================================

set -uo pipefail

# ---------------------------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------------------------

ATOMICS_PATH="${HOME}/AtomicRedTeam/atomics"
LOG_PATH="/tmp/emulation_$(date +%Y%m%d_%H%M%S).csv"
SLEEP_BETWEEN_TESTS=5   # seconds between tests; increase if EDR is slow to report
PWSH_BIN="pwsh"         # path to PowerShell Core binary; adjust if non-standard

echo ""
echo "[*] Adversary Emulation — $(date)"
echo "[*] Threat: <THREAT_ACTOR_OR_CAMPAIGN>"
echo "[*] Log   : ${LOG_PATH}"
echo ""

# ---------------------------------------------------------------------------
# STEP 1 — VERIFY POWERSHELL CORE IS INSTALLED
# ---------------------------------------------------------------------------

check_prereqs() {
    echo "[*] Checking prerequisites..."

    if ! command -v "${PWSH_BIN}" &>/dev/null; then
        echo "[!] PowerShell Core (pwsh) not found."
        echo "    Linux install: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
        echo "    macOS install: brew install powershell"
        exit 1
    fi
    echo "[+] ${PWSH_BIN} found: $(${PWSH_BIN} --version)"

    # Check / install invoke-atomicredteam
    if ! "${PWSH_BIN}" -Command "Get-Module -ListAvailable invoke-atomicredteam" 2>/dev/null | grep -q "invoke-atomicredteam"; then
        echo "[+] Installing invoke-atomicredteam and powershell-yaml..."
        "${PWSH_BIN}" -Command "Install-Module -Name invoke-atomicredteam,powershell-yaml -Scope CurrentUser -Force"
    else
        echo "[+] invoke-atomicredteam already installed."
    fi

    # Check / install atomics folder
    if [ ! -d "${ATOMICS_PATH}" ]; then
        echo "[+] Installing atomics folder to ${HOME}/AtomicRedTeam..."
        "${PWSH_BIN}" -Command "
            IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicsfolder.ps1' -UseBasicParsing);
            Install-AtomicsFolder -InstallPath '${HOME}/AtomicRedTeam' -Force
        "
    else
        echo "[+] Atomics folder found at ${ATOMICS_PATH}."
    fi
}

# ---------------------------------------------------------------------------
# HELPER — run_atomic <TechniqueID> <TestNumbers> <Description>
#
# Executes GetPrereqs → Execute → Sleep → Cleanup for a single atomic test.
# Each phase is a separate pwsh invocation so a failed test does not abort
# the entire script.
# ---------------------------------------------------------------------------

run_atomic() {
    local technique="$1"
    local test_numbers="$2"
    local description="$3"

    echo "  [*] ${technique} Test #${test_numbers} — ${description}"

    # GetPrereqs
    "${PWSH_BIN}" -Command "
        Import-Module invoke-atomicredteam -Force
        Invoke-AtomicTest ${technique} -TestNumbers ${test_numbers} \
            -GetPrereqs -PathToAtomicsFolder '${ATOMICS_PATH}'
    " || echo "  [!] GetPrereqs failed for ${technique} Test #${test_numbers} — continuing"

    # Execute
    "${PWSH_BIN}" -Command "
        Import-Module invoke-atomicredteam -Force
        Invoke-AtomicTest ${technique} -TestNumbers ${test_numbers} \
            -PathToAtomicsFolder '${ATOMICS_PATH}' \
            -ExecutionLogPath '${LOG_PATH}'
    " || echo "  [!] Execution failed for ${technique} Test #${test_numbers} — continuing"

    sleep "${SLEEP_BETWEEN_TESTS}"

    # Cleanup
    "${PWSH_BIN}" -Command "
        Import-Module invoke-atomicredteam -Force
        Invoke-AtomicTest ${technique} -TestNumbers ${test_numbers} \
            -Cleanup -PathToAtomicsFolder '${ATOMICS_PATH}'
    " || echo "  [!] Cleanup failed for ${technique} Test #${test_numbers} — manual cleanup may be required"
}

# ===========================================================================
# MAIN EXECUTION
# ===========================================================================

check_prereqs

echo ""
echo "[*] Starting emulation in 5 seconds..."
sleep 5

# ===========================================================================
# PHASE 1: Discovery (TA0007)
# ---------------------------------------------------------------------------
# Skill 10 generates one block per ATT&CK tactic, populated with the specific
# techniques from the detection blueprint. Delete phases not applicable to
# your threat actor.
# ===========================================================================

echo ""
echo "[Phase 1] Discovery (TA0007)"

# T1082 — System Information Discovery
# Atomic  : Test #2 — Hostname discovery (Linux)
# Why     : Actor profiles host via standard system commands
# Sigma   : <linux_discovery_system_info.yml>
run_atomic "T1082" "2" "System Information Discovery"

# T1016 — System Network Configuration Discovery
# Atomic  : Test #1 — ip addr / ifconfig enumeration
# Why     : Actor maps network interfaces and routing
# Sigma   : <linux_discovery_network_config.yml>
run_atomic "T1016" "1" "System Network Configuration Discovery"

# T1057 — Process Discovery
# Atomic  : Test #1 — ps enumeration
# Why     : Actor identifies running processes to target or avoid
# Sigma   : <linux_discovery_process_list.yml>
run_atomic "T1057" "1" "Process Discovery"

# T1069.001 — Permission Groups Discovery: Local
# Atomic  : Test #2 — /etc/group enumeration
# Why     : Actor enumerates local groups to find privileged accounts
# Sigma   : <linux_discovery_local_groups.yml>
run_atomic "T1069.001" "2" "Permission Groups Discovery (Local)"

# ===========================================================================
# PHASE 2: Credential Access (TA0006)
# ===========================================================================

echo ""
echo "[Phase 2] Credential Access (TA0006)"

# T1003.008 — OS Credential Dumping: /etc/passwd and /etc/shadow
# Atomic  : Test #1 — Read /etc/passwd and /etc/shadow
# Why     : Actor harvests local credential hashes for offline cracking
# Sigma   : <linux_credential_dump_shadow.yml>
# NOTE    : Requires root privileges
run_atomic "T1003.008" "1" "OS Credential Dumping: /etc/passwd and /etc/shadow"

# T1552.001 — Unsecured Credentials: Credentials In Files
# Atomic  : Test #1 — Find credentials in common config/history files
# Why     : Actor searches for cleartext passwords in config files and shell history
# Sigma   : <linux_credentials_in_files.yml>
run_atomic "T1552.001" "1" "Credentials In Files"

# ===========================================================================
# PHASE 3: Persistence (TA0003)
# ===========================================================================

echo ""
echo "[Phase 3] Persistence (TA0003)"

# T1053.003 — Scheduled Task/Job: Cron
# Atomic  : Test #1 — Cron job added for persistence
# Why     : Actor adds cron job to maintain access after reboot
# Sigma   : <linux_persistence_cron_modification.yml>
run_atomic "T1053.003" "1" "Cron Job Persistence"

# T1098 — Account Manipulation
# Atomic  : Test #1 — Add a user account to sudoers
# Why     : Actor adds backdoor sudoers entry for privilege persistence
# Sigma   : <linux_persistence_sudoers_modification.yml>
run_atomic "T1098" "1" "Account Manipulation (sudoers)"

# ===========================================================================
# PHASE 4: Defense Evasion (TA0005)
# ===========================================================================

echo ""
echo "[Phase 4] Defense Evasion (TA0005)"

# T1070.003 — Indicator Removal: Clear Command History
# Atomic  : Test #1 — Unset HISTFILE and clear bash history
# Why     : Actor removes shell history to reduce forensic footprint
# Sigma   : <linux_defense_evasion_history_cleared.yml>
run_atomic "T1070.003" "1" "Clear Command History"

# T1027 — Obfuscated Files or Information
# Atomic  : Test #1 — Base64 encode payload
# Why     : Actor encodes commands to evade string-based detection
# Sigma   : <linux_obfuscated_base64_command.yml>
run_atomic "T1027" "1" "Obfuscated Files or Information (Base64)"

# ===========================================================================
# PHASE 5: Collection (TA0009)
# ===========================================================================

echo ""
echo "[Phase 5] Collection (TA0009)"

# T1560.001 — Archive Collected Data: Archive via Utility
# Atomic  : Test #2 — Compress data with tar + gzip
# Why     : Actor stages sensitive data in compressed archive for exfiltration
# Sigma   : <linux_collection_tar_archive.yml>
run_atomic "T1560.001" "2" "Archive Collected Data (tar)"

# ===========================================================================
# PHASE 6: Exfiltration (TA0010)
# ===========================================================================

echo ""
echo "[Phase 6] Exfiltration (TA0010)"

# T1048.003 — Exfiltration Over Alternative Protocol: Unencrypted
# Atomic  : Test #1 — Exfiltration over FTP or curl to external host
# Why     : Actor exfiltrates archived data over non-standard channel
# Sigma   : <linux_exfiltration_alternative_protocol.yml>
run_atomic "T1048.003" "1" "Exfiltration Over Alternative Protocol"

# ===========================================================================
# SUMMARY
# ===========================================================================

echo ""
echo "[*] =========================================================="
echo "[*] Emulation run complete — $(date)"
echo "[*] Execution log : ${LOG_PATH}"
echo "[*] =========================================================="
echo ""
echo "[*] Atomic tests executed:"
echo "  T1082      Test #2  — System Information Discovery"
echo "  T1016      Test #1  — System Network Configuration Discovery"
echo "  T1057      Test #1  — Process Discovery"
echo "  T1069.001  Test #2  — Permission Groups Discovery (Local)"
echo "  T1003.008  Test #1  — Credential Dump: /etc/passwd + /etc/shadow"
echo "  T1552.001  Test #1  — Credentials In Files"
echo "  T1053.003  Test #1  — Cron Job Persistence"
echo "  T1098      Test #1  — Account Manipulation (sudoers)"
echo "  T1070.003  Test #1  — Clear Command History"
echo "  T1027      Test #1  — Obfuscated Files (Base64)"
echo "  T1560.001  Test #2  — Archive Data (tar)"
echo "  T1048.003  Test #1  — Exfiltration Over Alternative Protocol"
echo ""
echo "[*] Post-emulation validation steps:"
echo "  1. Review EDR / SIEM alerts — match against expected Sigma rule names above"
echo "  2. Query SIEM for process creation events in the test window"
echo "  3. Note any techniques that produced NO alert — these are detection gaps"
echo "  4. Restore any system state changes not cleaned up automatically"
echo "  5. Archive this run's log: ${LOG_PATH}"
echo ""
echo "[*] Atomic test reference pages:"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1082"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1016"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1057"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1069.001"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1003.008"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1552.001"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1053.003"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1098"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1070.003"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1027"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1560.001"
echo "  https://atomicredteam.io/atomic-red-team/atomics/T1048.003"
