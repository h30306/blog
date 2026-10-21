---
title: "LeetCode 402: Remove K Digits"
summary: "LeetCode 402 解題筆記：單調遞增 stack，遇到比頂端小的數字就把頂端刪掉（還有 k 次可刪時），最後去掉前導零"
description: "2022-11-17 的 LeetCode 402 解題紀錄"
date: 2022-11-17
tags: ["medium", "string", "stack", "greedy", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-17
- 提交紀錄：Wrong Answer ×2 → Runtime Error → Accepted ×2

## 解題思路

要讓結果最小，越前面的位數越重要（[Stack]({{< relref "/algorithm/Stack" >}}) 模板四）。從左往右維護遞增的 stack：目前的數字比頂端小、而且還能刪（`k > 0`），就把頂端刪掉，因為用比較小的數字取代前面的位數一定更好。掃完之後 `k` 還有剩，就從尾巴刪（剩下的是遞增的，尾巴最大）。最後去掉前導零，空的就回傳 `"0"`。

## 我的嘗試

- 第一版用了一個「在前 `k + 1` 個數字裡找最小值」的猜測，不是正確的貪心：`"22"`、`k = 1` 回傳 `"22"`。
- 改成「刪掉第一個比下一個大的數字」之後，邊界條件 `i != len(num) - 1` 不夠，刪完之後 `i` 會超出範圍（IndexError），也沒有去掉前導零。改成 `i < len(num) - 1` 加上 `str(int(num))` 才 AC，但每刪一個字元都要重建字串，是 `O(nk)`。

## 正確解法

```python
class Solution:
    def removeKdigits(self, num: str, k: int) -> str:
        st = []
        for d in num:
            while k and st and st[-1] > d:
                st.pop()
                k -= 1
            st.append(d)
        if k:
            st = st[:-k]
        return "".join(st).lstrip("0") or "0"
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 掃完 `k` 還有剩要從尾巴刪，例如 `"22"`、`k = 1`。
- 去掉前導零，空字串回傳 `"0"`。
- 每次刪一個字元就重建字串是 `O(n²)`。

## 面試口說整理

要讓數字最小，越前面的位數越重要，所以我維護一個遞增的 stack，遇到比頂端小的數字、而且還能刪，就把頂端刪掉；掃完還有剩的刪除次數就從尾巴刪，最後去掉前導零。每個數字最多進出一次，時間 `O(n)`。
