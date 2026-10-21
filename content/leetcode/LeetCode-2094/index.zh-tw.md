---
title: "LeetCode 2094: Finding 3-Digit Even Numbers"
summary: "LeetCode 2094 解題筆記：反過來枚舉 100 到 998 的偶數，檢查需要的每個數字次數夠不夠；Counter 相減只留正數"
description: "2025-05-12 的 LeetCode 2094 解題紀錄"
date: 2025-05-12
tags: ["easy", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-12
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

三位偶數只有 450 個（100 到 998），**反過來枚舉答案**比較簡單（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）：

- 數每個數字有幾個可以用：`have = Counter(digits)`。
- 對每個候選數 `x`，數它需要的數字：`need = Counter(str(x))`。
- `need - have` 只留下「需要比有的多」的部分，是空的就代表夠用。

枚舉本身由小到大，結果自動排好、不會重複。

## 我的嘗試

我當時用三層迴圈枚舉 `counter` 的 key 組三個位數，再用條件排除數字不夠的情況。第一版的條件 `(j == k and counter[i] < 2)` **寫錯變數**，應該檢查 `counter[j]`。例如 `[3, 2, 2]`：答案是 `[232, 322]`，`322` 的後兩位都是 2，這版拿 3 的個數去判斷，漏掉了它。改成 `counter[j]` 就 AC 了。

## 正確解法

```python
class Solution:
    def findEvenNumbers(self, digits: List[int]) -> List[int]:
        have = Counter(map(str, digits))
        return [x for x in range(100, 1000, 2) if not Counter(str(x)) - have]
```

## 複雜度

時間 `O(450 × 3 + n)`，也就是 `O(n)`，空間 `O(1)`（最多 10 種數字）。

## 要特別避免的錯誤

- 三層迴圈組合時，判斷重複次數要用對應位置的變數。
- `Counter` 的 key 型別要一致：一邊是字串，另一邊也要是字串。

## 面試口說整理

三位偶數只有 450 個，所以我反過來枚舉 100 到 998 的偶數，數它需要哪些數字各幾個，跟手上的數字比，`Counter` 相減是空的就代表夠用。由小到大枚舉，結果已經排好也不會重複。
