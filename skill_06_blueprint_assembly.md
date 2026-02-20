# Skill 6: Detection Blueprint Assembly

**Name:** Detection Blueprint Assembly

**When to use:** After all previous skills (1-5) are complete. Assembles final deployment-ready detection package.

**Inputs:**
- All outputs from Skills 1-5
- Organizational detection documentation standards
- Target detection repository structure

**Workflow steps:**

1. **Generate normalized detection name** - Create filesystem-safe identifier:
   - Format: `platform_technique_specificity.md` or `.yml`
   - Example: `windows_lsass_memory_dump_suspicious_process.md`
   - Ensure uniqueness in detection repository

2. **Structure metadata section** - Compile detection header:
   - Detection title (human-readable)
   - Unique detection ID
   - Author and creation date
   - Last modified date
   - Version number
   - Severity/priority classification
   - MITRE ATT&CK mapping (technique, sub-technique, tactics)

3. **Assemble threat context** - Integrate from Skill 1:
   - Threat scenario description
   - Adversary tradecraft summary
   - Known tools and attack patterns
   - Real-world incident references

4. **Document detection logic** - Include from Skills 2 and 4:
   - Detection objective and hypothesis
   - Core logic description (vendor-agnostic)
   - Actual detection rule (Sigma/YARA if generated)
   - Key filtering and exclusion rationale

5. **Specify data requirements** - From Skill 3:
   - Required data sources with priority
   - Critical field mappings
   - Visibility gaps and assumptions
   - Configuration prerequisites

6. **Include validation materials** - From Skill 5:
   - Testing procedures summary
   - Key test cases (at least 2 positive, 2 negative)
   - Expected false positive patterns
   - Tuning recommendations

7. **Document operational guidance** - Add response information:
   - Triage steps for analysts
   - Investigation leads and enrichment queries
   - Response/remediation recommendations
   - Escalation criteria

8. **Capture limitations and assumptions** - Transparency section:
   - Known detection gaps (what it won't catch)
   - Environment assumptions
   - Performance considerations
   - Future enhancement ideas

9. **Add references** - Link to external resources:
   - ATT&CK technique pages
   - Threat research blog posts
   - Tool documentation
   - Related detections

10. **Format as markdown document** - Structure with clear sections:
    ```markdown
    # [Detection Title]
    
    ## Metadata
    ## Threat Context
    ## Detection Logic
    ## Data Requirements
    ## Validation & Testing
    ## Response Guidance
    ## Limitations
    ## References
    ```

**Outputs:**
Complete detection blueprint as structured markdown file ready for:
- Version control commit
- Detection platform deployment
- Analyst reference documentation
- Knowledge base integration

**References:**
- Detection-as-Code repository examples (Palantir Alerting, Elastic Detection Rules)
- Sigma rule specification
- Detection engineering maturity models
