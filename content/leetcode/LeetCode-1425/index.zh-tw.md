---
title: "LeetCode 1425: Constrained Subsequence Sum"
summary: "LeetCode 1425 解題筆記：dp[i] = nums[i] + max(0, 前 k 個 dp 的最大值)；前 k 個 dp 的最大值是滑動視窗最大值，用單調佇列 O(1) 取得"
description: "2026-09-10 的 LeetCode 1425 解題紀錄"
date: 2026-09-10
tags: ["hard", "sliding-window", "dynamic-programming", "monotonic-queue", "heap", "queue", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-10
- 提交紀錄：Time Limit Exceeded → Accepted ×2

## 解題思路

`dp[i]` = 以 `nums[i]` 結尾的子序列最大和。前一個元素必須在 `[i - k, i - 1]` 裡，或者 `nums[i]` 自己開頭：

```text
dp[i] = nums[i] + max(0, max(dp[i-k], ..., dp[i-1]))
```

直接算是 `O(nk)`。`max(dp[i-k..i-1])` 就是一個**長度 `k` 的滑動視窗最大值**，用單調佇列（存 index，`dp` 值遞減）：

1. 頭端的 index `< i - k` 就丟掉（過期）。
2. 頭端就是視窗最大值，`> 0` 才接上去。
3. 尾端 `dp` 值 `<=` `dp[i]` 的都丟掉（被支配），再放入 `i`。

答案是 `max(dp)`（子序列不能是空的）。

## 我的嘗試

第一版想用貪心一段一段往前跳，每段挑一個數接過去。迴圈最後寫成 `i = j`，但 `j` 是這一段的最後一個位置，走到最後一段（或 `k = 1`）時 `j == i`，`i` 不會前進，迴圈停不下來，TLE。之後改成上面的 DP + 單調佇列 AC。

## 正確解法

```python
from collections import deque

class Solution:
    def constrainedSubsetSum(self, nums: List[int], k: int) -> int:
        dp = nums[:]
        dq = deque()                               # index，dp 值遞減
        for i in range(len(nums)):
            if dq and dq[0] < i - k:
                dq.popleft()                       # 過期
            if dq and dp[dq[0]] > 0:
                dp[i] += dp[dq[0]]                 # 接在最好的前一個後面
            while dq and dp[dq[-1]] <= dp[i]:
                dq.pop()                           # 被 dp[i] 支配
            dq.append(i)
        return max(dp)
```

我原本直接寫 `dp = nums`，會改到輸入陣列；這裡用 `nums[:]` 複製一份。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `O(nk)` 直接取前 `k` 個的最大值：`n`、`k` 都到 `10^5`。
- 前一個的最大值是負的時候，不要接上去，自己開頭比較好。
- 答案是 `max(dp)`，不是 `dp[-1]`。

## 面試口說整理

`dp[i]` 是以 `nums[i]` 結尾的最大和，等於 `nums[i]` 加上前 `k` 個 `dp` 的最大值，如果那個最大值是負的就不接。前 `k` 個的最大值是滑動視窗最大值，我用單調佇列維護：頭端丟過期的、尾端丟被新值支配的，頭端就是最大值。每個 index 進出一次，時間 `O(n)`。
