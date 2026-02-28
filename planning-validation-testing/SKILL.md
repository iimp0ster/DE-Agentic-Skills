---
name: planning-validation-testing
description: Designs a comprehensive testing approach to validate detection effectiveness. Produces positive and negative test procedures, an evaluation metrics framework, an Atomic Red Team test plan, and an iterative tuning strategy. Use after detection logic is designed to plan how to verify the detection fires correctly and doesn't produce excessive false positives.
---

# Planning Validation & Testing

**Inputs:**
- Detection logic from Skill 4
- Detection hypothesis from Skill 2
- Available testing infrastructure (lab, prod data, simulation tools)

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

**Outputs:**
Validation plan document containing:
- Positive test procedures (malicious simulation)
- Negative test cases (benign scenarios)
- Historical analysis approach
- Evaluation metrics and targets
- Test execution matrix
- Tuning and refinement plan
- Tools and commands for testing

**References:**
- Atomic Red Team test library
- MITRE ATT&CK Evaluations methodology
- Detection validation frameworks (DeTTECT, ATT&CK Navigator)
