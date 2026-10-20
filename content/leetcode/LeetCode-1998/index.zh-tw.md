---
title: "LeetCode 1998: GCD Sort of an Array"
summary: "LeetCode 1998 解題筆記：同一個連通塊裡的數可以任意交換；用 SPF 把數字跟質因數合併，排序後每個位置的新舊數字在同一組就能排好"
description: "2026-10-12 的 LeetCode 1998 解題紀錄"
date: 2026-10-12
tags: ["hard", "math", "number-theory", "union-find", "sieve", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-12
- 提交紀錄：AC → RE → WA → AC → WA ×2 → AC ×2（同一天練了三種篩法）

## 解題思路

可以交換兩個有共同因數的數。在同一個連通塊裡，透過一連串交換，**任意排列都做得到**（跟「可以交換的位置形成連通塊，塊內可以任意排序」一樣）。

所以：

1. 用 Union-Find 把每個數字跟它的質因數合併（跟 [LeetCode 2709]({{< relref "/leetcode/LeetCode-2709" >}}) 一樣，節點是值）。
2. 排序後，第 `i` 個位置原本的數 `nums[i]` 和排好後的數 `sorted[i]` 必須在**同一個連通塊**，不然沒辦法換過來。

## 我的嘗試

第一次用「試除 + `owner[p]`、節點是 index」AC，之後想練 SPF 篩法：

| 版本 | 問題 |
|---|---|
| RE | 變數名稱打錯（`sorted_unms`） |
| WA | SPF 篩法寫成 `spf[i] = i`，應該是 `spf[j] = i`，合數的 SPF 一直是自己；分解時又直接改 `num`，之後拿去 union 的值也不對。例如 `[9, 3]`：9 和 3 有共同因數 3，可以交換排好，答案是 `True`，回傳 `False` |
| AC | 修好兩個地方 |
| 兩次 WA | 改用線性篩，但內層迴圈放在 `if spf[i] == 0`（是質數）裡面，**只有質數會去劃掉倍數**，像 `8 = 4 × 2` 就沒人處理，被當成質數。例如 `[8, 2]`：答案是 `True`，回傳 `False` |
| AC ×2 | 內層迴圈移到外面，每個 `i` 都要跑 |

## 正確解法

```python
class Solution:
    def gcdSort(self, nums: List[int]) -> bool:
        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i                 # 是 spf[j]

        parent = list(range(m + 1))                # 節點是值

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for x in nums:
            v = x                                  # 用副本分解，x 留著 union
            while v > 1:
                p = spf[v]
                parent[find(x)] = find(p)
                while v % p == 0:
                    v //= p

        return all(find(a) == find(b) for a, b in zip(nums, sorted(nums)))
```

## 複雜度

時間 `O(M log log M + n log M + n log n)`，空間 `O(M)`。

## 要特別避免的錯誤

- SPF 篩法裡寫成 `spf[i]`。
- 分解質因數時改到原本的變數，之後 union 用的值就錯了。
- 線性篩的內層迴圈要對每個 `i` 跑。

## 面試口說整理

同一個連通塊裡的數可以透過交換任意排列，所以我用 SPF 篩法把每個數跟它的質因數在 Union-Find 裡合併，再把陣列排序，檢查每個位置原本的數和排序後的數是不是在同一組。時間 `O(M log log M + n log n)`。
