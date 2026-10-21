---
title: "LeetCode 4081: Prime Subset Selection II"
summary: "LeetCode 4081 解題筆記：篩出質數後做 0/1 背包，dp[j] 是湊出 j 的最少個數；質數由大到小放，個數一樣時新的組合開頭比較小，所以用 <= 更新就是字典序最小"
description: "2026-10-13 的 LeetCode 4081 解題紀錄"
date: 2026-10-13
tags: ["hard", "knapsack-dp", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-13
- 提交紀錄：Accepted → Wrong Answer ×2 → Accepted ×9（後面幾次是在練不同的寫法）

## 解題思路

1. **篩質數**：`n <= 1000`，用 [Number Theory]({{< relref "/algorithm/Number-Theory" >}}) 的篩法找出所有 `<= n` 的質數。
2. **0/1 背包**（[Knapsack DP]({{< relref "/algorithm/Knapsack-DP" >}})）：`dp[j]` 是剛好湊出 `j` 的最少質數個數，`best[j]` 是對應的組合。每個質數只能用一次，所以 `j` 由大到小更新。
3. **三層比較**：先要總和最大（從 `min(s, 質數總和)` 往下找第一個湊得出來的），再要個數最少（`dp` 本身），最後要字典序最小。
4. **字典序的處理**：質數**由大到小**放進背包。個數一樣時，新的組合是 `[p] + best[j - p]`，`p` 比之前放過的質數都小，所以新的組合開頭比較小、字典序一定比較小。因此用 `<=` 更新就同時處理了平手。

## 我的嘗試

第一次用「總和 -> 組合」的字典做，直接 AC。之後想改成陣列版的背包練習，前兩次 WA 是因為**線性篩的內層迴圈縮排進了 `if 是質數` 裡面**，合數不會去劃掉它的倍數。例如 `n = 9`、`s = 49`：8 沒被劃掉，回傳 `[2, 3, 5, 7, 8]`，答案是 `[2, 3, 5, 7]`。把內層迴圈移出來就 AC 了。

最後一版另外加了 `dp[j - p] != inf` 的檢查：`inf + 1 <= inf` 在 Python 是 `True`，不檢查的話湊不出來的狀態也會被寫進一個假的組合，只是之後沒有被用到。

## 正確解法

```python
class Solution:
    def maxPrimeSubset(self, n: int, s: int) -> List[int]:
        primes, composite = [], [False] * (n + 1)
        for i in range(2, n + 1):                  # 線性篩：外層跑所有 i
            if not composite[i]:
                primes.append(i)
            for p in primes:
                if i * p > n:
                    break
                composite[i * p] = True
                if i % p == 0:
                    break
        cap = min(s, sum(primes))
        dp = [inf] * (cap + 1)
        dp[0] = 0
        best = [[] for _ in range(cap + 1)]
        for p in reversed(primes):                 # 由大到小：平手時新組合的開頭比較小
            for j in range(cap, p - 1, -1):
                if dp[j - p] != inf and dp[j - p] + 1 <= dp[j]:
                    dp[j] = dp[j - p] + 1
                    best[j] = [p] + best[j - p]
        for j in range(cap, 0, -1):
            if dp[j] != inf:
                return best[j]
        return []
```

## 複雜度

篩法 `O(n)`；背包有 `π(n)` 個質數（`n = 1000` 時是 168 個）、容量 `s`，每次更新複製組合，最壞 `O(π(n) · s · π(n))`；在這個範圍很快。空間 `O(s · π(n))`。

## 要特別避免的錯誤

- 線性篩的內層迴圈要對**所有** `i` 跑，不只質數。
- `inf + 1 <= inf` 是 `True`，湊不出來的狀態要先排除。
- 字典序的平手要想清楚放入順序；由大到小放，`<=` 才會選到字典序最小的。

## 面試口說整理

我先用線性篩找出質數，再做 0/1 背包，`dp[j]` 是湊出 `j` 的最少個數並記住組合。答案取湊得出來的最大總和。為了字典序最小，質數由大到小放，個數相同時新的組合以更小的質數開頭，所以用 `<=` 更新就對了。
