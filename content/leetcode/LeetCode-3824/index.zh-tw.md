---
title: "LeetCode 3824: Minimum K to Reduce Array Within Limit"
summary: "LeetCode 3824 解題筆記：對 k 二分，條件是單調的；上界至少要到 n，因為操作次數至少是 n"
description: "2026-01-31 的 LeetCode 3824 解題紀錄"
date: 2026-01-31
tags: ["medium", "binary-search", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-31
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

每次操作把一個元素減 `k`，讓所有元素都 `<= 0` 需要 `ops(k) = sum(ceil(x / k))` 次。要找最小的 `k`，讓 `ops(k) <= k²`。

**單調性**：`k` 變大時，`ops(k)` 只會變小或不變，`k²` 一定變大。所以只要 `k` 可行，更大的 `k` 也一定可行，可以對 `k` 二分。

**上界**：每個元素至少要一次操作，所以 `ops(k) >= n`，必須 `k² >= n`。另外 `k >= max(nums)` 時，每個元素剛好一次，`ops = n`。所以 `k = max(max(nums), n)` 一定可行，拿來當上界。

## 我的嘗試：上界設太小

```python
left, right = 1, max(nums)
```

例如 `nums = [1, 1, 1, 1, 1]`：`max(nums) = 1`，但 `k = 1` 時要 5 次操作，`5 > 1²`，不可行。答案是 3（`ops = 5 <= 9`），超過了 `max(nums)`。

接下來三次嘗試都在特判「只有一種可能」的情況，例如用 `n ** 0.5` 硬算，但都沒有抓到真正的問題：**上界不夠大**。改成 `right = max(max(nums), n)` 就 AC 了。

## 正確解法

```python
class Solution:
    def minimumK(self, nums: List[int]) -> int:
        def ops(k: int) -> int:
            return sum((x + k - 1) // k for x in nums)

        lo, hi = 1, max(max(nums), len(nums))
        while lo < hi:
            mid = (lo + hi) // 2
            if ops(mid) <= mid * mid:
                hi = mid
            else:
                lo = mid + 1
        return lo
```

`(x + k - 1) // k` 就是 `ceil(x / k)`。

## 複雜度

時間 `O(n log(max(max(nums), n)))`，空間 `O(1)`。

## 要特別避免的錯誤

- 上界只設 `max(nums)`：答案可能比它大。
- 卡住時一直特判，沒有回頭檢查「上界一定可行嗎？」。
- 用浮點數算 `ceil`：直接用整數公式。

## 面試口說整理

`k` 變大時操作次數只會變少，而 `k²` 變大，所以條件對 `k` 是單調的，可以二分。上界要保證可行：每個元素至少一次操作，當 `k` 不小於最大值時剛好 `n` 次，所以取 `max(max(nums), n)`，這時 `n <= k²` 一定成立。`check` 是 `O(n)`，總共 `O(n log)`。
