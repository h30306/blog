---
title: "LeetCode 2904: Shortest and Lexicographically Smallest Beautiful String"
summary: "LeetCode 2904 解題筆記：視窗裡剛好 k 個 1 時，把左邊的 0 也縮掉，得到以 right 結尾最短的美麗子字串；先比長度再比字典序"
description: "2026-01-18 的 LeetCode 2904 解題紀錄"
date: 2026-01-18
tags: ["medium", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-18
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

最短的美麗子字串一定**頭尾都是 1**（頭尾的 0 可以拿掉）。

滑動視窗：右端加入字元，1 超過 `k` 個、或剛好 `k` 個但左端是 0，就縮左邊。縮完後如果剛好 `k` 個 1，這就是以 `right` 結尾最短的候選。

比較候選時，**先比長度，長度相同才比字典序**。

## 我的嘗試

第一版的比較寫成 `len(ans) > len(target) or ans > target`：只要字典序比較小就取代，不管長度。例如 `s = "1101"`、`k = 2`：最短的是 `"11"`，但 `"101"` 的字典序比 `"11"` 小，結果回傳 `"101"`。

## 正確解法

```python
class Solution:
    def shortestBeautifulSubstring(self, s: str, k: int) -> str:
        left = ones = 0
        ans = ""
        for right, c in enumerate(s):
            ones += c == "1"
            while ones > k or (ones == k and s[left] == "0"):
                ones -= s[left] == "1"
                left += 1
            if ones == k:
                cand = s[left:right + 1]
                if not ans or len(cand) < len(ans) or (len(cand) == len(ans) and cand < ans):
                    ans = cand
        return ans
```

## 複雜度

時間 `O(n^2)`（比較候選字串最多 `O(n)`），`n <= 100`。空間 `O(n)`。

## 要特別避免的錯誤

- 只比字典序，沒有先比長度。
- `"101" < "11"`：字串比較是逐字比，不是比長度。

## 面試口說整理

最短的美麗子字串頭尾一定是 1。我用滑動視窗，1 超過 `k` 個或剛好 `k` 個但左端是 0 時縮左邊，縮完剛好 `k` 個 1 就是以右端結尾最短的候選。比較時先看長度，長度一樣才比字典序。
