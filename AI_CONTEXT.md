You are working on the HASAD project repository.

Task: Improve and harden AI agent guidance by updating AI_CONTEXT.md.

IMPORTANT:
Do not rewrite the whole file blindly.
Preserve all existing valuable architectural knowledge, sprint history, ADR references, and technical decisions.

Perform the following:

## 1. Add AI Agent Operating Rules

Add a new top-level section near the beginning of AI_CONTEXT.md:

# HASAD AI Agent Operating Rules

This section must define how any AI agent working on HASAD must behave.

Include the following mandatory rules:

### Engineering Approach
The AI agent must behave as:
- Senior Software Architect
- Lead Flutter Engineer
- Senior ASP.NET Core Engineer
- Offline-First Systems Specialist

Before any code change:

1. Understand existing architecture.
2. Review:
  - AI_CONTEXT.md
  - PROJECT_STATUS.md
  - Relevant ADRs.
3. Identify affected modules.
4. Perform root cause analysis.
5. Provide evidence before proposing fixes.

Never implement fixes based only on symptoms.

---

### Root Cause Analysis Rule

For every bug investigation:

Follow:

1. Reproduce the problem.
2. Collect evidence:
  - Application logs
  - Database state
  - API requests/responses
  - Stack traces
  - SyncQueue state
3. Identify the first failing operation.
4. Explain why it failed.
5. Propose the smallest safe solution.

The first failure point is the root cause, not the final visible error.

---

### Offline-First Synchronization Rules

Define these permanent HASAD rules:

- Drift Database is the local source of truth before synchronization.
- SyncQueue represents synchronization intent, not authoritative data.
- Server becomes authoritative after successful synchronization.

For complex aggregates:

Example:

DamageReport
├── DamageItems
└── Evidence

The agent must verify:

- Parent-child relationships.
- ClientId / ServerId mapping.
- Sync ordering.
- Retry behavior.
- Partial failure recovery.
- Idempotency.

Never assume queued JSON snapshots represent the latest local state.

---

### Synchronization Investigation Workflow

Add mandatory tracing flow:

UI Action
↓
Local Drift Transaction
↓
SyncQueue Creation
↓
BackgroundSyncService Processing
↓
Payload Generation
↓
HTTP Request
↓
Backend Command Handler
↓
Response Mapping
↓
Local Database Update
↓
Queue Completion

The agent must locate the first broken stage.

---

### Backend Contract Alignment

Before changing mobile synchronization:

Verify:

- API endpoint contract.
- Command models.
- Validators.
- Domain rules.
- Response envelope.
- Error handling.

Do not fix backend contract violations only from Flutter.

---

### Database and Migration Rules

Add:

Never:

- Delete lookup/reference data to solve migration problems.
- Recreate IDs.
- Break foreign key relationships.
- Change existing identifiers without migration strategy.

Always verify:

- Existing data integrity.
- Foreign keys.
- Seed ownership.
- Fresh installation.
- Upgrade migration path.
- Offline synchronization compatibility.

---

### Testing Requirements

Every implementation must include:

- Unit tests.
- Integration tests when applicable.
- Regression verification.

For synchronization changes always test:

Offline Create
↓
Offline Update
↓
Reconnect
↓
Synchronization
↓
Failure Retry
↓
Recovery

---

### Documentation Continuity

After completing any significant task:

Update when required:

- PROJECT_STATUS.md
- AI_CONTEXT.md
- ADR documents

Document:

- What changed.
- Why it changed.
- Tests executed.
- Remaining risks.
- Future technical debt.

---

### Code Change Discipline

Before implementation provide:

- Root Cause Analysis.
- Implementation Plan.
- Files affected.
- Risks.

After implementation provide:

- Changed files.
- Tests executed.
- Verification results.
- Suggested commit message.

Avoid unnecessary refactoring.

---

### HASAD Terminology Rule

Ensure all future AI responses and documentation use:

Arabic:
"مساعدة"

English:
"Assistance"

Never use:
"تعويض"
or
"Compensation"

for HASAD business processes.

---

## 2. Review Existing AI_CONTEXT.md for Contradictions

After adding the rules:

Perform a consistency audit.

Look for contradictions between:

- Completed sprints.
- Architectural decisions.
- Current status.
- Technical debt.
- Migration decisions.

Specifically review:

- MeasurementUnit Consolidation section.
- DamageReport status.
- Offline Sync architecture.

If contradictions exist:

Do not delete historical information.

Instead:

- Mark outdated decisions clearly.
- Move them to historical notes if needed.
- Preserve project evolution.

---

## 3. Preserve Existing Knowledge

Do not remove:

- Sprint history.
- ADR references.
- Completed implementation details.
- Architecture rules.
- Security decisions.

Only improve organization and clarity.

---

## 4. Validation

After editing:

Verify:

- Markdown formatting is valid.
- No duplicated sections.
- No conflicting rules remain.
- The document remains useful for a new AI agent joining the project.

Finally provide:

1. Summary of changes.
2. Sections added/modified.
3. Any contradictions discovered.
4. Recommendations for future AI agent setup.

Do not modify source code.
Only update documentation files.