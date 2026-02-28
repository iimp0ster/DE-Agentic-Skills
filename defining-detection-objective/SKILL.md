---
name: defining-detection-objective
description: Translates threat research into an actionable detection goal with clear scope boundaries. Defines detection hypothesis, noise tolerance targets, success criteria, and benign behavior exclusions. Use after threat research is complete to establish what the detection will alert on and what it will exclude before designing logic.
---

# Defining Detection Objective

**Inputs:**
- Research & Context output from previous skill
- User requirements for detection precision vs. coverage
- Operational constraints (noise tolerance, analyst capacity, response SLA)

**Workflow steps:**

1. **Define detection objective** - Write a precise statement of what malicious behavior the detection will alert on. Must be specific enough to guide logic design but not implementation-specific.

2. **Establish scope boundaries** - Define:
   - Target environments (Windows/Linux/macOS, cloud platforms, SaaS)
   - User populations in scope (all users, privileged only, external accounts)
   - Time window considerations (real-time vs. batch analysis)
   - Coverage level (comprehensive vs. high-confidence subset)

3. **Identify what should NOT alert** - Document legitimate use cases that mimic attack behavior. List known benign patterns that must be excluded.

4. **Set noise tolerance** - Define acceptable false positive rate based on analyst capacity and threat severity. Express as frequency (e.g., "< 5 FPs per day").

5. **Establish success criteria** - Define what makes this detection successful:
   - Must detect technique variants A, B, C
   - Must not alert on benign scenarios X, Y
   - Precision target (e.g., "90% true positives")
   - Response requirement (e.g., "actionable within 15 minutes")

6. **Formulate detection hypothesis** - Write structured hypothesis in format:
   - **Detection Name:** [Descriptive title]
   - **Hypothesis:** "IF [specific conditions], THEN [likely malicious behavior], BECAUSE [adversary tradecraft reasoning]"
   - **Risky indicators:** [Key signals of malicious activity]
   - **Benign exclusions:** [Patterns to filter out]

**Outputs:**
Structured detection objective document containing:
- Clear detection objective statement
- Scope boundaries and constraints
- Benign behavior exclusions
- Noise tolerance target
- Success criteria checklist
- Formal detection hypothesis

**References:**
- Detection-as-Code best practices
- PEAK threat hunting framework (for hypothesis formulation)
