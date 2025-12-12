---
description: Complete workflow to close a GitHub issue - create branch, commit changes, push, create PR, and merge.
---

# Ship Issue Workflow

Given GitHub issue number as an argument, perform the complete workflow to close the issue:

## Steps

1. **Fetch Issue Details**
   - Use `gh issue view {issue_number}` to get the issue title and description
   - Parse the issue details to understand what needs to be done

2. **Create Feature Branch**
   - Generate a branch name: `issue-{number}-{kebab-case-title}` (keep it concise)
   - Example: issue-42-fix-login-bug
   - Create and switch to the branch: `git checkout -b {branch_name}`

3. **Review Pending Changes**
   - Run `git status` to see modified files
   - Run `git diff` to review all changes
   - Verify these changes are related to resolving the issue

4. **Commit Changes**
   - Stage all relevant changes
   - Create a commit message that:
     - Has a clear, concise first line summarizing the changes
     - References the issue in the body or footer
     - NEVER includes the standard footer:
       ```
       🤖 Generated with [Claude Code](https://claude.com/claude-code)

       Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
       ```
   - Follow the repository's commit message style (check recent commits with `git log`)
   - Use the heredoc pattern for the commit message

5. **Push Branch**
   - Push the branch to remote: `git push -u origin {branch_name}`

6. **Create Pull Request**
   - Use `gh pr create` with:
     - Title that references the issue: "Fix: {issue title} (#{issue_number})"
     - Body that includes:
       - Summary of changes
       - "Fixes #{issue_number}" or "Closes #{issue_number}" to auto-close the issue
       - Test plan if applicable
       - NEVER includes the standard footer:
         ```
         🤖 Generated with [Claude Code](https://claude.com/claude-code)
         ```
   - Use heredoc for the PR body

7. **Merge Pull Request**
   - Verify the PR was created successfully
   - Merge the PR using `gh pr merge {pr_number} --squash` or `--merge` (check repo settings for preferred strategy)
   - Confirm the issue is automatically closed

8. **Clean Up**
   - Get the default branch name: `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`
   - Switch back to the default branch: `git checkout {default_branch}`
   - Pull the latest changes including the merge: `git pull`
   - Verify the changes are present with `git log -1` or `git show HEAD`
   - Delete the local feature branch: `git branch -d {branch_name}`
   - Delete the remote feature branch: `git push origin --delete {branch_name}`

## Error Handling

- If there are no pending changes, inform the user
- If the issue doesn't exist, report the error
- If the branch already exists, ask user how to proceed
- If PR creation fails, provide the error details
- Do not proceed with merge if there are conflicts or failing checks
- If branch deletion fails (e.g., branch not fully merged), report the error and ask user how to proceed
- If pulling changes fails due to conflicts, report the error

## Important Notes

- NEVER use git flags like --no-verify or --no-gpg-sign
- Follow all git safety protocols from the project guidelines
- Ensure commit messages follow the repository's style
- Verify the main branch name (main vs master) before merging
