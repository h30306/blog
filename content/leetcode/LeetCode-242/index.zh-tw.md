---
title: "LeetCode 242: Valid Anagram"
summary: "LeetCode 242 解題筆記：兩個字串的字元次數完全相同就是 anagram，用 Counter 比較或排序後比較"
description: "2022-08-22 的 LeetCode 242 解題紀錄"
date: 2022-08-22
tags: ["easy", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-22
- 提交紀錄：Accepted ×3 → Runtime Error ×2 → Accepted → Runtime Error → Wrong Answer → Accepted → Wrong Answer ×4

## 解題思路

anagram 就是每個字元出現的次數都一樣（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。`Counter(s) == Counter(t)` 一行就好；手寫的話用一個 dict，`s` 的字元 `+1`、`t` 的字元 `-1`，最後**每一個**值都是 0 才成立。

## 我的嘗試

2022-08 第一次用 `sorted` 和 `Counter` 都 AC，之後試著手寫計數：

- 寫成 `tracker.get(x, 0) + 1`，**算出來沒有存回 dict**，表永遠是空的，`all(...)` 對空的回傳 `True`：`"a"` 和 `"c"` 也回傳 `True`。

2022-11 重寫又錯了四次：

- 第二個迴圈減的是 `alpha_count[s]`，`s` 是第一個迴圈留下來的變數，不是現在的字元 `t`；最後又只檢查**總和**是 0，正負會抵消：`"ac"` 和 `"aa"` 回傳 `True`。
- 最後一版寫成 `not all(values)`，意思變成「**有一個**是 0 就成立」：`"ba"` 和 `"b"` 回傳 `True`。

## 正確解法

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False
        cnt = defaultdict(int)
        for a, b in zip(s, t):
            cnt[a] += 1
            cnt[b] -= 1
        return all(v == 0 for v in cnt.values())
```

## 複雜度

時間 `O(n)`，空間 `O(k)`（`k` 是字元種類數）。

## 要特別避免的錯誤

- 要檢查**每一個**次數都是 0，不能只看總和：`+1` 和 `-1` 會互相抵消。
- `tracker.get(x, 0) + 1` 只是算出值，沒有存回去。

## 面試口說整理

我用一個雜湊表，第一個字串的字元加一、第二個字串的字元減一，最後所有次數都是 0 就是 anagram。時間 `O(n)`；如果只有小寫字母，可以用長度 26 的陣列。
