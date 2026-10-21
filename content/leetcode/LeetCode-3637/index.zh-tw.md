---
title: "LeetCode 3637: Trionic Array I"
summary: "LeetCode 3637 解題筆記：一個 index 依序走過上坡、下坡、上坡，三段都要非空而且剛好走到最後"
description: "2025-08-03 的 LeetCode 3637 解題紀錄"
date: 2025-08-03
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-08-03
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Wrong Answer ×2 → Accepted；2026-02-03 重寫：Wrong Answer → Accepted

## 解題思路

用一個 index 一段一段往前走（[Array]({{< relref "/algorithm/Array" >}}) 模板一）：先走嚴格上坡到 `p`，再走嚴格下坡到 `q`，再走嚴格上坡。成立的條件是三段都非空（`0 < p < q < n - 1`），而且第三段剛好走到最後一個元素。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 在頭尾加了哨兵，但 index 從 0 開始跟 `nums[-1]`（尾端的哨兵 `inf`）比，第一段直接被判定成空的。`[0, 5, 2, 3]`：答案 `True`，回傳 `False` |
| 兩次 RE | 改成枚舉 `p` 的寫法，貼上時少了 `self`、縮排也錯了 |
| 第四版 | `return False` 縮排在 `for` 迴圈裡面：只試第一個 `p`，而且迴圈用 `continue` 跑完時沒有回傳值，例如 `[0, 1, 3, 2]` 回傳 `None` |
| 第五版 | `return False` 移出來了，但下坡可以一路走到最後一個元素，第三段變成空的還是算成立。`[2, 5, 2, 2]`：答案 `False`，回傳 `True` |
| AC | 改成三層迴圈枚舉 `p`、`q` 再分別檢查三段（`n <= 100`，`O(n³)` 也過） |
| 半年後重寫 | 想一次掃描，但沒檢查最後一定要有第三段上坡。`[2, 5, 0]`：答案 `False`，回傳 `True` |

## 正確解法

```python
class Solution:
    def isTrionic(self, nums: List[int]) -> bool:
        n, i = len(nums), 0
        while i + 1 < n and nums[i] < nums[i + 1]:
            i += 1
        p = i
        while i + 1 < n and nums[i] > nums[i + 1]:
            i += 1
        q = i
        while i + 1 < n and nums[i] < nums[i + 1]:
            i += 1
        return 0 < p < q < n - 1 and i == n - 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 三段都要非空：`p > 0`、`q > p`、`q < n - 1`。
- 要確認第三段一路走到最後。
- `return False` 要放在迴圈外面。

## 面試口說整理

我用一個 index 依序走過上坡、下坡、上坡，最後檢查三段都非空、而且第三段剛好走到陣列結尾。時間 `O(n)`。
