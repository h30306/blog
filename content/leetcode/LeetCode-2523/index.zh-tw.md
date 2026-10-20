---
title: "LeetCode 2523: Closest Prime Numbers in Range"
summary: "LeetCode 2523 解題筆記：篩出範圍內的質數，相鄰的兩個質數才可能是最接近的；也可以從 left 往右試除，找到差是 2 的雙生質數就停"
description: "2026-10-12 的 LeetCode 2523 解題紀錄"
date: 2026-10-12
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
第一次嘗試：2026-10-12
- 提交紀錄：Wrong Answer → Accepted ×5（線性篩 → 試除提早結束）

## 解題思路

最接近的兩個質數一定是**相鄰**的兩個質數（中間如果還有質數，跟那個更接近）。

### 篩法

線性篩出 `<= right` 的所有質數，從第一個 `>= left` 的開始，看相鄰兩個的差，取最小的；平手時保留先出現的（`num1` 最小）。

### 試除 + 提早結束

從 `left` 往右逐一試除，記住上一個質數。找到差是 2 的一對就可以直接回傳：除了 `[2, 3]`（差 1）以外不可能更小，而 `[2, 3]` 如果在範圍裡一定最先被找到。實際跑起來很快（5ms），因為差是 2 的雙生質數很常出現。

## 我的嘗試

第一版算相鄰兩個質數的差時，寫成 `prime[i + 1] - prime[i - 1]`，應該是 `prime[i + 1] - prime[i]`。例如 `left = 6`、`right = 43`：答案是 `[11, 13]`，回傳 `[7, 11]`。

修好之後 AC，但線性篩要篩到 `right = 10^6`，跑了 4 秒多；改成試除 + 提早結束降到 5ms。

## 正確解法

```python
class Solution:
    def closestPrimes(self, left: int, right: int) -> List[int]:
        def is_prime(x: int) -> bool:
            if x < 2:
                return False
            if x % 2 == 0:
                return x == 2
            d = 3
            while d * d <= x:
                if x % d == 0:
                    return False
                d += 2
            return True

        prev = -1
        ans = [-1, -1]
        best = float("inf")
        for x in range(left, right + 1):
            if is_prime(x):
                if prev != -1 and x - prev < best:
                    best = x - prev
                    ans = [prev, x]
                    if best <= 2:
                        return ans                 # 不可能更小了
                prev = x
        return ans
```

## 複雜度

最壞 `O((right - left) √right)`，但實際上很快就會遇到雙生質數。篩法版本是 `O(right)`。

## 要特別避免的錯誤

- 相鄰質數的差寫錯 index。
- 平手要保留 `num1` 比較小的，也就是先找到的那一對：用 `<` 不要用 `<=`。

## 面試口說整理

最接近的兩個質數一定相鄰。我可以篩出範圍內的質數再比較相鄰的差；或者從 `left` 往右試除，記住上一個質數，差變成 2 就可以直接回傳，因為只有 `[2, 3]` 會更小，而它一定最早出現。
