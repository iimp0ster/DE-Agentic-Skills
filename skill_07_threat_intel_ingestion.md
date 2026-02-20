# Skill 7: Threat Intelligence Ingestion

**Name:** Threat Intelligence Ingestion

**When to use:** User provides a threat intelligence artifact — a blog post, security advisory, threat report, IOC feed, or raw indicator list — and wants to convert it into structured detection inputs. Use this skill before Skill 1 (Research & Context) when starting from external intel rather than a threat scenario description.

**Inputs:**
- Threat intel artifact: URL, pasted report text, advisory PDF summary, or IOC list
- Optional: Target environment context (platform, SIEM/data lake type)
- Optional: Preferred output format (Sigma, KQL, SPL, SQL)

**Workflow steps:**

1. **Parse the intel artifact** - Extract all structured information from the source:
   - Threat actor / campaign name and aliases
   - Malware families and tools mentioned
   - Targeted platforms, sectors, and geographies
   - Timeline of observed activity

2. **Extract ATT&CK techniques** - Map described behaviors to MITRE ATT&CK:
   - Identify explicit technique mentions
   - Infer techniques from described behaviors (e.g., "loaded DLL from temp path" → T1574.001)
   - Note tactic context (Initial Access, Execution, Persistence, etc.)
   - Flag sub-techniques where identifiable

3. **Extract indicators of compromise (IOCs)** - Catalog all indicators:
   - File hashes (MD5, SHA1, SHA256) with associated context
   - IP addresses and domains with observed roles (C2, staging, exfil)
   - File paths, registry keys, mutex names, named pipes
   - User-agent strings, certificate thumbprints, email headers
   - Note volatility/shelf life of each indicator type

4. **Extract behavioral patterns** - Identify higher-fidelity, durable signals:
   - Command-line patterns and arguments
   - Process execution chains (parent → child relationships)
   - Network communication patterns (timing, protocol, port, payload structure)
   - File system or registry modification patterns
   - API call sequences or authentication patterns
   - Note: behavioral patterns are preferred over IOCs for long-term detection value

5. **Assess detection priority** - Evaluate each extracted TTP/indicator:
   - **High priority:** Behavioral patterns unique to this threat, rare in benign traffic
   - **Medium priority:** Technique-level behaviors that require tuning
   - **Low priority:** Commodity IOCs (IPs, hashes) with short shelf life
   - Note which items require environmental context to detect effectively

6. **Structure as detection inputs** - Format extracted intel for handoff to downstream skills:
   - One entry per detectable behavior/technique
   - For each: technique ID, behavior description, key observables, data source requirements
   - Flag items ready for immediate detection vs. those needing additional research

**Outputs:**
Structured threat intel package containing:
- Threat actor / campaign summary
- ATT&CK technique list with tactic context
- IOC catalog with volatility assessment
- Prioritized behavioral pattern list
- Per-item detection input cards (technique + observable + data source)
- Recommended skill 1-6 workflow order for highest-priority items

**References:**
- MITRE ATT&CK Navigator (for technique mapping)
- STIX/TAXII standards for structured threat intel
- OpenCTI, MISP for intel platform integration
- Vendor threat intelligence reports (CrowdStrike, Mandiant, SentinelOne, Microsoft MSTIC)
