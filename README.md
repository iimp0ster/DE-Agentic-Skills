# Detection Engineering Agent Skills

A structured framework for planning, designing, validating, and maintaining security detections using AI-assisted workflows. Based on the [Threat Hunter Playbook agentic skills model](https://blog.openthreatresearch.com/evolving-the-threat-hunter-playbook-planning-hunts-with-agent-skills/), adapted for detection engineering.

## Overview

This skill set enables systematic detection development through six composable stages:

1. **Research & Context** - Understand the threat and system internals
2. **Detection Objective & Scope** - Define what to detect and boundaries
3. **Data Source & Telemetry Mapping** - Identify required logs and fields
4. **Detection Logic Design** - Create analytical logic (Sigma/YARA/vendor-agnostic)
5. **Validation & Testing Plan** - Design simulation and testing approach
6. **Detection Blueprint Assembly** - Compile deployment-ready package

## File Structure

```
detection_engineering_skills/
├── README.md                           # This file
├── orchestration_template.md           # Usage patterns and examples
├── skill_01_research_context.md        # Threat and system research
├── skill_02_detection_objective.md     # Scope and hypothesis definition
├── skill_03_data_source_mapping.md     # Telemetry requirements
├── skill_04_detection_logic.md         # Analytics design
├── skill_05_validation_testing.md      # Testing methodology
└── skill_06_blueprint_assembly.md      # Final package creation
```

## Quick Start

### Basic Usage

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

### Output Example

Running the above produces:
- `windows_kerberoasting_suspicious_spn_requests.md` (detection blueprint)
- MITRE ATT&CK mapping (T1558.003)
- Sigma rule for Windows Security Event ID 4769
- Test procedures using Atomic Red Team
- False positive analysis
- Response guidance

## Integration Platforms

### Claude Projects (Recommended for Tyler)

**Setup:**
1. Create new Claude Project: "Detection Engineering"
2. Upload all `.md` files from this directory to Project Knowledge
3. Start new chat in project

**Usage:**
```
Plan and design a detection for <threat>. Generate a Sigma rule.
```

**Benefits:**
- No coding required
- Persistent context across chats
- Automatic skill access

### Claude Code

**Setup:**
```bash
# In your detection repository
mkdir -p skills/detection_engineering
cp *.md skills/detection_engineering/
```

**Usage:**
```bash
claude-code "Using detection engineering skills, create detection for 
AWS IAM privilege escalation. Output Sigma rule to /detections/aws/"
```

**Benefits:**
- Automates file creation
- Integrates with git workflow
- Batch processing capabilities

### Cursor IDE

**Setup:**
Add to `.cursorrules`:
```
Detection Engineering Skills: /skills/detection_engineering/
Default format: Sigma rules
Prioritize precision over recall for detections
```

**Usage:**
```
# Inline editing (Cmd+K)
Using Detection Logic Design skill, convert this behavior to Sigma rule

# Or in chat
Apply Research & Context skill to OAuth token theft
```

**Benefits:**
- Real-time assistance while coding
- Inline rule generation
- Debug existing detections

## Skill Descriptions

### Skill 1: Research & Context
Maps threat to MITRE ATT&CK, documents normal vs. malicious behavior, identifies telemetry surfaces.

**Use when:** Starting new detection from threat intel, incident, or technique

**Output:** Context package with ATT&CK mapping, system baseline, attack patterns

### Skill 2: Detection Objective & Scope
Defines precise detection goals, scope boundaries, and success criteria.

**Use when:** Translating research into actionable detection requirements

**Output:** Detection hypothesis, exclusions, noise tolerance targets

### Skill 3: Data Source & Telemetry Mapping
Identifies required logs, maps to specific fields, documents visibility gaps.

**Use when:** Planning data requirements before writing detection logic

**Output:** Data source matrix, field mappings, configuration prerequisites

### Skill 4: Detection Logic Design
Creates vendor-agnostic analytics, optionally generates Sigma/YARA rules.

**Use when:** Converting detection objectives into executable logic

**Output:** Pseudo-logic description, Sigma/YARA rule (if requested), tuning notes

### Skill 5: Validation & Testing Plan
Designs positive/negative test cases, defines evaluation metrics.

**Use when:** Planning validation before deployment

**Output:** Test procedures, Atomic Red Team IDs, FP analysis approach

### Skill 6: Detection Blueprint Assembly
Compiles all artifacts into deployment-ready markdown documentation.

**Use when:** Finalizing detection for repository commit

**Output:** Complete detection package with metadata, logic, tests, limitations

## Advanced Usage

### Individual Skills

```
# Research only
Apply Research & Context skill to Linux privilege escalation via cron

# Testing only
Run Validation & Testing Plan for this Sigma rule: [paste rule]

# Logic design from existing research
Using Detection Logic Design skill, create Sigma rule for:
- Technique: Pass-the-Hash (T1550.002)
- Observable: NTLM authentication from unexpected source
- Environment: Windows with Security Event ID 4624
```

### Partial Workflows

```
# Skills 1-3 only (research through data mapping)
Execute skills 1-3 for Azure AD conditional access bypass.
I'll write the detection logic after reviewing data requirements.

# Skills 4-6 only (logic through deployment)
I've researched OAuth device code phishing.
Execute skills 4-6 starting with logic design. Generate Sigma rule.

Context:
- Technique: T1566.002
- Target: Microsoft 365
- Key indicator: Device code flow from suspicious locations
```

### Custom Formats

```
# Splunk SPL instead of Sigma
Plan detection for mimikatz. Generate logic in Splunk SPL format.

# KQL for Microsoft Sentinel
Plan detection for suspicious PowerShell. Generate KQL query.

# YARA for malware
Plan detection for Cobalt Strike beacon. Generate YARA rule.
```

## Detection Output Format

Complete blueprints follow this structure:

```markdown
# [Detection Title]

## Metadata
- ID, Author, Date, Version
- MITRE ATT&CK Mapping
- Severity, Platform

## Threat Context
- Attack scenario
- Adversary tradecraft
- Known tools

## Detection Logic
- Objective and hypothesis
- Vendor-agnostic description
- Sigma/YARA rule
- Exclusion rationale

## Data Requirements
- Required sources (priority ranked)
- Field mappings
- Visibility gaps
- Configuration needs

## Validation & Testing
- Positive test procedures
- Negative test cases
- Evaluation metrics
- Tuning recommendations

## Response Guidance
- Triage steps
- Investigation queries
- Remediation actions

## Limitations
- Known gaps
- Assumptions
- Future enhancements

## References
- ATT&CK links
- Research papers
- Related detections
```

## Best Practices

### For Tyler's Workflow

**Optimize for learning:**
- Request Sigma rules by default
- Ask for Atomic Red Team test IDs
- Include MITRE ATT&CK context
- Prefer precision over recall (reduce noise)

**Effective prompts:**
```
# Good - specific and actionable
Plan detection for Okta MFA fatigue attacks targeting privileged users.
Generate Sigma rule. Include Atomic Red Team tests.

# Less effective - too vague
Detect authentication attacks
```

**Iterative refinement:**
```
# After initial detection
Review the false positive patterns in this Sigma rule.
Suggest additional exclusions for enterprise IT tools.

# After testing
This detection triggers on Microsoft SCCM. 
Apply tuning recommendations to exclude SCCM without losing coverage.
```

### Common Patterns

**Incident-driven detection:**
```
Plan detection based on this incident:
- Attacker used living-off-the-land binary certutil.exe
- Downloaded malicious payload from pastebin
- Executed via scheduled task

Generate Sigma rule targeting certutil download activity.
```

**Threat intel-driven detection:**
```
Plan detection for APT29 technique:
- Cloud token theft via Azure AD device registration abuse
- Technique: T1528
- Environment: Microsoft 365

Generate Sigma rule for Azure AD audit logs.
```

**Purple team-driven detection:**
```
Plan detection for this Atomic Red Team test: T1003.001-1
Test dumps LSASS using comsvcs.dll and rundll32.

Generate Sigma rule that catches this technique.
Include alternative tool variations (procdump, mimikatz).
```

## Troubleshooting

### Skills not activating

**Issue:** AI doesn't follow skill workflow

**Solution:** Use explicit orchestration prompt from `orchestration_template.md`

### Generic detections

**Issue:** Output lacks specificity

**Solution:** Provide more context in initial prompt:
- Specific tools/techniques
- Environment constraints
- Precision vs. coverage preference

### Missing Sigma/YARA output

**Issue:** No rule generated

**Solution:** Explicitly request: "Generate Sigma rule" or "Generate YARA rule"

### Incomplete blueprints

**Issue:** Missing sections in final output

**Solution:** Request full workflow execution: "Execute all 6 skills" or "Complete detection blueprint"

## Examples

See `orchestration_template.md` for:
- Full workflow examples
- Single skill invocations
- Partial workflow patterns
- Custom format requests
- Environment-specific detections

## Extending the Framework

### Add Custom Skills

Create new skills following this template:

```markdown
# Skill N: [Skill Name]

**Name:** [Short name]

**When to use:** [Trigger conditions]

**Inputs:**
- [Required information]

**Workflow steps:**
1. [Step 1]
2. [Step 2]
...

**Outputs:**
[Structured artifact description]

**References:**
- [External resources]
```

### Modify Workflows

Customize orchestration for your environment:
- Add organization-specific exclusions
- Include proprietary data sources
- Integrate with internal tools
- Enforce detection naming conventions

## Contributing

To improve these skills:
1. Test with real threat scenarios
2. Document edge cases
3. Refine workflow steps
4. Share enhanced versions

## References

- [Original Threat Hunter Playbook Article](https://blog.openthreatresearch.com/evolving-the-threat-hunter-playbook-planning-hunts-with-agent-skills/)
- [Sigma Specification](https://github.com/SigmaHQ/sigma-specification)
- [YARA Documentation](https://yara.readthedocs.io/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
- [OSSEM Project](https://github.com/OTRF/OSSEM)

## License

These skills are provided as templates for detection engineering workflows. Adapt and modify for your organization's needs.

## Version

Version 1.0 - Initial release based on Threat Hunter Playbook methodology adapted for detection engineering
