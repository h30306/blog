---
title: "LeetCode 208: Implement Trie (Prefix Tree)"
summary: "LeetCode 208 解題筆記：每個節點是 children 字典加一個 is_end 標記；insert、search、startsWith 都是沿著字元往下走"
description: "2022-10-29 的 LeetCode 208 解題紀錄"
date: 2022-10-29
tags: ["medium", "hash-table", "string", "design", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

Trie 的每個節點有 `children`（字元 → 子節點）和 `is_end`（是不是某個單字的結尾）（[Trie]({{< relref "/algorithm/Trie" >}})）。`insert` 沿著字元往下走，沒有的節點就建立，最後標記 `is_end`。`search` 走到最後還要檢查 `is_end`；`startsWith` 只要走得完就是 `True`。每個操作都是 `O(L)`，跟存了多少單字無關。

## 我的嘗試

當時寫的**根本不是 Trie**：用一個 list 存所有單字，`search` 用 `in`、`startsWith` 對每個單字呼叫 `startswith`，每次都是 `O(N · L)`。

- 第一版 `startsWith` 在迴圈裡**第一個單字不符合就回傳 `False`**，後面的單字都沒看：插入 `a`、`aba` 之後 `startsWith("ab")` 回傳 `False`。
- `search` 的 `else` 寫成 `False` 而沒有 `return`，找不到時回傳 `None`。

## 正確解法

```python
class Trie:
    def __init__(self):
        self.root = {}

    def insert(self, word: str) -> None:
        node = self.root
        for c in word:
            node = node.setdefault(c, {})
        node["#"] = True

    def _walk(self, s):
        node = self.root
        for c in s:
            if c not in node:
                return None
            node = node[c]
        return node

    def search(self, word: str) -> bool:
        node = self._walk(word)
        return node is not None and "#" in node

    def startsWith(self, prefix: str) -> bool:
        return self._walk(prefix) is not None
```

## 複雜度

每個操作 `O(L)`，空間是所有單字的總長度。

## 要特別避免的錯誤

- `search` 要檢查結尾標記，`app` 是 `apple` 的前綴但不一定是單字。
- 用 `"#"` 當結尾標記時，要確定它不會跟一般字元衝突（題目只有小寫字母）。

## 面試口說整理

Trie 的每個節點是一個子節點的字典加上結尾標記。insert 沿著字元往下走，沒有的節點就建立，最後打上標記；search 走完還要檢查標記；startsWith 只要走得完就成立。每個操作 `O(L)`。
