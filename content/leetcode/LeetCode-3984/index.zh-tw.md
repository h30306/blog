---
title: "LeetCode 3984: Divisible Game"
summary: "LeetCode 3984 解題筆記：k 是合數時，換成它的質因數只會更好（能整除的更多、k 更小），所以只要試每個數的質因數加上 2；每個候選 k 跑一次 Kadane"
description: "2026-07-06 的 LeetCode 3984 解題紀錄"
date: 2026-07-06
tags: ["medium", "dynamic-programming", "kadane", "math", "number-theory", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-06
- 提交紀錄：WA → AC → WA ×2 → AC

## 解題思路

固定 `k` 之後，能被 `k` 整除的當 `+x`、不能的當 `-x`，最大差就是**最大子陣列和**，用 Kadane 一次 `O(n)`。

`k` 有哪些候選？

- **合數不用試**：如果 `k` 是合數、`p` 是它的質因數，能被 `k` 整除的一定也能被 `p` 整除，所以換成 `p` 差只會更大或一樣，而且 `p < k`，平手時也選 `p`。
- 所以候選就是**所有數的質因數**。`nums[i] <= 10^6`，用 `<= 1000` 的質數試除，除完剩下的 `> 1` 也是一個質因數。
- **一定要加上 2**：如果所有數都是 1，沒有任何質因數；這時 `k = 2` 整除不了任何數，差是最大的單一 `-x`，而 2 是最小的 `k`。

最後平手時取最小的 `k`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 只用 `<= 1000` 的質數當候選，**漏掉大於 1000 的質因數**。例如 `[1013]`：取 `k = 1013` 差是 1013，答案是 `1013 × 1013 = 1026169`，這版只試了 2 |
| 第二版 AC | 試除後剩下 `> 1` 的也加進候選 |
| 第三版 | 拿掉了預設的 2，全部都是 1 時候選是空的。例如 `[1]`：答案是 `-1 × 2` 取模，這版算出 `nan` |
| 第四版 | 重寫時質數篩法忘了把質數 `append` 進 list，候選只剩每個數本身。例如 `[9]`：`k = 3` 和 `k = 9` 差都是 9，要取小的 3，答案 27，這版回傳 81 |
| 第五版 AC | 補上 `append` |

## 正確解法

```python
class Solution:
    def divisibleGame(self, nums: List[int]) -> int:
        MOD = 10 ** 9 + 7
        LIMIT = 1001
        is_prime = [True] * LIMIT
        primes = []
        for p in range(2, LIMIT):
            if is_prime[p]:
                primes.append(p)
                for q in range(p * p, LIMIT, p):
                    is_prime[q] = False

        candidates = {2}                           # 全部都是 1 時也要有候選
        for x in nums:
            for p in primes:
                if p * p > x:
                    break
                if x % p == 0:
                    candidates.add(p)
                    while x % p == 0:
                        x //= p
            if x > 1:
                candidates.add(x)                  # 剩下的大質因數

        best_diff, best_k = float("-inf"), 0
        for k in sorted(candidates):               # 由小到大，平手時保留小的
            cur, best = 0, float("-inf")
            for x in nums:
                score = x if x % k == 0 else -x
                cur = max(score, cur + score)      # Kadane
                best = max(best, cur)
            if best > best_diff:
                best_diff, best_k = best, k
        return best_diff * best_k % MOD
```

試除時 `p * p > x` 就可以停：剩下的 `x` 如果 `> 1` 一定是質數。

## 複雜度

每個數最多有 7 個不同的質因數，候選最多約 `7n` 個，每個跑一次 `O(n)` 的 Kadane，總共 `O(n^2)`，`n <= 1000`。

## 要特別避免的錯誤

- 只用小質數當候選：大於 `sqrt(max)` 的質因數會漏掉。
- 沒有候選的情況（全部都是 1）。
- 篩法裡忘了收集質數。

## 面試口說整理

固定 `k` 之後，能整除的當正、不能的當負，答案是最大子陣列和，用 Kadane。合數的 `k` 換成它的質因數只會更好，所以候選只有所有數的質因數，再加上 2 處理全部都是 1 的情況。每個候選跑一次 Kadane，平手取小的 `k`。時間 `O(n^2)`。
