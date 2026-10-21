---
title: "LeetCode 4019: Merge Close Characters II"
summary: "LeetCode 4019 解題筆記：留下來的字不會再變，記每種字元在結果裡最後的位置；新字元跟它的距離 <= k 就被合併掉"
description: "2026-09-13 的 LeetCode 4019 解題紀錄"
date: 2026-09-13
tags: ["medium", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-09-13
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

每次都選 `i` 最小的相近配對，所以合併是**從左邊開始穩定下來的**：已經處理過、留下來的前綴裡不會有相近的配對，之後也不會再變。

所以由左到右建結果（[String]({{< relref "/algorithm/String" >}}) 模板一）：

- 記每種字元**在結果裡**最後的位置 `last[ch]`。
- 新字元要放在結果的位置 `len(res)`；如果 `len(res) - last[ch] <= k`，它會跟前面那個字元相近，被合併掉。
- 否則放進結果，更新 `last[ch]`。

距離要用「結果裡的位置」算，因為題目的 index 是刪除後重新編號的。

## 我的嘗試

第一版想用原本的 index 減掉「最近被刪掉的個數」換算成目前的位置，用一個 deque 記視窗內刪掉的位置，但**只扣了視窗內的刪除數**，距離算錯。例如 `"ccccca"`、`k = 1`：所有的 `c` 都會併成一個，答案 `"ca"`，這版回傳 `"cca"`。改成直接記結果裡的位置就 AC 了。

## 正確解法

```python
class Solution:
    def mergeCharacters(self, s: str, k: int) -> str:
        last, res = {}, []
        for ch in s:
            if ch in last and len(res) - last[ch] <= k:
                continue                           # 跟前面的同字元相近，被合併
            last[ch] = len(res)
            res.append(ch)
        return "".join(res)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- index 會在刪除後重新編號，距離要用結果裡的位置算。

## 面試口說整理

因為每次都合併 `i` 最小的配對，留下來的前綴不會再變。我由左到右建結果，記每種字元在結果裡最後的位置，新字元如果距離那個位置不超過 `k` 就被合併掉，否則放進結果。時間 `O(n)`。
