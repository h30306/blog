---
title: "LeetCode 1512: Number of Good Pairs"
summary: "LeetCode 1512 解題筆記：邊掃邊數，每個數可以跟前面每個相同的數配一對，答案加上目前的出現次數"
description: "2025-12-18 的 LeetCode 1512 解題紀錄"
date: 2025-12-18
tags: ["easy", "math", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-18
- 提交紀錄：Accepted ×2（Python）→ Compile Error → Accepted ×2（C++）

## 解題思路

`nums[i] == nums[j]` 而且 `i < j` 的配對數。

- 暴力：兩層迴圈 `O(n^2)`，`n <= 100` 也能過。
- 計數：每種數出現 `c` 次，配對數是 `c × (c - 1) / 2`。
- **邊掃邊數**：讀到 `x` 時，它可以跟前面每個 `x` 配一對，所以答案加上 `cnt[x]`，再把 `cnt[x]` 加 1。

## 我的解法

```python
class Solution:
    def numIdenticalPairs(self, nums: List[int]) -> int:
        cnt = Counter()
        pairs = 0
        for x in nums:
            pairs += cnt[x]                        # 跟前面每個 x 配一對
            cnt[x] += 1
        return pairs
```

我先用 Python 寫了暴力和組合數兩種，再用 C++ 練習邊掃邊數的寫法；C++ 那次的 Compile Error 是 `return res` 少了分號。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 組合數用 `/` 會變成浮點數，用 `//`，或直接邊掃邊數。

## 面試口說整理

我邊掃邊數：讀到一個數時，它可以跟前面每個相同的數配成一對，所以答案加上目前它出現過的次數，再把次數加一。時間 `O(n)`。
