# Skill 5: Validation & Testing Plan

**Name:** Validation & Testing Plan

**When to use:** After Detection Logic Design is complete. Designs comprehensive testing approach to validate detection effectiveness. For adversary emulation-based validation, this skill produces the test design that feeds into Skill 10 (Adversary Emulation Plan Design). Skill 11 (Emulation Results Analysis) then closes the loop after execution.

**Inputs:**
- Detection logic from Skill 4
- Detection hypothesis from Skill 2
- Available testing infrastructure (lab, prod data, simulation tools)
- Optional: Adversary emulation capability (TTPRunner, Caldera, SCYTHE, manual lab)

**Workflow steps:**

1. **Design positive validation tests** - Create malicious behavior simulation plan:
   - **Atomic tests:** Simple command-line reproduction steps
   - **Tool-based tests:** Using Atomic Red Team, Invoke-AtomicRedTeam, Caldera, or similar
   - **Manual procedures:** Step-by-step instructions for lab execution
   - **Expected telemetry:** Exact events/fields that should appear
   - **Detection trigger criteria:** What the rule should match

2. **Design negative validation tests** - Create benign behavior test cases:
   - Common administrative tasks that resemble attack
   - Legitimate tools with similar signatures
   - Normal user workflows in target environment
   - Expected behavior: Detection should NOT trigger

3. **Plan historical data analysis** - If production data available:
   - Retrospective query approach (search last 30/60/90 days)
   - Baseline false positive rate estimation
   - Pattern frequency analysis
   - Sample size requirements for statistical confidence

4. **Define evaluation metrics** - Establish measurement criteria:
   - **Precision:** True Positives / (True Positives + False Positives)
   - **Recall:** Coverage of known attack variants
   - **Alert volume:** Expected alerts per day/week
   - **Detection latency:** Time from event to alert
   - **Investigation effort:** Average time to triage

5. **Create test execution matrix** - Document test scenarios:
   ```
   | Test ID | Type | Procedure | Expected Result | Pass/Fail Criteria |
   ```

6. **Plan iterative tuning** - Define refinement process:
   - Initial deployment mode (monitor-only vs. active alerting)
   - Tuning feedback loop (analyst input, FP patterns)
   - Threshold adjustment approach
   - Documentation of rule changes

7. **Specify adversary emulation requirements** - If emulation infrastructure is available, extend the test plan with emulation-specific inputs for Skill 10:
   - **Kill chain context:** Identify which kill chain phases should precede and follow the target technique to make emulation realistic (not just isolated atomic execution)
   - **Threat actor alignment:** Specify which threat actor or campaign profile the emulation should represent, enabling Skill 10 to sequence TTPs accurately
   - **Per-procedure expected telemetry:** For each positive test procedure, document the exact expected events (source, event ID, key fields) — this becomes the ground truth map Skill 10 requires and Skill 11 compares against
   - **Execution method preference:** WinRM / SSH / QMP guest agent (for TTPRunner), or manual lab execution
   - **VECTR tracking:** Confirm whether VECTR campaign setup is required; provide campaign naming convention
   - **Simulation mode flag:** Note which steps should run in simulation-only mode (no actual execution) vs. active execution — particularly important for destructive or noisy techniques
   - **Lab prerequisites:** Enumerate target system configuration requirements (OS version, domain membership, installed software, required accounts) that Skill 10's prerequisite checklist will formalize

**Outputs:**
Validation plan document containing:
- Positive test procedures (malicious simulation)
- Negative test cases (benign scenarios)
- Historical analysis approach
- Evaluation metrics and targets
- Test execution matrix
- Tuning and refinement plan
- Tools and commands for testing
- Adversary emulation inputs (kill chain context, expected telemetry map, lab prerequisites) for handoff to Skill 10

**References:**
- Atomic Red Team test library
- MITRE ATT&CK Evaluations methodology
- Detection validation frameworks (DeTTECT, ATT&CK Navigator)
- TTPRunner (Antonlovesdnb/TTPRunner) — AI-powered TTP execution agent
- VECTR — Purple team tracking and metrics (vectr.io)
- Skill 10 (Adversary Emulation Plan Design) — converts this plan into executable emulation format
- Skill 11 (Emulation Results Analysis) — analyzes outputs and feeds fixes back into detection logic
