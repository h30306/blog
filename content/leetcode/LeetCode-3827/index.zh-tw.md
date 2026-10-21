---
title: "LeetCode 3827: Count Monobit Integers"
summary: "LeetCode 3827 解題筆記：每一位都一樣的數只有 0 和 2^k - 1；個數就是 (n + 1).bit_length()"
description: "2026-02-01 的 LeetCode 3827 解題紀錄"
date: 2026-02-01
tags: ["easy", "bit-manipulation", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-02-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

二進位每一位都一樣：全部是 0 的只有 0，全部是 1 的是 `1, 3, 7, 15, ...` 也就是 `2^k - 1`（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) 模板三）。`2^k - 1 <= n` 等於 `2^k <= n + 1`，`k` 從 1 數到 `(n + 1).bit_length() - 1`，再加上 0，總共 `(n + 1).bit_length()` 個。

## 我的解法

```python
class Solution:
    def countMonobit(self, n: int) -> int:
        return (n + 1).bit_length()
```

我當時用迴圈從 1 開始一直加 `2^power`，產生 1、3、7…，數有幾個 `<= n`，再加上 0；結果一樣。

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 別忘了 0 也算。

## 面試口說整理

每一位都一樣的數只有 0 和 `2^k - 1`。`2^k - 1 <= n` 的 `k` 有 `(n + 1).bit_length() - 1` 個，加上 0 就是答案。時間 `O(1)`。
