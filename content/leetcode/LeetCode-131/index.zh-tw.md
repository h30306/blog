---
title: "LeetCode 131: Palindrome Partitioning"
summary: "LeetCode 131 解題筆記：每一層從剩下字串的開頭切出一段回文，切的長度從 1 到整段都要試"
description: "2022-10-30 的 LeetCode 131 解題紀錄"
date: 2022-10-30
tags: ["medium", "string", "dynamic-programming", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-30
- 提交紀錄：Wrong Answer ×3 → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted

## 解題思路

切割型回溯（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化五）：`dfs(start, path)` 嘗試把 `s[start:end]` 當成下一段，`end` 從 `start + 1` 到 **`len(s)`**（包含整段剩下的字串），是回文才往下切。`start == len(s)` 時記錄。可以先用 DP 算好 `isPal[i][j]`，避免重複判斷。

## 我的嘗試

這題提交了 12 次，核心的錯誤只有一個：

- 切的長度寫成 `range(1, len(s))`，**剩下的整段字串從來沒被當成一段**，所以最後一段永遠切不完：`"b"` 回傳 `[]`，`"bab"` 少了 `["bab"]`。第一版另外還切成 `s[i + 1:]`（跳過了一個字元）而且沒有呼叫 `dfs`。
- 2022-10、2022-11 兩次重寫都錯在同一個地方，最後改成 `range(1, len(s) + 1)` 才 AC。

## 正確解法

```python
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        res, path = [], []
        def dfs(start):
            if start == len(s):
                res.append(path[:])
                return
            for end in range(start + 1, len(s) + 1):
                piece = s[start:end]
                if piece == piece[::-1]:
                    path.append(piece)
                    dfs(end)
                    path.pop()
        dfs(0)
        return res
```

## 複雜度

時間 `O(n · 2^n)`，空間 `O(n)`（不算輸出）。

## 要特別避免的錯誤

- 切的長度要包含整段剩下的字串：`range(1, len(s) + 1)`。
- 切完之後從 `s[i:]` 繼續，不是 `s[i + 1:]`。

## 面試口說整理

我用切割型的回溯，每一層從剩下字串的開頭切出一段，長度從 1 試到整段，是回文才往下切，切到最後就記錄。可以先用 DP 算好哪些區間是回文。
