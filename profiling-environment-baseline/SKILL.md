---
name: profiling-environment-baseline
description: Documents organization-specific data schemas, tooling inventory, and known-noisy infrastructure to pre-tune detections for a specific environment. Produces a reusable exclusion baseline, data schema reference, and environment-specific tuning parameters. Use before detection logic design when the environment has unique configurations, known scanners, or specific field naming conventions.
---

# Profiling Environment Baseline

**Inputs:**
- Target environment description (OS versions, EDR/SIEM stack, cloud platforms)
- Available data schema documentation (field names, log formats, event IDs)
- Known enterprise tooling (IT management, vulnerability scanners, backup agents, etc.)
- Optional: Sample log data or field examples

**Workflow steps:**

1. **Document the data schema** - Catalog the exact field names and formats available in this environment:
   - SIEM/data lake field naming conventions (e.g., `process.name` vs. `ProcessName` vs. `proc_name`)
   - Which Event IDs or log types are actually ingested (vs. what the vendor supports)
   - Custom parsing rules or field extractions in use
   - Known schema inconsistencies between data sources
   - Query language in use (SPL, KQL, SQL/ANSI, ECS-based)

2. **Profile normal process and execution patterns** - Document what is typical in this environment:
   - Standard software deployment paths (e.g., custom install directories, non-standard `%ProgramFiles%`)
   - Scheduled task and service account naming conventions
   - Scripting tool usage (PowerShell, Python, bash — who uses them, for what)
   - Known automation and orchestration tools (Ansible, SCCM, Puppet, custom scripts)
   - Developer/admin populations and their normal tooling

3. **Catalog known-noisy infrastructure** - Document sources of detection noise specific to this environment:
   - Vulnerability scanners and their source IPs/accounts (Tenable, Qualys, Rapid7)
   - Backup and endpoint agents with privileged behavior (Veeam, CrowdStrike, Carbon Black)
   - IT management platforms with high-privilege access (SCCM, Intune, Jamf, Ansible)
   - Monitoring and observability tools (Datadog agents, Splunk UF, etc.)
   - Security tools that mimic attacker behavior (DLP, CASB, proxy, email gateway)

4. **Map environment-specific exclusion baselines** - Create reusable filter libraries:
   - Trusted process paths and hashes (signed software with unusual behavior)
   - Privileged service accounts with legitimate elevated access
   - Whitelisted source IPs for internal scanning and monitoring
   - Expected network connections (backup jobs, patch management, licensing beacons)
   - Time-based baselines (batch jobs, backup windows, maintenance periods)

5. **Identify data quality constraints** - Document limitations that affect detection design:
   - Log sources with known gaps, delays, or sampling (e.g., DNS logs only capture 10% of queries)
   - Fields that are conditionally populated vs. always present
   - Maximum query lookback period before data is archived or deleted
   - Known parsing failures or null field issues
   - Rate limits or cost constraints on certain query patterns

6. **Produce environment tuning parameters** - Summarize as reusable detection configuration:
   - Standard exclusion lists for high-noise sources
   - Field name mappings from generic to environment-specific
   - Environment-specific thresholds (e.g., "alert only if > 3 events in 5 min, not 10")
   - Alert routing recommendations (severity adjustments based on asset criticality)

**Outputs:**
Environment baseline profile containing:
- Data schema reference (field names, event IDs, query language)
- Normal behavior inventory (processes, accounts, tools)
- Known-noisy infrastructure catalog with recommended exclusions
- Reusable exclusion baseline lists
- Data quality constraints and limitations
- Environment-specific tuning parameters for use in Skills 4 and 5

**References:**
- Elastic Common Schema (ECS) field naming reference
- Windows Security Event ID reference (Microsoft docs)
- Sysmon configuration guides (SwiftOnSecurity, olafhartong)
- DeTTECT (Detection Coverage & Techniques) for data source coverage mapping
- Organization's internal runbooks and architecture diagrams
