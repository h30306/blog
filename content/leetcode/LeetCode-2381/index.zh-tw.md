---
title: "LeetCode 2381: Shifting Letters II"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-20
tags: ["LeetCode", "blog", "medium", "difference array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-20
- 總花費時間：00:00.00

## 解題思路

這是一題前綴和問題。我一開始想到的方法是建立一個與字串 `s` 長度相同的前綴和陣列 `ps`，然後遍歷 `shifts` 陣列，把每一段的往前或往後位移資訊記錄到對應位置上，看起來像這樣：

```
for (start, end, direction) in shifts:
    for i in range(start, end+1):
        if direction: # 往前
            ps[i] += 1
        else:
            ps[i] -= 1
```

但這樣是 `O(n^2)` 的操作，當 `s` 長度非常大（例如題目限制中最大為 `5 * 10^4`）時會導致 TLE。後來我想到這其實是一題**差分陣列**的應用題，只需要記錄每一段開頭與結尾的變化即可，能夠有效避開 `O(n^2)` 的複雜度。

## 解法

### TLE 解法

```python
class Solution:
    def shiftingLetters(self, s: str, shifts: List[List[int]]) -> str:

        n = len(s)
        ps = [0]*n

        for (start, end, direction) in shifts:
            for i in range(start, end+1):
                if direction: # 往前
                    ps[i] += 1
                else:
                    ps[i] -= 1

        result = []
        for i in range(n):
            diff_with_a = ord(s[i]) - ord('a')
            diff = (ps[i] % 26 + diff_with_a) % 26
            
            result.append(chr(ord('a') + diff))

        return "".join(result)
```

### 使用差分陣列的優化解法

```python
class Solution:
    def shiftingLetters(self, s: str, shifts: List[List[int]]) -> str:

        n = len(s)
        ps = [0]*(n+1)

        for (start, end, direction) in shifts:
            if direction: # 往前
                ps[start] += 1
                if end < n:
                    ps[end+1] -= 1
            else: # 往後
                ps[start] -= 1
                if end < n:
                    ps[end+1] += 1

        result = []
        count = 0
        for i in range(n):
            count += ps[i]
            diff_with_a = ord(s[i]) - ord('a')
            diff = (count % 26 + diff_with_a) % 26
            
            result.append(chr(ord('a') + diff))

        return "".join(result)
```

## 收穫
第一次解差分陣列問題

## 遇到的問題

我在處理 `ord()` 差值時出現了一些錯誤，一開始沒有把 `'a'` 與差值拆開處理，結果在移位後導致字符超過 `'z'`，產生錯誤。