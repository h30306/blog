---
title: "LeetCode 665: Non-decreasing Array"
summary: "LeetCode 665 解題筆記：遇到下降時決定改哪一個：能把 nums[i-1] 降下來就降，不行（nums[i] < nums[i-2]）才把 nums[i] 拉高；第二次下降就失敗"
description: "2025-07-22 的 LeetCode 665 解題紀錄"
date: 2025-07-22
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-22
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×2 → Accepted

## 解題思路

掃描時遇到 `nums[i] < nums[i - 1]`，最多只能修一次（[Array]({{< relref "/algorithm/Array" >}}) 模板二）。改哪一個？

- 優先把 `nums[i - 1]` 降成 `nums[i]`：這樣 `nums[i]` 不變，對後面最有利。但前提是 `nums[i - 2] <= nums[i]`，不然 `i - 2` 和 `i - 1` 之間又會下降。
- 如果 `nums[i] < nums[i - 2]`，只能把 `nums[i]` 拉高成 `nums[i - 1]`，之後繼續檢查。

第二次遇到下降就回傳 `False`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 只數下降了幾次。`[3, 4, 1, 2]` 只有一次下降，但 4 改成 1 以下會比 3 小、1 改成 4 以上會比 2 大，答案 `False`，這版回傳 `True` |
| 第二版 | 加了「改不好」的檢查，但條件寫成 `i > 1`，漏掉 `i == 1`，`[3, 4, 1, 2]` 還是 `True`；另外 `nums[i + 2]` 會超出範圍，例如 `[0, 2, 4, 0]` |
| 兩次 RE | 改成 `i >= 1`，但邊界還是 `i < len(nums) - 1`，`[3, 4, 0]` 時 `nums[i + 2]` 超出範圍 |
| AC | 邊界改成 `i < len(nums) - 2` |

我的 AC 版本是在下降點同時看前後兩邊；這裡整理成「決定改哪一個」的寫法，比較好說明。

## 正確解法

```python
class Solution:
    def checkPossibility(self, nums: List[int]) -> bool:
        changed = False
        for i in range(1, len(nums)):
            if nums[i] < nums[i - 1]:
                if changed:
                    return False
                changed = True
                if i >= 2 and nums[i] < nums[i - 2]:
                    nums[i] = nums[i - 1]          # 只能把 nums[i] 拉高
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只數下降次數不夠，還要看修得修不好。
- 往後看 `i + 2` 之前要確定沒超出範圍。

## 面試口說整理

我掃描陣列，遇到下降時只有一次修改的機會：能把前一個降下來就降，如果這樣會跟再前一個衝突，就把目前這個拉高。第二次遇到下降就回傳 `False`。時間 `O(n)`。
