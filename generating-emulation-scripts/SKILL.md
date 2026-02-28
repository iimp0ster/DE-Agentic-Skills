---
name: generating-emulation-scripts
description: Generates ready-to-run Atomic Red Team adversary emulation scripts from ATT&CK technique IDs. Produces a Windows PowerShell script and Linux/macOS shell wrapper, a test-to-detection mapping table, and pre/post-execution checklists. Use after a detection blueprint is complete or after threat intelligence ingestion to validate detection coverage. Triggers: "generate emulation script", "create Atomic Red Team test", "validate detection coverage."
---

# Generating Emulation Scripts

**Inputs:**
- ATT&CK technique IDs from detection blueprint or threat intel package (e.g., T1059.001, T1003.001)
- Target OS platform: Windows / Linux / macOS (or mixed)
- Attack chain sequence (tactic order from threat intel or detection blueprint)
- Optional: Specific Atomic test numbers or GUIDs to include or exclude
- Optional: Environment constraints (no internet access, offline atomics, specific EDR platform)
- Optional: Detection rule file(s) (Sigma, KQL, SPL) to map tests against

**Workflow steps:**

1. **Collect and order ATT&CK technique IDs** - Gather all technique and sub-technique IDs in scope:
   - Pull technique IDs from the detection blueprint Metadata and Threat Context sections
   - Order by kill chain phase: Initial Access → Execution → Persistence → Privilege Escalation → Defense Evasion → Credential Access → Discovery → Lateral Movement → Collection → Exfiltration → C2 → Impact
   - Flag any techniques with no current Atomic Red Team atomics coverage (requires a custom test placeholder)
   - Identify sub-technique variants relevant to the observed threat actor tradecraft

2. **Map techniques to Atomic test IDs** - For each ATT&CK technique, identify the best-fit Atomic tests:
   - Reference the Atomic Red Team atomics library: https://github.com/redcanaryco/atomic-red-team/tree/master/atomics
   - Prefer automated executors (PowerShell, bash, command_prompt) over manual steps
   - Select the test number(s) or GUID(s) that most closely match the threat actor's observed tradecraft
   - Note prerequisite dependencies (tools like Mimikatz, Rclone, WinRAR, ProcDump) that `-GetPrereqs` will fetch
   - Document rationale for each test selection in inline script comments

3. **Determine platform and executor** - Assess OS-specific test availability:
   - **Windows:** PowerShell 5.1+ using the `invoke-atomicredteam` module
   - **Linux / macOS:** PowerShell Core (`pwsh`) with `invoke-atomicredteam`, wrapped in a bash script
   - Cross-platform techniques: generate both Windows (`.ps1`) and Linux/macOS (`.sh`) variants
   - Note which atomic tests are platform-specific vs. cross-platform in script comments

4. **Sequence tests by attack phase** - Organize execution to mirror a realistic attack chain:
   - Group tests under phase header comments matching kill chain stages
   - Preserve logical dependencies (credential access before lateral movement, discovery before collection)
   - Insert `Start-Sleep` (Windows) or `sleep` (Linux) intervals between tests (default: 5 seconds) to allow EDR telemetry to flush
   - Place `-Cleanup` calls after each test or phase to restore system state

5. **Generate the Windows PowerShell emulation script** - Produce a well-commented `.ps1` file:

   **Script structure:**
   ```
   [HEADER BLOCK]
   - Threat actor / campaign name
   - ATT&CK techniques covered
   - Atomic test IDs used
   - Target platform
   - Safety warnings (isolated test machine, admin privileges, EDR active)
   - Author, date, references

   [PREREQUISITES BLOCK]
   - Verify PowerShell version and admin privileges
   - Install invoke-atomicredteam module if missing
   - Install atomics folder if missing

   [PHASE BLOCKS — one block per kill chain tactic]
   For each technique in each phase:
     Invoke-AtomicTest <TID> -TestNumbers <N> -GetPrereqs -PathToAtomicsFolder $AtomicsPath
     Invoke-AtomicTest <TID> -TestNumbers <N> -PathToAtomicsFolder $AtomicsPath -ExecutionLogPath $LogPath
     Start-Sleep -Seconds $SleepBetweenTests
     Invoke-AtomicTest <TID> -TestNumbers <N> -Cleanup -PathToAtomicsFolder $AtomicsPath

   [SUMMARY BLOCK]
   - Bulleted list of all tests executed with technique IDs
   - Prompt to review EDR / SIEM alerts
   - Links to Atomic test detail pages for each technique
   ```

6. **Generate the Linux/macOS shell wrapper** - Produce a `.sh` file that drives the same tests via `pwsh`:
   - Check `pwsh` is installed; exit with install instructions if not
   - Install `invoke-atomicredteam` and atomics folder via `pwsh` if missing
   - Define a `run_atomic()` helper function to handle GetPrereqs / Execute / Sleep / Cleanup per test
   - Organize phases identically to the Windows script
   - Use `/tmp` for log output

7. **Build test-to-detection mapping table** - Document which emulation test validates which detection rule:
   ```
   | Atomic Test          | Technique ID | ATT&CK Tactic     | Sigma Rule / Detection Name     | Expected Alert |
   |----------------------|--------------|-------------------|---------------------------------|----------------|
   | T1059.001 - Test #1  | T1059.001    | Execution         | win_powershell_encoded_cmd      | High           |
   | T1003.001 - Test #1  | T1003.001    | Credential Access | win_lsass_dump_procdump         | Critical       |
   ```

8. **Generate pre-execution safety checklist** - Ensure safe test conditions:
   - [ ] Test machine is isolated from production network
   - [ ] EDR / AV agent is installed, active, and reporting
   - [ ] SIEM is ingesting endpoint logs from the test machine
   - [ ] Security team has been notified of the test window
   - [ ] Test machine OS and tooling match the production environment profile
   - [ ] Snapshot or backup taken of the test machine before execution
   - [ ] Internet access available (for prerequisite downloads) or offline atomics folder staged

9. **Generate post-execution validation checklist** - Specify what to verify in EDR/SIEM after running:
   - List expected process creation events per technique (parent/child chain)
   - List expected EDR alert names by common vendor (CrowdStrike, Defender for Endpoint, SentinelOne)
   - Provide a retrospective SIEM query per Sigma rule to search execution window
   - Calculate coverage score: (techniques that triggered detection) / (total techniques in emulation)
   - Document any techniques that produced no alert (feed back into Skills 1-6 as gap)

**Outputs:**
- Windows PowerShell emulation script (`.ps1`) with inline phase comments and safety header
- Linux/macOS shell wrapper (`.sh`) calling the same atomics via `pwsh`
- Test-to-detection mapping table
- Pre-execution safety checklist
- Post-execution SIEM/EDR validation steps
- Gap list: ATT&CK techniques with no Atomic Red Team coverage requiring custom test development

**Integration with the core workflow:**
- **After Skills 1-6:** Run this skill to produce the emulation script for the completed detection blueprint
- **After Skill 7 (Threat Intel Ingestion):** Run immediately after to generate a threat-actor-specific simulation script before the full detection is built — enables proactive coverage testing
- **Feeding back to Skills 1-6:** Techniques in the emulation gap list that produce no detection become priority inputs for a new detection development cycle

**References:**
- Atomic Red Team atomics library: https://github.com/redcanaryco/atomic-red-team/tree/master/atomics
- Invoke-AtomicRedTeam module: https://github.com/redcanaryco/invoke-atomicredteam
- Invoke-AtomicRedTeam installation wiki: https://github.com/redcanaryco/invoke-atomicredteam/wiki/Installing-Invoke-AtomicRedTeam
- Reference implementation pattern (simulate-akira): https://github.com/skandler/simulate-akira
- MITRE ATT&CK Enterprise Matrix: https://attack.mitre.org/matrices/enterprise/
- Atomic Red Team execution guide: https://www.atomicredteam.io/invoke-atomicredteam/docs
- emulation_script_reference_windows.ps1 (this repo) — expected output format for Windows
- emulation_script_reference_linux.sh (this repo) — expected output format for Linux/macOS
