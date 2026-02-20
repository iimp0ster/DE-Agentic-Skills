# Detection Engineering Agent Skills

A structured framework for planning, designing, validating, and maintaining security detections using AI-assisted workflows. Based on the [Threat Hunter Playbook agentic skills model](https://blog.openthreatresearch.com/evolving-the-threat-hunter-playbook-planning-hunts-with-agent-skills/) and [Anvilogic's agentic detection engineering methodology](https://www.anvilogic.com/learn/automating-the-scientific-method-for-cybersecurity), adapted for detection engineering.

## Overview

Nine composable skills that guide systematic detection development end-to-end:

**Detection Creation (per-detection workflow)**
1. **Research & Context** - Map the threat to MITRE ATT&CK, document normal vs. malicious behavior
2. **Detection Objective & Scope** - Define what to detect, scope boundaries, and success criteria
3. **Data Source & Telemetry Mapping** - Identify required logs, fields, and visibility gaps
4. **Detection Logic Design** - Create analytical logic (Sigma/YARA/vendor-agnostic)
5. **Validation & Testing Plan** - Design simulation and testing approach
6. **Detection Blueprint Assembly** - Compile a deployment-ready package

**Accelerators (run before or alongside the core workflow)**
7. **Threat Intelligence Ingestion** - Parse threat reports/feeds to extract ATT&CK TTPs, IOCs, and behavioral indicators as detection inputs
8. **Environment Baseline Profiling** - Document org-specific schemas, tooling, and exclusion baselines to pre-tune detections for your environment

**Program-Level (run across the detection library)**
9. **Detection Coverage & Gap Analysis** - Map existing detections to ATT&CK, identify gaps, and produce a prioritized detection roadmap

## File Structure

```
detection_engineering_skills/
├── README.md                           # This file
├── orchestration_template.md           # Usage patterns and examples
├── skill_01_research_context.md
├── skill_02_detection_objective.md
├── skill_03_data_source_mapping.md
├── skill_04_detection_logic.md
├── skill_05_validation_testing.md
├── skill_06_blueprint_assembly.md
├── skill_07_threat_intel_ingestion.md
├── skill_08_environment_baseline.md
└── skill_09_coverage_gap_analysis.md
```

## Quick Start

```
Plan and design a detection for Kerberoasting attacks. Generate a Sigma rule.

Execute the detection engineering workflow using these Agent Skills in sequence:
1. Research & Context
2. Detection Objective & Scope
3. Data Source & Telemetry Mapping
4. Detection Logic Design - Generate Sigma rule
5. Validation & Testing Plan
6. Detection Blueprint Assembly

Complete each skill fully before proceeding to the next.
Present the final detection blueprint as a structured markdown document.
```

This produces a complete detection package including MITRE ATT&CK mapping, a Sigma rule, Atomic Red Team test procedures, false positive analysis, and response guidance.

## Integration Platforms

### Claude Projects (Recommended)

1. Create a new Claude Project (e.g., "Detection Engineering")
2. Upload all `.md` files from this directory to Project Knowledge
3. Start a new chat and prompt away — no coding required

### Claude Code

```bash
mkdir -p skills/detection_engineering
cp *.md skills/detection_engineering/

claude "Using detection engineering skills, create a detection for
AWS IAM privilege escalation. Output Sigma rule to /detections/aws/"
```

### Cursor IDE

Add to `.cursorrules`:
```
Detection Engineering Skills: /skills/detection_engineering/
Default format: Sigma rules
Prioritize precision over recall for detections
```

Then use inline editing (`Cmd+K`) or chat:
```
Using Detection Logic Design skill, convert this behavior to a Sigma rule
```

## Usage Patterns

### Full Detection Workflow (Skills 1-6)
```
Plan detection for <threat>. Generate a Sigma rule.
Execute skills 1-6 in sequence.
```

### Starting from Threat Intel (Skill 7 → Skills 1-6)
```
I have a threat report on APT29 cloud techniques. [paste or link report]
Apply the Threat Intelligence Ingestion skill to extract detection inputs,
then execute skills 1-6 for the highest-priority technique.
```

### Pre-tuned for Your Environment (Skill 8 → Skills 4-5)
```
Apply the Environment Baseline Profiling skill for our environment:
- Splunk Enterprise, Windows Sysmon, CrowdStrike Falcon
- Known tools: Tenable scanner (192.168.1.50), SCCM (svc-sccm account), Veeam backup

Then execute skills 4-5 using this baseline for tuning.
```

### Program Coverage Review (Skill 9)
```
Apply the Detection Coverage & Gap Analysis skill.
Current detections: [list or describe your detection library]
Threat context: financial services, focus on ransomware and insider threat.
Output a prioritized gap list and recommended next 5 detections.
```

### Partial Workflows
```
# Research through data mapping only
Execute skills 1-3 for Azure AD conditional access bypass.

# Logic through deployment only (when you have existing research)
Execute skills 4-6 for OAuth device code phishing. Generate Sigma rule.
Context: Technique T1566.002, Target: Microsoft 365
```

### Custom Output Formats
```
Plan detection for mimikatz. Generate logic in Splunk SPL format.
Plan detection for suspicious PowerShell. Generate KQL query.
Plan detection for Cobalt Strike beacon. Generate YARA rule.
```

## Detection Blueprint Format

Final output (Skill 6) follows this structure:

```markdown
## Metadata
- ID, Author, Date, Version, MITRE ATT&CK Mapping, Severity, Platform

## Threat Context
- Attack scenario, adversary tradecraft, known tools

## Detection Logic
- Objective and hypothesis, vendor-agnostic description, Sigma/YARA rule, exclusion rationale

## Data Requirements
- Required sources, field mappings, visibility gaps, configuration needs

## Validation & Testing
- Positive/negative test procedures, Atomic Red Team IDs, tuning recommendations

## Response Guidance
- Triage steps, investigation queries, remediation actions

## Limitations
- Known gaps, assumptions, future enhancements

## References
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Skills not activating | Use the explicit orchestration prompt from `orchestration_template.md` |
| Generic/vague output | Add more context: specific tools, environment constraints, precision vs. coverage preference |
| No Sigma/YARA output | Explicitly request: "Generate Sigma rule" or "Generate YARA rule" |
| Incomplete blueprint | Request: "Execute all 6 skills" or "Complete detection blueprint" |

## References

- [Original Threat Hunter Playbook Article](https://blog.openthreatresearch.com/evolving-the-threat-hunter-playbook-planning-hunts-with-agent-skills/)
- [Anvilogic: Automating the Scientific Method for Cybersecurity](https://www.anvilogic.com/learn/automating-the-scientific-method-for-cybersecurity)
- [Sigma Specification](https://github.com/SigmaHQ/sigma-specification)
- [YARA Documentation](https://yara.readthedocs.io/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
- [OSSEM Project](https://github.com/OTRF/OSSEM)
- [DeTTECT Framework](https://github.com/rabobank-cdc/DeTTECT)
