# Detection Engineering Agent Skills - Orchestration Template

## End-to-End Detection Engineering Workflow

Use this template to execute the complete detection engineering process using all 6 skills in sequence.

### Standard Orchestration Prompt

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
1. Upload all skill files (skill_01 through skill_06) to Project Knowledge
2. Upload this orchestration template
3. In any new chat within the project, simply invoke:
   ```
   Plan and design a detection for [threat scenario]. Generate a Sigma rule.
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
      orchestration.md
```

Invoke via command line:
```bash
claude-code "Using the detection engineering skills in /skills/detection_engineering/, 
create a complete detection for PowerShell Empire C2 traffic. 
Generate Sigma rule and save to /detections/windows/"
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

Default to Sigma rule generation unless YARA explicitly requested.
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

After executing the full workflow, expect:
- Complete markdown detection blueprint (2000-4000 words typically)
- MITRE ATT&CK mappings
- Sigma or YARA rule (if requested)
- 2-4 positive test cases
- 2-3 negative test cases
- Data source requirements table
- Limitations and assumptions documented
- References to external resources

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

Try this to validate the skills are working:

```
Plan and design a detection for suspicious PowerShell execution with encoded commands.
Generate a Sigma rule.

Execute all 6 detection engineering skills.
Target environment: Windows 10/11 with Sysmon Event ID 1.
Prioritize precision over recall - minimize false positives.
```

Expected output: Complete detection blueprint with Sigma rule targeting base64-encoded PowerShell commands, exclusions for known software, and Atomic Red Team test references.
