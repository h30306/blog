---
title: "LeetCode 1229: Meeting Scheduler"
summary: "LeetCode 1229 解題筆記：兩個人的時段各自排序後，跟 986 一樣用雙指針找交集；第一個長度夠的交集就是最早的時段"
description: "2026-02-10 的 LeetCode 1229 解題紀錄"
date: 2026-02-10
tags: ["medium", "two-pointers", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-10
- 提交紀錄：Wrong Answer ×3 → Accepted ×2

## 解題思路

跟 [LeetCode 986]({{< relref "/leetcode/LeetCode-986" >}}) 一樣是兩個區間列表找交集，差別是**這題的輸入沒有排序**。

1. 兩個人的時段各自依起點排序。
2. 雙指針：交集是 `[max(start1, start2), min(end1, end2)]`，長度 `>= duration` 就回傳 `[start, start + duration]`。
3. 結束得比較早的那個時段不會再跟別人相交，移動它的指針。

雙指針是依時間順序走過所有交集，所以**第一個夠長的交集就是最早的**。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 回傳時把長度寫死成 `+ 8`（範例的 duration），長度判斷用 `>`，也沒排序。例如 `[[0, 10]]`、`[[0, 10]]`、`duration = 3`：答案是 `[0, 3]`，回傳 `[0, 8]` |
| 第二版 | 改成 `+ duration`，但還是 `>`，剛好等於 `duration` 的交集被跳過。例如 `[[0, 5]]`、`[[0, 5]]`、`duration = 5`：答案是 `[0, 5]`，回傳 `[]` |
| 第三版 | 改成 `>=`，但沒排序。例如 `slots1 = [[10, 15], [0, 5]]`、`slots2 = [[0, 5]]`、`duration = 2`：答案是 `[0, 2]`，這版拿 `[10, 15]` 跟 `slots2` 的 `[0, 5]` 比，沒有交集，`[0, 5]` 比較早結束就被跳過了，回傳 `[]` |

補上排序就 AC 了。之後又把「先跳過太短的時段」那段拿掉，因為交集的長度判斷已經涵蓋它。

## 正確解法

```python
class Solution:
    def minAvailableDuration(self, slots1: List[List[int]], slots2: List[List[int]], duration: int) -> List[int]:
        slots1.sort()
        slots2.sort()
        i = j = 0
        while i < len(slots1) and j < len(slots2):
            start = max(slots1[i][0], slots2[j][0])
            end = min(slots1[i][1], slots2[j][1])
            if end - start >= duration:
                return [start, start + duration]
            if slots1[i][1] < slots2[j][1]:
                i += 1                             # slots1[i] 先結束
            else:
                j += 1
        return []
```

## 複雜度

時間 `O(n log n + m log m)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 輸入沒排序：題目只保證同一個人的時段不重疊，沒保證順序。
- 長度剛好等於 `duration` 也可以，要用 `>=`。
- 把範例的數字寫死在程式裡。

## 面試口說整理

這題跟區間交集一樣，只是輸入沒排序，所以我先把兩個人的時段排序，再用雙指針找交集，交集長度夠就回傳起點加 `duration`。雙指針是依時間順序走過交集，所以第一個找到的就是最早的。結束比較早的時段先移動。時間由排序決定，`O(n log n)`。
