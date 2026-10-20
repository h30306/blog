---
title: "LeetCode 2461: Maximum Sum of Distinct Subarrays With Length K"
summary: "LeetCode 2461 解題筆記：固定長度 k 的視窗，不同值的個數剛好等於 k 才代表全部不重複"
description: "2025-12-24 的 LeetCode 2461 解題紀錄"
date: 2025-12-24
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-24
- 提交紀錄：Accepted ×2

## 解題思路

跟 [LeetCode 2841]({{< relref "/leetcode/LeetCode-2841" >}}) 同一個模板：固定長度 `k` 的視窗，維護總和與計數雜湊表。**不同值的個數等於 `k`**，代表視窗裡沒有重複。

另一種寫法（我兩次 AC 用的）是可變視窗：遇到重複的值，或視窗超過 `k`，就縮左邊；視窗長度剛好 `k` 時更新答案。

## 我的解法

```python
class Solution:
    def maximumSubarraySum(self, nums: List[int], k: int) -> int:
        cnt = Counter()
        window = best = 0
        for right, x in enumerate(nums):
            cnt[x] += 1
            window += x
            if right >= k:
                out = nums[right - k]
                cnt[out] -= 1
                window -= out
                if cnt[out] == 0:
                    del cnt[out]
            if right >= k - 1 and len(cnt) == k:   # k 個值全部不同
                best = max(best, window)
        return best
```

我的第二次 AC 用 `set` 搭配可變視窗（這裡稍微整理過順序）：

```python
class Solution:
    def maximumSubarraySum(self, nums: List[int], k: int) -> int:
        seen = set()
        left = window = best = 0
        for right, x in enumerate(nums):
            while x in seen or right - left >= k:
                seen.remove(nums[left])
                window -= nums[left]
                left += 1
            seen.add(x)
            window += x
            if right - left + 1 == k:
                best = max(best, window)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(k)`。

## 要特別避免的錯誤

- 固定視窗時用 `len(cnt) >= k`：長度 `k` 的視窗最多只有 `k` 種，要剛好等於 `k`。
- 可變視窗時，要先縮完再把新元素加進 `set`。

## 面試口說整理

這是固定長度 `k` 的滑動視窗，維護總和和計數雜湊表，數量歸零就刪 key。雜湊表大小剛好等於 `k` 代表視窗裡全部不同，這時更新最大總和。也可以用 `set` 加可變視窗：遇到重複或超過 `k` 就縮左邊。時間 `O(n)`。
