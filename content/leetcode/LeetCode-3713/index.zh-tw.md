---
title: "LeetCode 3713: Longest Balanced Substring I"
summary: "LeetCode 3713 解題筆記：固定起點往右擴；「每種字元次數都一樣」等於「最大次數 × 種類數 = 長度」，每一步 O(1) 判斷"
description: "2026-06-22 的 LeetCode 3713 解題紀錄"
date: 2026-06-22
tags: ["medium", "hash-table", "string", "counting", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-22
- 提交紀錄：Time Limit Exceeded → Accepted（1.9 秒）

## 解題思路

`n <= 1000`，枚舉所有子字串是 `O(n²)`。固定起點往右擴，增量維護每個字元的次數（[String]({{< relref "/algorithm/String" >}}) 模板五）。

判斷「每種字元次數都一樣」不用把所有次數拿出來比：如果每種都出現 `f` 次，長度就是 `f × 種類數`；反過來，最大次數是 `f` 而長度剛好等於 `f × 種類數`，就代表每一種都是 `f`。所以維護 `max_freq` 和種類數，每一步 `O(1)`。

## 我的嘗試

第一版外面多了一層迴圈枚舉「種類數 1 到 26」，裡面再枚舉所有子字串，多做了 26 倍，TLE。拿掉外層就過了，但每一步用 `len(set(freq.values()))` 判斷，還是要 1.9 秒。

## 正確解法

```python
class Solution:
    def longestBalanced(self, s: str) -> int:
        n, best = len(s), 0
        for i in range(n):
            cnt = Counter()
            max_freq = 0
            for j in range(i, n):
                cnt[s[j]] += 1
                max_freq = max(max_freq, cnt[s[j]])
                if max_freq * len(cnt) == j - i + 1:
                    best = max(best, j - i + 1)
        return best
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`（最多 26 種字元）。

## 要特別避免的錯誤

- 不要多一層不必要的枚舉。
- 每一步拿所有次數做 `set` 是 `O(26)`；用「最大次數 × 種類數 = 長度」是 `O(1)`。

## 面試口說整理

我固定起點往右擴，維護每個字元的次數、最大次數和種類數。每種都一樣多，等於最大次數乘上種類數剛好是長度，所以每一步 `O(1)` 判斷。總共 `O(n²)`。
