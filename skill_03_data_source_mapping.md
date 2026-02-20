# Skill 3: Data Source & Telemetry Mapping

**Name:** Data Source & Telemetry Mapping

**When to use:** After Detection Objective & Scope is defined. Maps detection requirements to concrete data sources and field-level telemetry.

**Inputs:**
- Detection objective and hypothesis from previous skill
- Available data sources in target environment
- Logging configuration details (if known)

**Workflow steps:**

1. **Identify required data sources** - List all log sources needed to observe the malicious behavior:
   - EDR/XDR telemetry (process, file, network, registry)
   - OS native logs (Windows Event Logs, Syslog, auditd)
   - Cloud audit logs (Azure AD, AWS CloudTrail, GCP)
   - SaaS application logs (Okta, O365, GSuite)
   - Network telemetry (firewall, DNS, proxy, NetFlow)

2. **Prioritize data sources** - Rank by:
   - **Critical:** Required for core detection logic
   - **High:** Significantly improves detection accuracy
   - **Medium:** Provides enrichment context
   - **Low:** Nice-to-have for investigation

3. **Map to specific fields** - For each critical data source, document exact fields needed:
   - Field name (as it appears in logs)
   - Expected values or patterns
   - Field availability (always present vs. conditional)
   - Example values

4. **Document visibility gaps** - Identify missing telemetry:
   - Data sources not available in environment
   - Required fields not logged by default
   - Configuration changes needed (e.g., "Requires Sysmon Event ID 10 with LSASS access auditing")
   - Vendor-specific limitations

5. **Define data quality requirements** - Specify:
   - Required log retention period
   - Acceptable data latency (real-time vs. delayed ingestion)
   - Completeness requirements (must capture 100% vs. sampling acceptable)
   - Field parsing dependencies

6. **Create data availability matrix** - Table format:
   ```
   | Data Source | Priority | Required Fields | Availability | Gaps/Requirements |
   ```

**Outputs:**
Structured telemetry mapping document containing:
- Prioritized data source list
- Field-level mapping table
- Visibility gap analysis
- Configuration requirements
- Data quality specifications
- Alternative data sources (if primary unavailable)

**References:**
- Common Information Model (CIM) schemas
- Elastic Common Schema (ECS)
- OSSEM (Open Source Security Events Metadata)
