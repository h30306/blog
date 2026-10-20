---
title: "LeetCode 996: Number of Squareful Arrays"
summary: "LeetCode 996 解題筆記：n 最多 12，用 bitmask DP：dp[mask][last] = 用了 mask 這些數、最後一個是 last 的排列數；相同的數規定依 index 順序使用來去重"
description: "2026-09-09 的 LeetCode 996 解題紀錄"
date: 2026-09-09
tags: ["hard", "dynamic-programming", "bitmask", "backtracking", "math", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-09
- 提交紀錄：Runtime Error → Accepted

## 解題思路

`n <= 12`，可以用 bitmask 記錄哪些數字用過了。`dp[mask][last]` = 用了 `mask` 這些位置、最後一個放的是 `nums[last]` 的合法排列數：

- 下一個數 `nxt` 還沒用過，而且 `nums[last] + nums[nxt]` 是平方數，就轉移到 `dp[mask | 1 << nxt][nxt]`。
- 答案是 `sum(dp[全部][last])`。

**去重**：相同的數字交換位置算同一個排列。先排序，規定相同的數字要**依 index 順序使用**：`nums[nxt] == nums[nxt - 1]` 時，`nxt - 1` 必須已經用過，`nxt` 才能用。這樣每個排列只會出現一次。

## 我的嘗試

我寫的是回溯 + 剪枝（排序後跳過「前一個相同的數字還沒用」的情況），想法跟上面的去重一樣。第一版 RE：條件裡把 `==` 寫成 `=`，是語法錯誤；同一版還有 `visited[num]`、`res += 1` 沒有宣告 `nonlocal`、遞迴傳 `i + 1` 而不是 `length + 1` 這些問題，第二版一起修好就 AC 了（2.4 秒）。

## 正確解法

```python
from math import isqrt

class Solution:
    def numSquarefulPerms(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        is_sq = lambda x: isqrt(x) ** 2 == x
        ok = [[is_sq(nums[i] + nums[j]) for j in range(n)] for i in range(n)]

        dp = [[0] * n for _ in range(1 << n)]      # dp[mask][last]
        for i in range(n):
            if i == 0 or nums[i] != nums[i - 1]:   # 相同的數只從第一個開始
                dp[1 << i][i] = 1
        for mask in range(1 << n):
            for last in range(n):
                if not dp[mask][last]:
                    continue
                for nxt in range(n):
                    if mask >> nxt & 1 or not ok[last][nxt]:
                        continue
                    if nxt > 0 and nums[nxt] == nums[nxt - 1] and not mask >> (nxt - 1) & 1:
                        continue                   # 相同的數要依 index 順序用
                    dp[mask | 1 << nxt][nxt] += dp[mask][last]
        return sum(dp[(1 << n) - 1])
```

回溯版本：

```python
from math import isqrt

class Solution:
    def numSquarefulPerms(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        used = [False] * n

        def backtrack(length: int, prev: int) -> int:
            if length == n:
                return 1
            count = 0
            for i in range(n):
                if used[i]:
                    continue
                if i > 0 and nums[i] == nums[i - 1] and not used[i - 1]:
                    continue                       # 去重
                if length == 0 or isqrt(prev + nums[i]) ** 2 == prev + nums[i]:
                    used[i] = True
                    count += backtrack(length + 1, nums[i])
                    used[i] = False
            return count

        return backtrack(0, -1)
```

我 AC 的寫法是 `visited[i - 1]`（前一個相同的已經用過就跳過），這裡用 `not used[i - 1]`。兩種都能去重，只是固定的使用順序相反。

## 複雜度

bitmask DP：時間 `O(2^n · n^2)`，空間 `O(2^n · n)`。回溯最壞也是指數級，但平方數的限制會剪掉很多。

## 要特別避免的錯誤

- 沒有去重：相同的數字交換會被算成不同的排列。
- 判斷平方數用 `math.isqrt`，不要用浮點數開根號。

## 面試口說整理

`n` 最多 12，我用 bitmask DP，`dp[mask][last]` 是用了 `mask` 這些數、最後一個是 `last` 的排列數，下一個數跟 `last` 加起來是平方數就能接。重複的數字規定依 index 順序使用，每個排列只算一次。時間 `O(2^n · n^2)`。也可以用回溯加同樣的去重。
