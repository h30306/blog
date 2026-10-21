---
title: "LeetCode 3960: Frequency Balance Subarray"
summary: "LeetCode 3960 解題筆記：n 只有 1000，固定左端點往右擴，同時維護「值 -> 次數」和「次數 -> 個數」；只有 f 和 2f 兩種次數就成立"
description: "2026-06-18 的 LeetCode 3960 解題紀錄"
date: 2026-06-18
tags: ["medium", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-18
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`n <= 1000`，`O(n²)` 可以。固定左端點往右擴，每加一個數只改動 `O(1)` 個計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板四）：

- `cnt`：值 -> 次數。
- `freq`：次數 -> 有幾個值是這個次數。值的次數從 `c` 變成 `c + 1` 時，`freq[c]` 減 1（減到 0 要刪掉）、`freq[c + 1]` 加 1。

成立的條件：只有一種值，或 `freq` 剛好有兩種次數而且大的是小的兩倍。

## 我的嘗試

第一版多了一個條件 `min(freq_map) in apperance_map`，**把「次數」拿去查「值 -> 次數」的表**，兩者意義不同。例如 `[2, 3, 2]`：2 出現 2 次、3 出現 1 次，整段成立，答案 3；最小的次數 1 不是陣列裡的值，這版回傳 1。拿掉這個條件就 AC 了。

## 正確解法

```python
class Solution:
    def getLength(self, nums: List[int]) -> int:
        n, best = len(nums), 0
        for i in range(n):
            cnt, freq = {}, Counter()
            for j in range(i, n):
                c = cnt.get(nums[j], 0)
                if c:
                    freq[c] -= 1
                    if freq[c] == 0:
                        del freq[c]
                cnt[nums[j]] = c + 1
                freq[c + 1] += 1
                if len(cnt) == 1 or (len(freq) == 2 and max(freq) == 2 * min(freq)):
                    best = max(best, j - i + 1)
        return best
```

## 複雜度

時間 `O(n²)`，空間 `O(n)`。`max(freq)` 和 `min(freq)` 只在 `len(freq) == 2` 時才算，所以是 `O(1)`。

## 要特別避免的錯誤

- 次數減到 0 要刪掉，不然 `len(freq)` 不準。
- 「次數」和「值」是兩種不同的 key，不要混用。

## 面試口說整理

`n` 只有 1000，我固定左端點往右擴，同時維護每個值的次數，以及每種次數有幾個值。每加一個數只更新兩個次數的計數。只有一種值，或剛好兩種次數而且大的是小的兩倍時就更新答案。時間 `O(n²)`。
