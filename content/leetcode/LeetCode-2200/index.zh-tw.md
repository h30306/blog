---
title: "LeetCode 2200: Find All K-Distant Indices in an Array"
summary: "LeetCode 2200 解題筆記：每個 key 往左右各延伸 k 格，用一個指針記住已經輸出到哪裡，避免重疊的區間重複輸出"
description: "2026-01-04 的 LeetCode 2200 解題紀錄"
date: 2026-01-04
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-04
- 提交紀錄：Accepted（暴力）→ Wrong Answer → Accepted ×2

## 解題思路

每個 `nums[j] == key` 的位置，會讓 `[j - k, j + k]` 裡的 index 都成為答案。把這些區間聯集起來、依序輸出。

依序掃過每個 key 的位置，**區間的起點只會越來越右**，所以用一個指針 `next_start` 記住「已經輸出到哪裡」：下一個區間從 `max(next_start, j - k)` 開始輸出，就不會重複。

## 我的嘗試

### 第一版：暴力

對每個 index 檢查所有 key 的位置，有一個距離 `<= k` 就加入。正確，時間 `O(n · key 的數量)`。

### 第二版：區間重疊時重複輸出

改成對每個 key 輸出 `[j - k, j + k]`，但沒有處理區間重疊。例如 `nums = [2, 3, 2, 1, 1, 2, 1, 2]`、`key = 2`、`k = 3`：每個 key 的區間都互相重疊，同一個 index 被輸出好幾次，答案變成 `[0, 1, 2, 3, 0, 1, 2, 3, 4, 5, ...]`。

加上一個記錄上一個區間結尾的指針就 AC 了。

## 正確解法

```python
class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        n = len(nums)
        res = []
        next_start = 0                         # 下一個還沒輸出的 index
        for j, x in enumerate(nums):
            if x == key:
                start = max(next_start, j - k)
                end = min(n - 1, j + k)
                res.extend(range(start, end + 1))
                next_start = end + 1
        return res
```

## 複雜度

時間 `O(n)`：每個 index 最多被輸出一次。空間 `O(1)`，不算輸出。

## 要特別避免的錯誤

- 區間重疊時重複輸出。
- 區間沒有限制在 `[0, n - 1]`。

## 面試口說整理

每個等於 `key` 的位置 `j` 會讓 `[j - k, j + k]` 都成為答案。我依序掃過 key 的位置，用一個指針記住已經輸出到哪裡，下一個區間從 `max(指針, j - k)` 開始，這樣重疊的部分不會重複輸出，每個 index 最多輸出一次，時間 `O(n)`。
