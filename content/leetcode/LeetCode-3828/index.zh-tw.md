---
title: "LeetCode 3828: Final Element After Subarray Deletions"
summary: "LeetCode 3828 解題筆記：Alice 第一步就能只留下頭或尾，所以至少拿到 max(頭, 尾)；Bob 每次也能只留下目前的頭或尾，而 Alice 的一次刪除最多改變其中一端，所以答案就是 max(頭, 尾)"
description: "2026-02-01 的 LeetCode 3828 解題紀錄"
date: 2026-02-01
tags: ["medium", "math", "brainteaser", "game-theory", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

每一步可以刪掉長度 `< m` 的任何子陣列（`m` 是目前的長度），所以**可以一次刪到只剩一個，只要剩下的是頭或尾**（刪掉長度 `m - 1` 的子陣列）。

- **下界**：Alice 第一步直接刪到只剩 `nums[0]` 或 `nums[-1]`，選大的，遊戲結束。答案至少是 `max(頭, 尾)`。
- **上界**：如果 Alice 第一步沒有結束遊戲，她刪掉的是一段連續的子陣列，不可能同時刪掉頭和尾，所以新陣列至少有一端還是原本的頭或尾。Bob 接著刪到只剩新陣列的頭或尾中比較小的那個，結果 `<=` 那個原本的端點 `<= max(頭, 尾)`。

所以答案剛好是 `max(nums[0], nums[-1])`。

## 我的解法

```python
class Solution:
    def finalElement(self, nums: List[int]) -> int:
        return max(nums[0], nums[-1])
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 以為要模擬整個遊戲：觀察出「一步就能留下頭或尾」之後就是常數時間。

## 面試口說整理

每一步都可以刪到只剩頭或尾。Alice 第一步就這麼做，至少拿到頭尾比較大的那個；如果她不這麼做，她只刪了一段，新陣列至少保留一個原本的端點，Bob 就刪到只剩新的頭尾裡比較小的，不會超過原本頭尾的最大值。所以答案是 `max(頭, 尾)`。
