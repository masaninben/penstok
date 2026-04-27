#!/bin/bash
# worktree の変更を main ブランチへ自動マージするスクリプト

WORKTREE="/Users/nakamuramasahiro/Desktop/penstok/.claude/worktrees/distracted-agnesi"
MAIN="/Users/nakamuramasahiro/Desktop/penstok"

# worktree が存在しない場合はスキップ
if [ ! -d "$WORKTREE" ]; then exit 0; fi

cd "$WORKTREE" || exit 0

# worktree ブランチ名を取得
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then exit 0; fi

# 未コミットの変更があればコミット
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  git add -A
  git commit -m "chore: auto-sync from worktree" --quiet 2>/dev/null || true
fi

# main ブランチへマージ
cd "$MAIN" || exit 0
git merge "$BRANCH" --no-edit -X theirs --quiet 2>/dev/null || true
