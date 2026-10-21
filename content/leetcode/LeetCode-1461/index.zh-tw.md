---
title: "LeetCode 1461: Check If a String Contains All Binary Codes of Size K"
summary: "LeetCode 1461 解題筆記：把所有長度 k 的子字串丟進集合，大小等於 2^k 就成立；最後一個起點是 len(s) - k"
description: "2026-01-05 的 LeetCode 1461 解題紀錄"
date: 2026-01-05
tags: ["medium", "hash-table", "string", "bit-manipulation", "rolling-hash"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-05
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

長度 `k` 的二進位碼有 `2^k` 種。把 `s` 裡所有長度 `k` 的子字串丟進集合（[String]({{< relref "/algorithm/String" >}}) 模板三），大小等於 `2^k` 就全部都有。

- 子字串只有 `len(s) - k + 1` 個，比 `2^k` 少就一定不夠，可以先回傳。
- `k <= 20`，也可以用滾動的整數代替子字串：`code = ((code << 1) | bit) & mask`，省掉切片。

## 我的嘗試

1. **第一版**加入的是 `s[right - k: right]`，結尾不包含 `right`，**最後一個視窗永遠收不到**。例如 `"10"`、`k = 1`：只收到 `"1"`，回傳 `False`，答案 `True`。
2. **第二版**改成 `s[right - k - 1: right]`，長度變成 `k + 1`，更錯。
3. 改成 `s[right - k + 1: right + 1]` 就 AC 了。

## 正確解法

```python
class Solution:
    def hasAllCodes(self, s: str, k: int) -> bool:
        need = 1 << k
        if len(s) - k + 1 < need:
            return False
        seen = {s[i:i + k] for i in range(len(s) - k + 1)}
        return len(seen) == need
```

## 複雜度

時間 `O(n · k)`，空間 `O(min(n, 2^k) · k)`。用滾動整數可以降到 `O(n)` 時間。

## 要特別避免的錯誤

- `s[a:b]` 長度是 `b - a`，結尾不包含 `b`。
- 子字串數量不夠 `2^k` 時可以直接回傳 `False`。

## 面試口說整理

我把所有長度 `k` 的子字串放進集合，看集合大小是不是 `2^k`。子字串總數比 `2^k` 少就直接是 `False`。也可以用位元滾動維護目前的 `k` 位數字，避免切片。時間 `O(nk)`。
