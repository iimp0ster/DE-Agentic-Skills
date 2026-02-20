# Skill 1: Research & Context

**Name:** Research & Context

**When to use:** User provides a threat scenario, attack technique, or detection idea that needs foundational research before detection design. Triggers include requests like "build a detection for X," "detect Y attack," or "I need to monitor for Z behavior."

**Inputs:**
- Threat scenario description (e.g., "Okta MFA fatigue," "LSASS credential dumping," "Kerberoasting")
- Optional: Specific environment context (cloud/on-prem, platforms, existing telemetry)

**Workflow steps:**

1. **Normalize the threat scenario** - Extract the core malicious behavior pattern from user description. Map to MITRE ATT&CK technique ID and name if applicable.

2. **Build system internals context** - Document how the targeted system/component normally operates. Identify legitimate use cases, normal user patterns, administrative workflows, and baseline behavior.

3. **Build adversary tradecraft context** - Research how adversaries actually abuse this system component. Document known tools, common command patterns, API abuse sequences, and realistic attack paths observed in the wild.

4. **Identify telemetry surfaces** - List where this behavior creates observable artifacts (process creation, file writes, registry modifications, network connections, API calls, authentication events, etc.).

5. **Document assumptions and constraints** - Note environment dependencies, configuration requirements, and known limitations for detection.

6. **Gather reference materials** - Compile ATT&CK mappings, relevant CVEs, known tool signatures, threat intel reports, and technical documentation links.

**Outputs:**
Structured context package containing:
- Normalized threat name and ATT&CK mapping
- System behavior baseline
- Adversary abuse patterns
- Observable telemetry surfaces
- Key assumptions and constraints
- Reference links (MITRE, threat intel, technical docs)

**References:**
- MITRE ATT&CK Framework
- Atomic Red Team test cases
- LOLBAS/GTFOBins for living-off-the-land techniques
- Vendor security research blogs
