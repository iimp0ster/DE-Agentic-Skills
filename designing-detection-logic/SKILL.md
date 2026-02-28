---
name: designing-detection-logic
description: Designs the analytical logic that implements a detection objective. Classifies the pattern type, writes vendor-agnostic pseudo-logic, adds noise reduction filters, and optionally generates a Sigma or YARA rule. Use after data source mapping is complete. Triggers: "design the detection logic", "write a Sigma rule", "create the detection query."
---

# Designing Detection Logic

**Inputs:**
- Detection hypothesis from Skill 2
- Data source mapping from Skill 3
- User preference for query language (Sigma, YARA, vendor-agnostic)

**Workflow steps:**

1. **Define core detection pattern** - Identify the fundamental logic type:
   - **Signature-based:** Specific IoC, known malicious value, tool artifact
   - **Behavioral:** Sequence of events, process relationship, timing pattern
   - **Statistical:** Threshold, outlier, aggregation anomaly
   - **Correlation:** Multi-source event relationship, kill chain progression

2. **Design primary logic conditions** - Build the core detection criteria:
   - What events to match
   - Required field values or patterns
   - Event relationships (parent/child, temporal sequence)
   - Aggregation rules (count, frequency, distinct values)

3. **Add noise reduction filters** - Layer in exclusions:
   - Known benign processes, users, paths
   - Expected administrative activity patterns
   - Whitelisted source IPs, hostnames, accounts
   - Time-based filters (business hours vs. off-hours)

4. **Anchor to attack patterns** - Reference known adversary techniques:
   - Common tool command-line patterns
   - Typical file paths or registry keys
   - Expected process execution chains
   - API call sequences

5. **Handle edge cases** - Account for variations:
   - Case sensitivity in strings
   - Path normalization (forward vs. backslash)
   - Encoding variations (Unicode, Base64)
   - Platform differences (Windows vs. Linux)

6. **Express as vendor-agnostic pseudo-logic** - Write human-readable detection description:
   ```
   DETECT events WHERE:
     - [primary conditions]
     - AND [required relationships]
     - AND NOT [exclusions]
     - GROUP BY [aggregation keys]
     - HAVING [threshold conditions]
   ```

7. **Optional: Translate to specific format** - If user requests Sigma or YARA:
   - Generate Sigma rule with proper schema
   - Or generate YARA rule with strings/conditions
   - Include rule metadata (author, date, references, severity)

**Outputs:**
Detection logic package containing:
- Pattern type classification
- Vendor-agnostic pseudo-logic description
- Core conditions and filters
- Edge case handling notes
- Optional: Sigma rule or YARA rule (if requested)
- Known false positive patterns
- Tuning recommendations

**References:**
- Sigma specification and rule examples
- YARA documentation
- Detection logic patterns from Splunk Security Content, Elastic Detection Rules
