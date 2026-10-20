---
title: "LeetCode 4026: Maximum Gap Between Stations"
summary: "LeetCode 4026 解題筆記：從左邊貪心配出每個工人最早可用的站、從右邊配出最晚可用的站；在第 i 和 i+1 個工人之間切開，最大間隔是 latest[i+1] - earliest[i]"
description: "2026-08-26 的 LeetCode 4026 解題紀錄"
date: 2026-08-26
tags: ["medium", "two-pointers", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-26
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

工人要依序配到 `skill[i] == station[j]` 而且 index 嚴格遞增的站，就是在 `station` 裡找 `skill` 這個子序列。

要讓第 `i` 和第 `i + 1` 個工人之間的間隔最大：

- 工人 `0..i` 盡量**靠左**：從左邊貪心配子序列，得到每個工人**最早**可用的站 `earliest[i]`。
- 工人 `i + 1..n - 1` 盡量**靠右**：從右邊貪心配，得到**最晚**可用的站 `latest[i + 1]`。

兩邊互不干擾（`earliest[i] < latest[i + 1]`，因為題目保證有合法的配法），所以間隔 `latest[i + 1] - earliest[i]` 一定做得到。對每個 `i` 取最大值就是答案。

兩次貪心配對都是在 `skill` 和 `station` 上走兩個同向指針，跟判斷子序列一樣。

## 我的嘗試

第一版從右邊配的時候，是從最後一個工人往前 `append`，所以 `latest` 是**反過來的**，卻直接拿 `latest[i + 1]` 用。例如 `skill = "ab"`、`station = "aabb"`：最早的 `a` 在 0、最晚的 `b` 在 3，答案是 3；這版回傳 1。

補上 `right.reverse()` 就 AC 了。

## 正確解法

```python
class Solution:
    def maximumGap(self, skill: str, station: str) -> int:
        n, m = len(skill), len(station)
        earliest = [0] * n
        j = 0
        for i in range(n):
            while station[j] != skill[i]:
                j += 1
            earliest[i] = j                        # 工人 i 最早能用的站
            j += 1

        latest = [0] * n
        j = m - 1
        for i in range(n - 1, -1, -1):
            while station[j] != skill[i]:
                j -= 1
            latest[i] = j                          # 工人 i 最晚能用的站
            j -= 1

        return max((latest[i + 1] - earliest[i] for i in range(n - 1)), default=0)
```

直接用 index 寫入 `latest[i]`，就不用再反轉。只有一個工人時 `default=0`。

## 複雜度

時間 `O(n + m)`，空間 `O(n)`。

## 要特別避免的錯誤

- 從右邊往前 `append` 的列表是反的。
- 只有一個工人時答案是 0。

## 面試口說整理

工人配站就是在 `station` 裡找 `skill` 的子序列。要讓某兩個相鄰工人的間隔最大，前面的工人盡量靠左、後面的工人盡量靠右。我從左邊貪心配出每個工人最早的站、從右邊配出最晚的站，在每個切點算 `latest[i + 1] - earliest[i]` 取最大值。兩次都是同向雙指針，時間 `O(n + m)`。
