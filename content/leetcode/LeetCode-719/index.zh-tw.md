---
title: "LeetCode 719: Find K-th Smallest Pair Distance"
summary: "LeetCode 719 解題筆記：對距離二分，用滑動窗口數「距離 <= mid 的 pair 數」"
description: "2026-09-06 的 LeetCode 719 解題紀錄"
date: 2026-09-06
tags: ["hard", "binary-search", "two-pointers", "sliding-window", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-06
- 提交紀錄：Accepted → Accepted（整理變數名稱）

## 解題思路

Pair 數量是 `n(n-1)/2`，`n = 10^4` 時大約 `5 * 10^7`，全部列出來再排序太慢。

改成**對答案二分**：

- 距離的範圍是 `[0, max - min]`。
- `count(d)` = 距離 `<= d` 的 pair 數，`d` 越大 `count` 越大，是單調的。
- 第一個讓 `count(d) >= k` 的 `d`，就是第 k 小的距離。

`count(d)` 怎麼算：先排序，用滑動窗口。對每個右端 `right`，把左端往右推到 `nums[right] - nums[left] <= d`，這時 `left` 到 `right - 1` 都能和 `right` 配成距離 `<= d` 的 pair，共 `right - left` 對。

## 我的解法

```python
class Solution:
    def smallestDistancePair(self, nums: List[int], k: int) -> int:
        nums.sort()
        n = len(nums)

        def count_within(d: int) -> int:
            count = left = 0
            for right in range(n):
                while nums[right] - nums[left] > d:
                    left += 1
                count += right - left
            return count

        lo, hi = 0, nums[-1] - nums[0]
        while lo < hi:
            mid = (lo + hi) // 2
            if count_within(mid) < k:
                lo = mid + 1
            else:
                hi = mid
        return lo
```

### 為什麼答案一定是真實存在的距離

二分找到的是「第一個讓 `count >= k` 的 `d`」。如果 `d` 不是任何 pair 的距離，那 `count(d) == count(d - 1)`，`d - 1` 也滿足條件，就跟「第一個」矛盾。所以答案一定是某個 pair 的距離。

## 複雜度

時間 `O(n log n + n log W)`，`W` 是最大距離。空間 `O(1)`，不算排序。

## 要特別避免的錯誤

- 列出所有 pair 再排序：`O(n^2 log n)`。
- 用 heap 一個一個彈出第 k 小：`k` 可能到 `5 * 10^7`。
- `count` 的時候每個 `right` 都從頭掃 `left`：要讓 `left` 只往前走。

## 面試口說整理

Pair 太多不能全部列出，所以我對距離二分：距離不超過 `d` 的 pair 數對 `d` 是單調的，第一個讓數量達到 `k` 的 `d` 就是答案。數 pair 時先排序，用滑動窗口：對每個右端把左端推到差距不超過 `d`，中間都能配對，加上 `right - left`。每次數 `O(n)`，總共 `O(n log n + n log W)`。
