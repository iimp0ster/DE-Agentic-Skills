# Skill 11: Emulation Results Analysis

**Name:** Emulation Results Analysis

**When to use:** After an adversary emulation plan (Skill 10) has been executed in a lab or production-equivalent environment. Takes raw outputs from TTPRunner, VECTR, and collected telemetry and closes the feedback loop back into detection logic, tuning, and blueprint quality. Triggers include: "analyze my emulation results," "my detection didn't fire during the purple team exercise," "here are my TTPRunner outputs — what do I fix," or "update the detection based on emulation findings."

**Inputs:**
- TTPRunner execution artifacts (logs, screenshots, auto-generated markdown report)
- VECTR campaign results (outcome per test case: detected / not detected / blocked / logged only)
- Collected telemetry from the target environment during emulation (raw logs, SIEM query results, EDR alerts)
- Original detection hypothesis from Skill 2
- Original expected telemetry map from Skill 10 (Step 4)
- Optional: Skill 4 detection logic for direct comparison against findings

**Workflow steps:**

1. **Collect and normalize emulation artifacts** - Organize all outputs before analysis:
   - Ingest TTPRunner execution log: confirm which steps completed, which failed, which were skipped
   - Pull VECTR campaign outcomes per test case (detected / not detected / blocked / logged only)
   - Collect raw telemetry from the SIEM/data lake for the emulation time window
   - Document execution environment state: OS versions, agent configurations, any deviations from prerequisites
   - Flag any procedural failures (step did not execute as intended) — these must be excluded from detection analysis

2. **Map execution outcomes to expected telemetry** - Compare what happened against what was predicted:
   - For each emulation step, cross-reference:
     - **Executed:** Did the procedure run successfully?
     - **Telemetry generated:** Did the expected events appear (from Skill 10, Step 4)?
     - **Detection fired:** Did the detection rule/hypothesis alert?
   - Classify each step into one of four outcomes:
     - **True Positive (TP):** Procedure executed, telemetry generated, detection fired ✓
     - **False Negative (FN):** Procedure executed, telemetry generated, detection did not fire ✗
     - **Telemetry Gap (TG):** Procedure executed, expected telemetry was NOT generated ✗
     - **Execution Failure (EF):** Procedure did not execute correctly — exclude from scoring

3. **Root cause false negatives** - For each missed detection (FN), determine why:
   - **Logic gap:** Detection logic does not cover this specific procedure variant
     - Check field values, command patterns, or process names against actual telemetry
     - Identify which condition in the logic failed to match
   - **Tuning over-exclusion:** A filter or exclusion in the detection suppressed a real alert
     - Identify which exclusion clause matched the emulation procedure
     - Assess whether exclusion is too broad
   - **Threshold mismatch:** Statistical threshold not reached during emulation (e.g., count > 10 but only 3 events generated)
     - Note the observed count vs. the threshold; recommend adjustment with rationale
   - **Data source mismatch:** Detection queries a different field or source than where telemetry landed
     - Compare the field names in detection logic vs. actual telemetry field names
   - **Timing issue:** Detection window too narrow, events fell outside the lookback period

4. **Root cause telemetry gaps** - For each step where expected events were not generated (TG):
   - Identify whether the gap is:
     - **Logging not enabled:** Required audit policy, Sysmon rule, or EDR setting not configured
     - **Field not populated:** Event is generated but a required field is null or missing
     - **Ingestion delay or loss:** Events generated but not reaching SIEM within query window
     - **Platform/version difference:** Expected behavior differs on actual OS/software version
   - Document required configuration changes or data source gaps as action items
   - Reference these findings back into Skill 3 (Data Source & Telemetry Mapping) for the detection

5. **Score detection effectiveness** - Produce quantitative and qualitative assessment:
   - **Detection Rate:** TPs / (TPs + FNs) across all valid emulation steps
   - **Coverage breadth:** How many kill chain phases does the detection cover vs. miss
   - **False Positive baseline:** Any unexpected alerts triggered by benign emulation steps
   - **Technique variant coverage:** Which procedure variants triggered the detection vs. which evaded it
   - Express overall detection quality as: **Production-Ready / Needs Tuning / Logic Redesign Required / Blocked by Telemetry Gap**

6. **Generate detection improvement recommendations** - Produce specific, actionable changes:
   - For each FN with root cause identified, write a targeted fix:
     - **Logic fix:** Exact condition or field to add, modify, or relax
     - **Exclusion fix:** Specific exclusion clause to narrow or remove
     - **Threshold fix:** New recommended threshold value with observed baseline justification
   - For each TG, write a data source remediation item:
     - Required logging configuration change (e.g., "Enable Sysmon Event ID 10 for LSASS access")
     - Priority: Critical (blocks detection entirely) / High (reduces coverage) / Medium (enrichment only)
   - Prioritize fixes by impact: fixes that convert FNs to TPs first, then coverage expansion

7. **Close the detection loop** - Feed findings back into upstream skills:
   - Update Skill 4 (Detection Logic) with specific logic changes identified in Step 6
   - Update Skill 3 (Data Source Mapping) with newly discovered telemetry gaps
   - Update Skill 5 (Validation & Testing Plan) with procedure variants that revealed gaps — these become permanent regression test cases
   - Update Skill 6 (Blueprint Assembly) with:
     - Emulation validation evidence section (date, tool, outcome summary)
     - Revised known limitations (gaps that could not be closed in this iteration)
     - Updated tuning recommendations based on observed behavior

8. **Produce validation scorecard** - Structured summary for the detection record:
   ```
   Emulation Validation Scorecard
   ───────────────────────────────────────────
   Emulation Plan:   [Skill 10 plan name]
   Execution Tool:   TTPRunner / Manual / Caldera
   VECTR Campaign:   [Campaign ID or name]
   Execution Date:   [Date]
   Target Platform:  [OS / environment]

   Results Summary:
   ┌─────────────────────┬──────────┬─────────────────────────────┐
   │ Step (Technique ID) │ Outcome  │ Root Cause / Notes          │
   ├─────────────────────┼──────────┼─────────────────────────────┤
   │ T1059.001 (Step 2)  │ TP       │ Detection fired as expected │
   │ T1003.001 (Step 3)  │ FN       │ Logic gap: missing field X  │
   │ T1021.002 (Step 4)  │ TG       │ Sysmon EID 3 not enabled    │
   └─────────────────────┴──────────┴─────────────────────────────┘

   Detection Rate:   [X/Y steps, Z%]
   Overall Quality:  [Production-Ready | Needs Tuning | Logic Redesign | Blocked by Telemetry Gap]

   Priority Fixes:
   1. [Specific fix 1]
   2. [Specific fix 2]

   Telemetry Gaps (action required):
   1. [Configuration change 1]
   ```

**Outputs:**
Emulation results analysis package containing:
- Step-by-step outcome mapping (TP / FN / TG / EF per technique)
- Root cause analysis for each failure mode
- Quantitative detection effectiveness scorecard
- Prioritized list of detection logic fixes (specific and actionable)
- Telemetry gap remediation items (with configuration guidance)
- Updated detection blueprint sections (logic, limitations, validation evidence)
- Regression test cases for permanent inclusion in Skill 5 testing plan

**References:**
- TTPRunner (Antonlovesdnb/TTPRunner) — execution artifacts and auto-generated reports
- VECTR (vectr.io) — campaign outcome tracking and metrics
- MITRE ATT&CK Evaluations — detection scoring methodology
- DeTTECT — data source and detection coverage scoring
- Atomic Red Team — procedure reference for variant coverage analysis
