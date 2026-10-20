---
title: "LeetCode 1793: Maximum Score of a Good Subarray"
summary: "LeetCode 1793 解題筆記：從 k 往兩邊擴張，每次往鄰居比較大的那一邊走，讓每個長度的最小值盡量大；到邊界時只能往另一邊"
description: "2026-01-29 的 LeetCode 1793 解題紀錄"
date: 2026-01-29
tags: ["hard", "two-pointers", "greedy", "binary-search", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-29
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

好的子陣列一定包含 `k`，所以從 `[k, k]` 開始，每次往左或往右擴一格，長度從 1 長到 `n`。

**往鄰居比較大的那一邊擴**：分數是「最小值 × 長度」，同樣的長度下，最小值越大越好。往大的那邊走，最小值降得最少。每擴一格就用目前的最小值 × 長度更新答案。

到邊界時只能往另一邊走，直到兩邊都到底。

這個貪心也可以用單調棧的角度理解：對每個 `nums[i]` 當最小值，找它左右能延伸的最遠範圍，範圍包含 `k` 才算數，跟 [LeetCode 84]({{< relref "/leetcode/LeetCode-84" >}}) 的直方圖最大矩形同一類。

## 我的嘗試

我的寫法是計算「往左擴」和「往右擴」之後的分數，往分數高的那邊走。三次 WA 都是邊界和更新的問題：

| 版本 | 問題 |
|---|---|
| 第一版 | 往左擴的長度少算 1，沒有更新目前的最小值，右邊已經到底還會往右走。例如 `nums = [1, 1]`、`k = 1`：答案是 2，回傳 1 |
| 第二版 | 往右擴時，答案卻用往左擴的分數更新。例如 `nums = [1, 1]`、`k = 0`：答案是 2，回傳 1 |
| 第三版 | 迴圈條件是 `start >= 0 and end <= n - 1`，到邊界的那一邊分數設成目前答案；平手時走到不能走的那一邊，`start` 變成 -1，迴圈提早結束，另一邊沒擴完。例如 `nums = [2, 1, 1]`、`k = 0`：整段 `1 × 3 = 3` 是答案，回傳 2 |

最後改成 `while start > 0 or end < n - 1`，並且到邊界時強制往另一邊走，就 AC 了。

## 正確解法

```python
class Solution:
    def maximumScore(self, nums: List[int], k: int) -> int:
        n = len(nums)
        i = j = k
        cur_min = best = nums[k]
        while i > 0 or j < n - 1:
            if i == 0 or (j < n - 1 and nums[j + 1] > nums[i - 1]):
                j += 1                             # 往右（左邊到底，或右鄰居比較大）
                cur_min = min(cur_min, nums[j])
            else:
                i -= 1                             # 往左
                cur_min = min(cur_min, nums[i])
            best = max(best, cur_min * (j - i + 1))
        return best
```

這裡直接比較兩個鄰居的值，比原本比較「擴張後的分數」簡單，效果一樣。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 擴張後忘了更新最小值。
- 到邊界時還往那一邊走，或迴圈提早結束、另一邊沒擴完。
- 長度是 `j - i + 1`。

## 面試口說整理

好的子陣列一定包含 `k`，所以我從 `k` 開始往兩邊擴，每次往鄰居比較大的那一邊走，因為同樣長度下最小值越大分數越高，往大的那邊最小值降得最少。每擴一格用目前最小值乘長度更新答案，一邊到底就只往另一邊。時間 `O(n)`。也可以用單調棧找每個元素當最小值的範圍，只算包含 `k` 的。
