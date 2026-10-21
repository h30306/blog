---
title: "LeetCode 187: Repeated DNA Sequences"
summary: "LeetCode 187 解題筆記：把每個長度 10 的子字串丟進雜湊表計數，出現超過一次的就是答案"
description: "2022-11-14 的 LeetCode 187 解題紀錄"
date: 2022-11-14
tags: ["medium", "hash-table", "string", "bit-manipulation", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

列舉每個長度 10 的子字串（[String]({{< relref "/algorithm/String" >}}) 模板三，也就是 [Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) 模板一的固定視窗），用雜湊表計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），次數大於 1 的就是答案。

## 我的嘗試

一次 AC。當時迴圈跑到 `len(s)`，尾巴不滿 10 個字元的片段也被放進表裡，但它們各自只出現一次，所以不影響答案。

## 正確解法

```python
class Solution:
    def findRepeatedDnaSequences(self, s: str) -> List[str]:
        cnt = Counter(s[i:i + 10] for i in range(len(s) - 9))
        return [seq for seq, c in cnt.items() if c > 1]
```

## 複雜度

時間 `O(10n)`，空間 `O(10n)`。

## 要特別避免的錯誤

- 起點只到 `len(s) - 10`，不然會把尾巴不滿 10 個字元的片段也算進去。
- 不能用 `s.count(seq)`：它數的是**不重疊**的出現次數，`"AAAAAAAAAAA"` 會漏掉。

## 面試口說整理

我列舉所有長度 10 的子字串放進雜湊表計數，出現超過一次的回傳。每個子字串長度固定是 10，所以時間和空間都是 `O(n)`；想再省可以把 A、C、G、T 編碼成 2 bits，用 rolling hash 讓每次移動 `O(1)`。
