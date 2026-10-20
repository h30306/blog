---
title: "LeetCode 2555: Maximize Win From Two Segments"
summary: "LeetCode 2555 解題筆記：滑動視窗算出以每個獎品結尾的一段能拿幾個；同時記錄「前 i 個獎品裡一段最多拿幾個」，第二段就接在第一段左邊"
description: "2026-01-13 的 LeetCode 2555 解題紀錄"
date: 2026-01-13
tags: ["medium", "sliding-window", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-13
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩段重疊不會比不重疊好，所以可以假設兩段**一左一右、不重疊**。

1. 用滑動視窗：右端是第 `right` 個獎品，左端 `left` 是第一個位置 `>= prizePositions[right] - k` 的獎品，這一段拿 `right - left + 1` 個。
2. 第二段必須完全在 `left` 左邊，也就是只能用前 `left` 個獎品。預先記錄 `best_before[i]` = 只用前 `i` 個獎品時，一段最多拿幾個。
3. 答案是 `max(right - left + 1 + best_before[left])`。

`best_before` 在滑動的過程中順便更新：`best_before[right + 1] = max(best_before[right], 這一段)`。

## 我的解法

```python
class Solution:
    def maximizeWin(self, prizePositions: List[int], k: int) -> int:
        n = len(prizePositions)
        best_before = [0] * (n + 1)                # 只用前 i 個獎品，一段最多拿幾個
        left = ans = 0
        for right, p in enumerate(prizePositions):
            while p - prizePositions[left] > k:
                left += 1
            cur = right - left + 1
            ans = max(ans, cur + best_before[left])     # 第二段在 left 左邊
            best_before[right + 1] = max(best_before[right], cur)
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩段分別取最大值相加：兩段可能重複拿同一批獎品。
- `best_before[left]` 是「前 `left` 個」，不包含 `left` 本身，所以不會跟目前這段重疊。

## 面試口說整理

兩段可以假設一左一右不重疊。我用滑動視窗算以每個獎品結尾的一段能拿幾個，同時用陣列記錄只用前 `i` 個獎品時一段最多拿幾個。目前這段從 `left` 開始，另一段只能在 `left` 左邊，所以答案是這段加上 `best_before[left]` 的最大值。時間 `O(n)`。
