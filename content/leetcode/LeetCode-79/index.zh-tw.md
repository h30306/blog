---
title: "LeetCode 79: Word Search"
summary: "LeetCode 79 解題筆記：從每一格開始回溯，往四個方向比對下一個字元，走過的格子暫時標記，回溯時還原；先用字元次數剪枝"
description: "2022-10-26 的 LeetCode 79 解題紀錄"
date: 2022-10-26
tags: ["medium", "array", "string", "backtracking", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-26
- 提交紀錄：Wrong Answer ×4 → Time Limit Exceeded → Accepted → Runtime Error ×2 → Wrong Answer → Runtime Error → Time Limit Exceeded ×2 → Accepted → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Accepted → Runtime Error ×2 → Time Limit Exceeded ×2 → Accepted → Runtime Error ×2 → Time Limit Exceeded → Runtime Error → Accepted → Time Limit Exceeded ×3 → Accepted ×2 → Time Limit Exceeded ×3 → Accepted ×3

## 解題思路

網格回溯（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化三）：`dfs(i, j, k)` 檢查 `board[i][j] == word[k]`，對到最後一個字元就成功；否則把這格暫時改成 `#` 防止重複使用，往四個方向找 `k + 1`，回來時**還原**。每一格都要當起點試。

剪枝很重要，不然大的測資會 TLE：

- `word` 的某個字元次數比 board 裡多，直接 `False`。
- 比較 `word` 頭尾字元在 board 裡的次數，從比較少的那一端開始搜尋（把 `word` 反轉），分支會少很多。

## 我的嘗試

這題提交了 42 次，是這次整理裡最多的：

- 2022-10-26 第一版**只從 `(0, 0)` 開始**、四個方向裡 `i + 1` 寫了兩次而沒有 `j + 1`，標記之後也沒還原：`[['c', 'a']]` 找 `'a'` 回傳 `False`。
- 方向和起點修好之後就一直 TLE。2022-10、2022-11 前後試了二十幾次，換了寫法（傳 `word[1:]` 的切片、用 `visited` 集合、加減 index），大部分都卡在 Python 太慢，中間也有幾次 AC。
- 2026-10 重寫，最後一版加上了「字元次數不夠就直接 `False`」的剪枝。

## 正確解法

```python
class Solution:
    def exist(self, board: List[List[str]], word: str) -> bool:
        m, n = len(board), len(board[0])
        have = Counter(c for row in board for c in row)
        need = Counter(word)
        if any(have[c] < k for c, k in need.items()):
            return False
        if have[word[0]] > have[word[-1]]:
            word = word[::-1]
        def dfs(i, j, k):
            if board[i][j] != word[k]:
                return False
            if k == len(word) - 1:
                return True
            board[i][j] = "#"
            found = any(0 <= x < m and 0 <= y < n and dfs(x, y, k + 1)
                        for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)))
            board[i][j] = word[k]
            return found
        return any(dfs(i, j, 0) for i in range(m) for j in range(n))
```

## 複雜度

時間 `O(mn · 3^L)`，空間 `O(L)`（遞迴深度）。

## 要特別避免的錯誤

- 每一格都要當起點，不是只從 `(0, 0)` 開始。
- 四個方向要寫對，不要重複寫同一個方向。
- 標記之後要還原，不然其他起點會被影響。
- 沒有剪枝的 Python 版本很容易 TLE。

## 面試口說整理

我從每一格開始回溯，對到目前的字元就把這格暫時標記，往四個方向找下一個字元，回來時還原。先用字元次數剪枝：board 不夠的字元直接回傳 False，並且從頭尾中比較稀有的那一端開始搜尋。最壞時間 `O(mn · 3^L)`。
