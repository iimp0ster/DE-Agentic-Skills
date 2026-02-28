---
name: analyzing-coverage-gaps
description: Maps an existing detection library to the MITRE ATT&CK framework, identifies coverage gaps, assesses detection quality, and produces a prioritized detection roadmap. Use at the program level to assess detection library maturity or plan new detection work. Triggers: "what are we missing", "map our coverage to ATT&CK", "prioritize our next detections", "show our detection gaps."
---

# Analyzing Coverage Gaps

**Inputs:**
- Existing detection inventory (list of detections with technique mappings, or a description of current coverage)
- Optional: Threat intelligence context (industry-specific threat actors, recent campaigns)
- Optional: Environment constraints (available data sources, platform scope)
- Optional: Business context (risk tolerance, critical asset inventory)

**Workflow steps:**

1. **Inventory existing detections** - Build a structured map of current coverage:
   - List all active detections with their ATT&CK technique/sub-technique mappings
   - Note detection quality indicators where known (false positive rate, last validated date, coverage confidence: high/medium/low)
   - Identify detections with no ATT&CK mapping (unmapped coverage)
   - Group by tactic (Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, Exfil, C2, Impact)

2. **Map coverage to ATT&CK** - Produce a coverage heatmap summary:
   - For each tactic: count of techniques with active detections vs. total techniques in framework
   - Identify tactics with zero or minimal coverage
   - Note sub-technique coverage within covered techniques (partial vs. full coverage)
   - Flag detections that cover multiple techniques (correlation rules)

3. **Identify coverage gaps** - Analyze what is not detected:
   - **Tactic-level gaps:** Entire attack phases with no detection
   - **Technique-level gaps:** Specific techniques commonly used by relevant threat actors but undetected
   - **Sub-technique gaps:** Techniques covered at the parent level but not specific variants
   - **Platform gaps:** Techniques covered on Windows but not Linux/macOS/cloud

4. **Prioritize gaps by threat relevance** - Rank gaps by risk:
   - Cross-reference gaps with threat actor TTPs relevant to the organization's industry
   - Identify techniques observed in recent incidents or campaigns (last 12 months)
   - Weight by technique prevalence in the wild (use ATT&CK frequency data, threat reports)
   - Consider data source availability — deprioritize gaps where required telemetry is absent
   - Classify each gap: **Critical** (actively exploited, no coverage), **High** (commonly used, no coverage), **Medium** (used by relevant actors, partial coverage), **Low** (low prevalence or telemetry unavailable)

5. **Assess detection quality** - Beyond binary covered/not-covered:
   - Identify detections that are stale (not validated in >6 months)
   - Flag low-confidence detections (high false positive rate, overly broad logic)
   - Note detections dependent on data sources with quality issues (from Skill 8 baseline)
   - Identify redundant detections covering the same behavior
   - Highlight detection chains where a gap in one technique breaks kill chain coverage

6. **Produce prioritized detection roadmap** - Output actionable work queue:
   - Ordered list of gap items to address, with rationale
   - For each item: technique ID, tactic, priority, recommended detection approach, required data sources
   - Estimated detection complexity (simple signature vs. behavioral correlation vs. requires new data source)
   - Quick wins: gaps that can be closed with existing data and low engineering effort

**Outputs:**
Detection coverage report containing:
- ATT&CK coverage heatmap summary (by tactic, with counts)
- Prioritized gap list (Critical/High/Medium/Low) with threat context
- Detection quality assessment (stale, low-confidence, redundant detections)
- Prioritized detection roadmap (ordered work queue)
- Data source gaps limiting coverage expansion
- Recommended next 3-5 detections to build

**References:**
- MITRE ATT&CK Navigator (for visualization and coverage mapping)
- DeTTECT framework (for data source and detection coverage scoring)
- ATT&CK for Enterprise technique frequency data
- CISA Known Exploited Vulnerabilities catalog
- Industry-specific threat intelligence reports (FS-ISAC, H-ISAC, etc.)
