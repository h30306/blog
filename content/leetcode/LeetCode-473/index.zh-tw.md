---
title: "LeetCode 473: Matchsticks to Square"
summary: "LeetCode 473 解題筆記：總和要能被 4 整除；由大到小把每根火柴放進四個邊之一，超過邊長或跟前一個邊長度相同就跳過"
description: "2022-11-16 的 LeetCode 473 解題紀錄"
date: 2022-11-16
tags: ["medium", "array", "dynamic-programming", "backtracking", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Time Limit Exceeded → Accepted ×2 → Runtime Error ×3 → Time Limit Exceeded → Accepted ×2

## 解題思路

放置型回溯（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板）：每根火柴要放進四個邊之一，邊長是 `total / 4`。剪枝很重要：

- 總和不能被 4 整除，或最長的火柴超過邊長，直接 `False`。
- **由大到小排序**：大的先放，越早發現放不下。
- 放進某個邊會超過邊長就跳過。
- 如果這個邊的目前長度跟前面某個已經試過的邊一樣，結果也會一樣，跳過。

## 我的嘗試

這題提交了 9 次：

- 第一版是對的四邊回溯，但沒有記憶化也沒有剪掉相同的邊，TLE。
- 加上 `@cache` 的版本先是變數名稱打錯（`value`、`e5`，NameError）。修好之後**四個分支用 `+` 加起來**，每條分支都要走完才能相加，又 TLE；剛好有一次沒超時就 AC 了（回傳的是整數，非 0 就被當成 `True`）。
- 2022-11-27 重寫時改成 `or` 而且由大到小排序，才穩定通過。

## 正確解法

```python
class Solution:
    def makesquare(self, matchsticks: List[int]) -> bool:
        total = sum(matchsticks)
        if total % 4:
            return False
        side = total // 4
        matchsticks.sort(reverse=True)
        if matchsticks[0] > side:
            return False
        sides = [0] * 4
        def dfs(i):
            if i == len(matchsticks):
                return True
            tried = set()
            for k in range(4):
                if sides[k] + matchsticks[i] > side or sides[k] in tried:
                    continue
                tried.add(sides[k])
                sides[k] += matchsticks[i]
                if dfs(i + 1):
                    return True
                sides[k] -= matchsticks[i]
            return False
        return dfs(0)
```

## 複雜度

時間最壞 `O(4^n)`，靠剪枝通過；空間 `O(n)`。

## 要特別避免的錯誤

- 四個邊的結果要用 `or` 合併並且提早回傳，用 `+` 會把每條分支都走完。
- 由大到小排序，小的先放會在很深的地方才發現失敗。
- 長度相同的邊只需要試一次。

## 面試口說整理

總和要能被 4 整除，邊長是總和的四分之一。我把火柴由大到小排序，回溯時把每根放進四個邊之一，會超過邊長就跳過，目前長度跟試過的邊一樣也跳過，因為結果相同。最壞指數時間，但剪枝之後很快。
