---
title: "LeetCode 3660: Jump Game IX"
summary: "LeetCode 3660 解題筆記：在 i 和 i+1 之間切一刀，如果左邊的最大值 > 右邊的最小值，兩邊就能互相跳到，答案一樣；否則左邊的答案就是左邊的最大值"
description: "2026-06-23 的 LeetCode 3660 解題紀錄"
date: 2026-06-23
tags: ["medium", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

可以往右跳到比較小的數、往左跳到比較大的數。

在 `i` 和 `i + 1` 之間切開，看左邊 `[0..i]` 的最大值 `pre_max[i]` 和右邊 `[i+1..]` 的最小值 `suf_min`：

- **`pre_max[i] > suf_min`**：左邊最大的那個可以往右跳到右邊最小的那個，右邊最小的那個可以往左跳回任何比它大的。左右兩邊**連成一塊**，所以 `ans[i] = ans[i + 1]`。
- **`pre_max[i] <= suf_min`**：左邊每個數都 `<=` 右邊每個數，從左邊永遠跳不到右邊（往右只能跳到更小的）。左邊自己內部都能跳到 `pre_max[i]`（往左跳到較大的，或往右跳再往左），所以 `ans[i] = pre_max[i]`。

從右往左算，`ans[n - 1] = pre_max[n - 1]`（整個陣列的最大值）。

## 我的解法

```python
class Solution:
    def maxValue(self, nums: List[int]) -> List[int]:
        n = len(nums)
        pre_max = list(accumulate(nums, max))
        ans = [0] * n
        suf_min = float("inf")
        for i in range(n - 1, -1, -1):
            if pre_max[i] > suf_min:
                ans[i] = ans[i + 1]                # 跟右邊連成一塊
            else:
                ans[i] = pre_max[i]                # 跳不過去，只能拿左邊的最大值
            suf_min = min(suf_min, nums[i])
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用 BFS / DFS 對每個起點搜尋：`O(n^2)`。
- 切點的條件是嚴格的 `>`：相等的數之間不能跳。

## 面試口說整理

我在每個位置切一刀，看左邊的最大值和右邊的最小值。左邊最大大於右邊最小，兩邊就能互相跳到，左邊的答案跟右邊一樣；否則左邊永遠跳不過去，答案就是左邊的最大值。前綴最大值先算好，從右往左維護後綴最小值，時間 `O(n)`。
