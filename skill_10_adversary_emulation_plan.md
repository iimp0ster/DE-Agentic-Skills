# Skill 10: Adversary Emulation Plan Design

**Name:** Adversary Emulation Plan Design

**When to use:** After Detection Logic Design (Skill 4) and before Validation & Testing (Skill 5). Use this skill when you need to validate detections against realistic, sequenced adversary behavior rather than isolated atomic tests. Triggers include: "emulate this threat actor," "build a purple team exercise for this technique chain," "generate a TTPRunner plan," or "design a VECTR campaign for this detection."

**Inputs:**
- Detection hypothesis and target technique(s) from Skill 2
- Threat actor or campaign context from Skill 1 or Skill 7 (optional but strongly preferred)
- Target lab environment details (OS, available agents: WinRM/SSH/QMP, Proxmox setup)
- Optional: Existing threat report, STIX bundle, or Attire JSON to seed the plan
- Optional: VECTR instance URL for campaign tracking

**Workflow steps:**

1. **Select or define the threat actor profile** - Establish whose behavior is being emulated:
   - Identify the threat group, campaign, or representative adversary archetype (e.g., APT29, ransomware-as-a-service operator, generic opportunistic actor)
   - If no specific actor is available, construct a representative profile using ATT&CK Groups data
   - Document the actor's objectives, target sector, and typical kill chain scope
   - Reference: MITRE ATT&CK Groups, Mandiant/CrowdStrike/SentinelOne actor profiles

2. **Sequence the kill chain** - Order TTPs into a realistic attack narrative:
   - Map techniques across kill chain phases in the order they would realistically occur:
     `Initial Access → Execution → Persistence → Privilege Escalation → Defense Evasion → Credential Access → Discovery → Lateral Movement → Collection → Exfiltration / Impact`
   - Identify the **primary technique** the detection targets and its position in the chain
   - Include 2-4 preceding and 1-2 following techniques to emulate realistic context
   - Note dependencies between steps (e.g., credential theft must precede lateral movement)

3. **Define procedures for each technique** - Translate techniques into executable commands:
   - For each technique step:
     - **Technique ID:** MITRE ATT&CK ID and name (e.g., T1059.001 — PowerShell)
     - **Procedure:** Specific command, script, or tool invocation
     - **Platform:** Windows / Linux / macOS
     - **Execution method:** WinRM, SSH, or QMP guest agent (for TTPRunner compatibility)
     - **Expected artifacts:** Events, log entries, or files that should be generated
   - Prefer procedures sourced from: Atomic Red Team, real malware samples (defanged/benign variants), or documented threat actor TTPs
   - Flag any step that requires elevated privileges or specific pre-conditions

4. **Define expected telemetry per step** - Map what each procedure should generate:
   - For each technique step, document:
     - **Event source:** Which log/sensor should capture it (Sysmon, WinEvt, EDR, auditd)
     - **Event ID / log type:** Specific event identifier
     - **Key fields and values:** Field name → expected value or pattern
     - **Detection alignment:** Which detection rule or hypothesis should fire on this step
   - This becomes the ground truth for emulation result analysis (Skill 11)

5. **Structure the TTPRunner execution plan** - Format for tooling:
   - Organize steps as an ordered list consumable by TTPRunner:
     ```
     Emulation Plan: [Plan Name]
     Target: [hostname/IP]
     Execution method: [WinRM | SSH | QMP]

     Step 1: [Technique ID] — [Technique Name]
       Procedure: [exact command or script]
       Platform: [Windows | Linux]
       Expected artifacts: [event IDs, file paths, network connections]

     Step 2: ...
     ```
   - Alternatively, produce as Attire JSON format if execution via Attire-compatible runner
   - Mark steps as: **active** (execute for real), **simulated** (log-only, no execution), or **skipped** (out of scope this run)

6. **Configure VECTR campaign** - Set up purple team tracking:
   - Define VECTR campaign metadata:
     - Campaign name: `[ThreatActor]_[Platform]_[Date]` (e.g., `APT29_Windows_2025Q1`)
     - Assessment group: red team / purple team
     - ATT&CK version in use
   - Map each emulation step to a VECTR test case:
     - Test case name, technique ID, procedure description
     - Outcome fields to populate post-execution: detected / not detected / blocked / logged only
   - VECTR auto-sync: if using TTPRunner with VECTR integration, confirm deployment and campaign sync settings

7. **Document pre-execution prerequisites** - Ensure lab readiness:
   - Target system requirements (OS version, configuration state, installed software)
   - Required pre-conditions per step (e.g., "domain-joined host," "local admin account present," "AV disabled for benign emulation steps")
   - Monitoring prerequisites: confirm all required log sources are active and ingesting before execution
   - Snapshot/restore point: recommend VM snapshot before execution for clean reset
   - Safety notes: flag any steps that write to disk, create accounts, or modify system state

**Outputs:**
Structured adversary emulation plan containing:
- Threat actor profile and kill chain narrative
- Sequenced TTP list with technique IDs, procedures, and platform details
- Per-step expected telemetry (event source, ID, key fields) mapped to detection hypotheses
- TTPRunner-formatted execution plan (Markdown or Attire JSON)
- VECTR campaign configuration with pre-populated test cases
- Pre-execution prerequisite checklist
- Safety and rollback guidance

**References:**
- TTPRunner (Antonlovesdnb/TTPRunner) — AI-powered TTP execution agent
- VECTR — Purple team tracking and metrics platform (vectr.io)
- MITRE ATT&CK Evaluations methodology
- Center for Threat-Informed Defense Adversary Emulation Library
- Atomic Red Team test library (atomicredteam.io)
- Attire JSON format specification
- SCYTHE emulation plans
