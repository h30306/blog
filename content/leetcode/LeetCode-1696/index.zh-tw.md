---
title: "LeetCode 1696: Jump Game VI"
summary: "LeetCode 1696 解題筆記：dp[i] = nums[i] + 前 k 個 dp 的最大值；前 k 個的最大值用單調佇列維護，O(n)"
description: "2025-08-10 的 LeetCode 1696 解題紀錄"
date: 2025-08-10
tags: ["medium", "dynamic-programming", "monotonic-queue", "queue", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-10
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Accepted

## 解題思路

`dp[i]` = 從 index 0 走到 `i` 的最大分數。前一步只能是 `i - k` 到 `i - 1` 之間：

```text
dp[i] = nums[i] + max(dp[i - k], ..., dp[i - 1])
```

直接算是 `O(nk)`，`n`、`k` 都到 `10^5` 會超時。前 `k` 個的最大值是滑動視窗最大值，用單調佇列維護：

1. 頭端的 index `< i - k` 丟掉（過期）。
2. `dp[i] = nums[i] + dp[頭端]`。
3. 尾端 `dp` 值 `<= dp[i]` 的丟掉（被支配），放入 `i`。

## 我的嘗試

1. **第一版 WA**：用 `dp[i + 1]` 表示走到 `i`、`dp[0] = 0`，但轉移範圍讓前 `k` 格都能從 `dp[0]` 直接跳過來，等於**可以不從 index 0 出發**。例如 `nums = [-1, 5]`、`k = 2`：一定要經過 `-1`，答案是 4，這版回傳 5。
2. **第二版 TLE**：改成 `dp[0] = nums[0]`，邏輯對了，但雙層迴圈 `O(nk)`。
3. **AC**：換成單調佇列。

## 正確解法

```python
from collections import deque

class Solution:
    def maxResult(self, nums: List[int], k: int) -> int:
        n = len(nums)
        dp = [0] * n
        dp[0] = nums[0]                            # 一定從 index 0 出發
        dq = deque([0])                            # index，dp 值遞減
        for i in range(1, n):
            if dq[0] < i - k:
                dq.popleft()                       # 過期
            dp[i] = nums[i] + dp[dq[0]]
            while dq and dp[dq[-1]] <= dp[i]:
                dq.pop()                           # 被 dp[i] 支配
            dq.append(i)
        return dp[-1]
```

我 AC 的版本是在算完 `dp[i]` 之後才檢查過期（`dq[0] <= i - k`），等於提前一步把下一輪會過期的丟掉，結果一樣；先檢查再取值比較直覺。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 起點一定是 index 0：`dp[0] = nums[0]`，不是 0。
- `O(nk)` 的雙層迴圈會超時。

## 面試口說整理

`dp[i]` 是走到 `i` 的最大分數，等於 `nums[i]` 加上前 `k` 個 `dp` 的最大值。前 `k` 個的最大值是滑動視窗最大值，我用單調佇列維護：頭端丟過期的、尾端丟被新值支配的，頭端就是最大值。每個 index 進出一次，時間 `O(n)`。
