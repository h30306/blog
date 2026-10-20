---
title: "LeetCode 3618: Split Array by Prime Indices"
summary: "LeetCode 3618 解題筆記：判斷的是 index 是不是質數；用埃氏篩一次算出 0..n-1 哪些是質數，比每個 index 試除快"
description: "2025-07-19 的 LeetCode 3618 解題紀錄"
date: 2025-07-19
tags: ["medium", "math", "number-theory", "sieve", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

index 是質數的放進 A、其他放進 B，回傳 `|sum(A) - sum(B)|`。

要判斷 `0..n-1` 每個 index 是不是質數，**埃氏篩**一次就能全部算好，`O(n log log n)`。我當時對每個 index 試除到 `√i`，`O(n √n)` 也能過，但慢一些（767ms）。

`0` 和 `1` 都不是質數。

## 我的解法

```python
from math import isqrt

class Solution:
    def splitArray(self, nums: List[int]) -> int:
        n = len(nums)
        is_prime = [False, False] + [True] * max(0, n - 2)
        for i in range(2, isqrt(n) + 1):
            if is_prime[i]:
                for j in range(i * i, n, i):
                    is_prime[j] = False
        diff = 0
        for i, x in enumerate(nums):
            diff += x if is_prime[i] else -x
        return abs(diff)
```

`n` 只有 1 時，`is_prime` 只會用到前 `n` 個位置，前面補的 `[False, False]` 不影響。

## 複雜度

時間 `O(n log log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 判斷的是 index，不是元素的值。
- `0` 和 `1` 不是質數。

## 面試口說整理

我用埃氏篩一次算出所有 index 是不是質數，再掃一次：質數 index 的加、其他的減，最後取絕對值。時間 `O(n log log n)`，比每個 index 試除快。
