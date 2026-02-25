# Detection Engineering Agent Skills - Orchestration Template

## End-to-End Detection Engineering Workflow

Use this template to execute the complete detection engineering process. The ten skills are organized into four groups:

- **Skills 1-6:** Core per-detection workflow
- **Skills 7-8:** Accelerators (run before or alongside the core workflow)
- **Skill 9:** Program-level coverage analysis (run across the detection library)
- **Skill 10:** Adversary emulation script generation (run after detection is built to validate coverage)

### Standard Orchestration Prompt (Skills 1-6)

```
Plan and design a detection for <THREAT_SCENARIO>.

Execute the detection engineering workflow using these Agent Skills in sequence:

1. Research & Context - Build foundational understanding of the threat
2. Detection Objective & Scope - Define what to detect and boundaries
3. Data Source & Telemetry Mapping - Identify required logs and fields
4. Detection Logic Design - Create the analytical logic [IF SIGMA/YARA REQUESTED: "Generate Sigma rule" or "Generate YARA rule"]
5. Validation & Testing Plan - Design testing approach
6. Detection Blueprint Assembly - Compile final documentation package

Requirements:
- Complete each skill fully before proceeding to the next
- Do not provide intermediate progress messages
- Only respond after completing all 6 skills
- Present the final detection blueprint as a structured markdown document
- Name the file using format: <platform>_<technique>_<specificity>.md

Deliver the complete detection package ready for deployment.
```

### Full Detection + Emulation Workflow (Skills 1-6, then Skill 10)

```
Plan and design a detection for <THREAT_SCENARIO>. Generate a Sigma rule.
Target platform: <Windows / Linux / macOS>.

Execute skills 1-6 in sequence to produce the detection blueprint, then
execute Skill 10 (Adversary Emulation Script Generation) to produce a
ready-to-run Atomic Red Team emulation script.

Requirements for skills 1-6:
- Complete each skill fully before proceeding to the next
- Generate a Sigma rule in Skill 4
- Present the final detection blueprint as a structured markdown document

Requirements for Skill 10:
- Extract all ATT&CK technique IDs from the completed detection blueprint
- Map each technique to the best-fit Atomic Red Team test number(s)
- Sequence tests by kill chain phase
- Generate a Windows PowerShell emulation script (.ps1)
- Also generate a Linux/macOS shell wrapper (.sh) if platform is Linux/macOS or mixed
- Include test-to-detection mapping table
- Include pre-execution safety checklist and post-execution validation steps

Deliver the detection blueprint AND the emulation script(s) together.
```

### Threat-Actor Emulation from Intel (Skill 7 → Skill 10 → Skills 1-6)

```
I have the following threat intelligence: <PASTE REPORT TEXT OR LINK>

Step 1 — Apply Skill 7 (Threat Intelligence Ingestion):
- Extract all ATT&CK techniques and sub-techniques
- Catalog IOCs with volatility assessment
- Identify behavioral patterns suitable for durable detection
- Prioritize the top 3-5 detection candidates

Step 2 — Apply Skill 10 (Adversary Emulation Script Generation):
- Use the extracted ATT&CK technique IDs from Step 1
- Map each technique to Atomic Red Team test numbers
- Sequence by kill chain phase
- Generate a Windows PowerShell emulation script and a Linux shell wrapper
- Include test-to-detection mapping table and safety checklist

Step 3 — Apply skills 1-6 for the highest-priority technique from Step 1:
- Generate a Sigma rule

Deliver: threat intel summary, emulation script, and detection blueprint.
```

### Threat Intel-Driven Workflow (Skill 7 → Skills 1-6)

```
I have the following threat intelligence: <PASTE REPORT TEXT OR LINK>

Apply the Threat Intelligence Ingestion skill to:
- Extract all ATT&CK techniques and sub-techniques
- Catalog IOCs with volatility assessment
- Identify behavioral patterns suitable for durable detection
- Prioritize the top 3 detection candidates

Then execute skills 1-6 for the highest-priority technique.
Generate a Sigma rule.
```

### Environment-Aware Workflow (Skill 8 → Skills 1-6)

```
Before building detections, apply the Environment Baseline Profiling skill for our environment:
- SIEM/data lake: <Splunk / Sentinel / Elastic / etc.>
- EDR: <CrowdStrike / Defender / Carbon Black / etc.>
- OS scope: <Windows / Linux / macOS / cloud>
- Known noisy tools: <list scanners, backup agents, IT management platforms>
- Data schema notes: <any field naming quirks or ingestion gaps>

Use this baseline throughout skills 4 and 5 to pre-tune detection logic and
filter lists for this environment. Then execute skills 1-6 for <THREAT_SCENARIO>.
```

### Program Coverage Review (Skill 9)

```
Apply the Detection Coverage & Gap Analysis skill to our detection library.

Current detections:
<List detections with ATT&CK IDs, or describe coverage areas>

Context:
- Industry/sector: <financial / healthcare / tech / etc.>
- Primary threat concerns: <ransomware / nation-state / insider / etc.>
- Available data sources: <list key log sources>

Output:
1. ATT&CK coverage heatmap by tactic
2. Prioritized gap list (Critical/High/Medium/Low)
3. Recommended next 5 detections with rationale
```

### Emulation-Only Workflow (Skill 10 standalone)

```
Apply Skill 10 (Adversary Emulation Script Generation) to generate an
Atomic Red Team emulation script for the following ATT&CK techniques:

Techniques: <T1059.001, T1003.001, T1560.001, T1048.003, ...>
Threat actor / campaign: <THREAT_ACTOR>
Target platform: <Windows / Linux / macOS>

Requirements:
- Map each technique to the best-fit Atomic Red Team test number(s)
- Sequence by kill chain phase
- Generate a Windows PowerShell emulation script (.ps1)
- Generate a Linux/macOS shell wrapper (.sh)
- Include the test-to-detection mapping table
- Include pre-execution safety checklist and post-execution validation steps

Output the complete emulation scripts and supporting artifacts.
```

### Example Invocations

**Example 1: Kerberoasting Detection with Sigma**
```
Plan and design a detection for Kerberoasting attacks in Windows Active Directory environments. Generate a Sigma rule.

Execute the detection engineering workflow using these Agent Skills in sequence:
1. Research & Context
2. Detection Objective & Scope
3. Data Source & Telemetry Mapping
4. Detection Logic Design - Generate Sigma rule
5. Validation & Testing Plan
6. Detection Blueprint Assembly

Requirements:
- Complete each skill fully before proceeding to the next
- Do not provide intermediate progress messages
- Only respond after completing all 6 skills
- Present the final detection blueprint as a structured markdown document

Deliver the complete detection package ready for deployment.
```

**Example 2: Malware Detection with YARA**
```
Plan and design a detection for Cobalt Strike beacon in memory. Generate a YARA rule.

Execute the detection engineering workflow using these Agent Skills in sequence:
[... same structure ...]
4. Detection Logic Design - Generate YARA rule
[... continue ...]
```

**Example 3: Cloud Threat Detection**
```
Plan and design a detection for AWS credential exfiltration via EC2 instance metadata service abuse. Generate a Sigma rule.

Execute the detection engineering workflow using these Agent Skills in sequence:
[... same structure ...]
```

**Example 4: Ransomware Threat Actor — Full Detection + Emulation**
```
I have threat intelligence on the Akira ransomware group. Here is a summary
of their observed TTPs:
- Initial access via VPN credential abuse (T1078.001)
- Domain discovery with nltest (T1482, T1018)
- Credential dumping via LSASS (T1003.001)
- Defense evasion: disable AV/EDR (T1562.001)
- Remote access tool deployment — AnyDesk (T1219)
- Data archiving with WinRAR (T1560.001)
- Exfiltration via Rclone (T1048.003)
- Ransomware deployment (T1486)

Step 1 — Apply Skill 7 to structure these TTPs and identify detection priorities.
Step 2 — Apply Skill 10 to generate a Windows PowerShell Atomic Red Team emulation
          script covering all of the above techniques.
Step 3 — Apply skills 1-6 for T1003.001 (LSASS Credential Dump) as the
          highest-priority detection candidate. Generate a Sigma rule.

Target: Windows, Sysmon + Microsoft Defender for Endpoint.
```

## Individual Skill Usage

Skills can also be invoked individually for specific tasks:

### Single Skill Examples

**Research Only:**
```
Apply the Research & Context skill to OAuth token theft attacks in Okta.
```

**Logic Design Only:**
```
Using the Detection Logic Design skill, create a Sigma rule for this behavior:
Detect when a non-administrative process accesses LSASS memory with PROCESS_VM_READ permissions.
```

**Testing Plan Only:**
```
Run the Validation & Testing Plan skill for this existing Sigma rule:
[paste your Sigma rule]
```

### Partial Workflow Examples

**Research through Data Mapping (Skills 1-3):**
```
Execute skills 1-3 for Linux privilege escalation via sudoers file modification.
I will write the detection logic myself after reviewing your data mapping.
```

**Logic Design through Blueprint (Skills 4-6):**
```
I've already researched Azure AD privilege escalation via PIM role assignments.
Execute skills 4-6 starting with Detection Logic Design. Generate a Sigma rule.

Context from my research:
- Technique: T1078.004 (Valid Accounts: Cloud Accounts)
- Attack path: Attacker uses compromised account to assign themselves Global Admin via PIM
- Key indicators: Rapid PIM activation, unusual role assignments
```

## Integration Methods

### Claude Projects
1. Upload all skill files (skill_01 through skill_10) to Project Knowledge
2. Upload this orchestration template and the two reference scripts
3. In any new chat within the project, simply invoke:
   ```
   Plan and design a detection for [threat scenario]. Generate a Sigma rule.
   Then generate an Atomic Red Team emulation script for the detected techniques.
   ```

### Claude Code
Save skills to your detection repository:
```bash
/your-repo/
  skills/
    detection_engineering/
      skill_01_research_context.md
      skill_02_detection_objective.md
      skill_03_data_source_mapping.md
      skill_04_detection_logic.md
      skill_05_validation_testing.md
      skill_06_blueprint_assembly.md
      skill_07_threat_intel_ingestion.md
      skill_08_environment_baseline.md
      skill_09_coverage_gap_analysis.md
      skill_10_adversary_emulation.md
      emulation_script_reference_windows.ps1
      emulation_script_reference_linux.sh
      orchestration.md
```

Invoke via command line:
```bash
# Full detection + emulation in one pass
claude "Using the detection engineering skills in /skills/detection_engineering/,
create a complete detection for PowerShell Empire C2 traffic.
Generate Sigma rule and save to /detections/windows/.
Then run Skill 10 to generate the Atomic Red Team emulation script
and save to /emulations/windows/"

# Emulation only — from existing blueprint
claude "Using Skill 10 in /skills/detection_engineering/,
generate an Atomic Red Team emulation script for the detection at
/detections/windows/win_powershell_empire_c2.md.
Save output to /emulations/windows/"
```

### Cursor IDE
Add to `.cursorrules` in your project root:
```
Detection Engineering Skills available at: /skills/detection_engineering/

When user requests detection development, reference these skills:
- Research & Context: skill_01_research_context.md
- Detection Objective & Scope: skill_02_detection_objective.md
- Data Source Mapping: skill_03_data_source_mapping.md
- Detection Logic Design: skill_04_detection_logic.md
- Validation & Testing: skill_05_validation_testing.md
- Blueprint Assembly: skill_06_blueprint_assembly.md
- Threat Intel Ingestion: skill_07_threat_intel_ingestion.md
- Environment Baseline Profiling: skill_08_environment_baseline.md
- Coverage & Gap Analysis: skill_09_coverage_gap_analysis.md
- Adversary Emulation Script Generation: skill_10_adversary_emulation.md

Default to Sigma rule generation unless YARA explicitly requested.
After completing a detection blueprint, offer to run Skill 10 to generate
the corresponding Atomic Red Team emulation script.

Reference scripts:
- Windows emulation output format: emulation_script_reference_windows.ps1
- Linux/macOS emulation output format: emulation_script_reference_linux.sh
```

Then use inline:
```
Cmd+K: "Using Detection Logic Design skill, convert this threat intel to Sigma rule"
```

## Customization Options

### Adjust for Your Environment

**Skip specific skills:**
```
Execute skills 1, 2, and 4 only for AWS CloudTrail tampering.
Skip data mapping - we already know we're using CloudTrail logs.
```

**Custom detection format:**
```
Plan and design a detection for mimikatz credential dumping.
Generate detection logic in Splunk SPL instead of Sigma.
```

**Focus on specific aspects:**
```
Execute only the Validation & Testing Plan skill.
Create comprehensive test procedures for detecting LSASS memory access.
Include both Atomic Red Team tests and manual PowerShell commands.
```

## Output Expectations

After executing the full workflow (Skills 1-6), expect:
- Complete markdown detection blueprint (2000-4000 words typically)
- MITRE ATT&CK mappings
- Sigma or YARA rule (if requested)
- 2-4 positive test cases
- 2-3 negative test cases
- Data source requirements table
- Limitations and assumptions documented
- References to external resources

After executing Skill 10 (Adversary Emulation), additionally expect:
- Windows PowerShell emulation script (.ps1) following the structure in `emulation_script_reference_windows.ps1`
- Linux/macOS shell wrapper (.sh) following the structure in `emulation_script_reference_linux.sh`
- Test-to-detection mapping table linking each Atomic test to its corresponding Sigma rule
- Pre-execution safety checklist (test isolation, EDR active, team notification)
- Post-execution validation steps (expected alerts, retrospective queries, gap list)

File will be named using convention:
- `windows_kerberoasting_suspicious_spn_requests.md`
- `aws_cloudtrail_log_deletion_high_confidence.md`
- `linux_ssh_key_persistence_authorized_keys.md`

## Tips for Best Results

1. **Be specific about the threat:** "MFA fatigue in Okta" beats "authentication bypass"
2. **Specify rule format:** "Generate Sigma rule" or "Generate YARA rule" 
3. **Mention environment constraints:** "Windows 10/11 with Sysmon" or "AWS only, no on-prem"
4. **State noise tolerance:** "Low false positives acceptable" or "High coverage preferred"
5. **Request specific test tools:** "Include Atomic Red Team test IDs"

## Quick Start Test

**Detection only (Skills 1-6):**
```
Plan and design a detection for suspicious PowerShell execution with encoded commands.
Generate a Sigma rule.

Execute all 6 detection engineering skills.
Target environment: Windows 10/11 with Sysmon Event ID 1.
Prioritize precision over recall - minimize false positives.
```

Expected output: Complete detection blueprint with Sigma rule targeting base64-encoded PowerShell commands, exclusions for known software, and Atomic Red Team test references.

**Detection + Emulation (Skills 1-6, then Skill 10):**
```
Plan and design a detection for suspicious PowerShell execution with encoded commands.
Generate a Sigma rule. Target environment: Windows 10/11 with Sysmon.

Execute skills 1-6, then run Skill 10 to generate an Atomic Red Team
emulation script for all ATT&CK techniques in the blueprint.
Include both a Windows PowerShell script and a Linux shell wrapper.
```

Expected output: Detection blueprint with Sigma rule AND a ready-to-run PowerShell emulation script (`Invoke-AtomicTest T1059.001 ...`) with safety headers, phase comments, GetPrereqs/Execute/Cleanup blocks, test-to-detection mapping table, and post-run validation checklist.
