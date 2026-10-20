---
title: "LeetCode 3799: Word Squares II"
summary: "LeetCode 3799 解題筆記：四層枚舉，每一層先用角落字母剪枝，排序後輸出自然就是字典序"
description: "2026-01-04 的 LeetCode 3799 解題紀錄"
date: 2026-01-04
tags: ["medium", "backtracking", "enumeration", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-04
- 提交紀錄：Accepted（一次通過）

## 解題思路

四個不同的單字分別當作上、左、右、下四條邊，要滿足四個角的字母相同：

```text
top[0] == left[0]      top[3] == right[0]
bottom[0] == left[3]   bottom[3] == right[3]
```

依序決定 `top → left → right → bottom`，每決定一個就檢查跟已經決定的單字有沒有衝突，不符合就不往下一層。

輸出要依 `(top, left, right, bottom)` 的字典序排序：**先把單字排序**，四層迴圈依序枚舉，產生的順序就已經是字典序。

## 我的解法

```python
class Solution:
    def wordSquares(self, words: List[str]) -> List[List[str]]:
        words.sort()
        res = []
        for top in words:
            for left in words:
                if left == top or left[0] != top[0]:
                    continue
                for right in words:
                    if right in (top, left) or right[0] != top[3]:
                        continue
                    for bottom in words:
                        if bottom in (top, left, right):
                            continue
                        if bottom[0] == left[3] and bottom[3] == right[3]:
                            res.append([top, left, right, bottom])
        return res
```

原本交的版本在第二層迴圈裡留了一行 `print([word1, word2])`，雖然 AC，但大量輸出會拖慢速度，應該刪掉。

### 可以再快：依首字母分組

每一層要找「首字母是某個字母的單字」，可以先建 `by_first[c] = 以 c 開頭的單字`，內層只掃那一組，不用掃全部的單字。

## 複雜度

最壞 `O(n^4)`，但角落字母的限制讓實際搜尋的組合少很多。

## 要特別避免的錯誤

- 沒有檢查四個單字互不相同。
- 先把結果收集起來再排序也可以，但先排序單字就不需要。
- 留下除錯用的 `print`。

## 面試口說整理

我依序決定上、左、右、下四個單字，每決定一個就檢查它和已經選的單字在角落的字母是否一致、而且不能重複，不符合就不往下。因為先把單字排序，四層依序枚舉產生的結果自然就是要求的字典序。可以再用首字母分組，讓每一層只看可能的候選。
