## Task management startup

1. Read only the Task Registry at the top of `Maintanance/PROGRESS_OVERVIEW.md`
   to establish the current task state.
2. Treat that Registry as the sole source of truth for remaining tasks, status,
   ownership, restart conditions, and required task dependencies.
3. After selecting a task, read only the detailed canonical document linked
   from that task row.
4. Do not scan all planning documents or archived records at session start.
   Do not revive tasks from old checklists, handoffs, or logs.
5. Priority order is: the user's latest instruction, the Task Registry, the
   selected task's canonical document, then archived records and old logs.
6. Never start `FROZEN`, `USER_ONLY`, or `WAITING_EXTERNAL` tasks unless their
   explicit restart condition has been satisfied.
7. Codex owns final Registry updates and completion acceptance unless the
   Registry explicitly assigns that responsibility elsewhere.
