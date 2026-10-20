---
title: "LeetCode 2709: Greatest Common Divisor Traversal"
summary: "LeetCode 2709 解題筆記：任兩個 index 都能互通 ⇔ 全部在同一個連通塊；用 SPF 分解質因數，數字跟它的質因數在 Union-Find 裡合併；1 要特別處理"
description: "2025-08-07 的 LeetCode 2709 解題紀錄"
date: 2025-08-07
tags: ["hard", "math", "number-theory", "union-find", "sieve", "gcd", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2025-08-07
- 提交紀錄：TLE → RE → WA ×2 → TLE ×2（2025-08-07）→ AC → WA → RE → AC（2026-10-12）

## 解題思路

「任兩個 index 都能互通」⇔ **所有 index 在同一個連通塊**。跟 [LeetCode 952]({{< relref "/leetcode/LeetCode-952" >}}) 一樣，用質因數代替兩兩 GCD。

這裡讓 Union-Find 的節點是**值**：先用 SPF 篩到 `max(nums)`，每個數字跟它的每個質因數合併。最後檢查所有數字是不是同一個根。

**`1` 的特殊情況**：1 沒有質因數，跟誰都連不到。

- 只有一個元素時，沒有「兩個 index」要檢查，答案是 `True`（就算是 `[1]`）。
- 超過一個元素而且有 1：一定是 `False`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 TLE | 兩兩算 GCD，`O(n^2)` |
| RE | 想先去重，寫成 `nums = set(nums)`，`set` 不能用 index 存取 |
| WA | 改成 `list(set(nums))` 去重，但兩個 1 被去重成一個。例如 `[1, 1]`：兩個 1 互相連不到，答案是 `False`，回傳 `True` |
| WA | 加上「有 1 就回傳 `False`」，但 `[1]` 只有一個元素時答案是 `True` |
| 兩次 TLE | 還是兩兩算 GCD |
| AC（隔年） | 改成依質因數合併 index |
| WA | 改成 SPF + 用值當節點，但又沒處理 1：`[1, 1]` 回傳 `True` |
| RE | 加上 `n == 1` 的判斷，但寫在 `n = len(nums)` 前面 |
| AC | 調整順序 |

## 正確解法

```python
class Solution:
    def canTraverseAllPairs(self, nums: List[int]) -> bool:
        n = len(nums)
        if n == 1:
            return True
        if 1 in nums:
            return False                           # 1 跟誰都連不到

        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i

        parent = list(range(m + 1))                # 節點是值

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for x in nums:
            v = x
            while v > 1:
                p = spf[v]
                parent[find(x)] = find(p)          # 數字跟它的質因數合併
                while v % p == 0:
                    v //= p

        root = find(nums[0])
        return all(find(x) == root for x in nums)
```

## 複雜度

時間 `O(M log log M + n log M)`，`M` 是最大值；空間 `O(M)`。

## 要特別避免的錯誤

- 兩兩算 GCD：`O(n^2)`。
- 去重：兩個相同的 1 是兩個 index，去重後就變成一個了。
- `[1]` 是 `True`，多於一個元素而且有 1 才是 `False`。

## 面試口說整理

任兩個 index 都能互通，就是全部在同一個連通塊。有共同因數等於有共同質因數，所以我用 SPF 篩法分解每個數，讓數字跟它的質因數在 Union-Find 裡合併，最後看所有數字是不是同一個根。1 沒有質因數要特判：只有一個元素時是 `True`，否則有 1 就是 `False`。
