---
title: "Trie 字典樹"
summary: "用巢狀 dict 建 Trie、在節點上記數量、搭配 DFS 搜尋，以及什麼時候其實不需要 Trie"
description: "演算法學習"
date: 2026-10-20
tags: ["trie", "string", "prefix", "bit-manipulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Trie（字典樹、前綴樹）把一堆字串的**共同前綴合併在一起**。從根節點往下走，每條邊是一個字元，走到的節點就代表一個前綴。

辨識訊號：

- 大量字串要反覆做「前綴」相關的查詢：某個前綴出現幾次、有沒有以它開頭的單字。
- 在網格或字串上同時找很多個單字：用 Trie 一次比對所有單字，而不是每個單字各搜一次。

## 模板一：用巢狀 dict 建 Trie

Python 最簡單的寫法是每個節點都是一個 dict：

```python
root = {}
for word in words:
    node = root
    for ch in word:
        node = node.setdefault(ch, {})
    node["$"] = word                  # 結尾標記，順便存整個單字
```

### 主要參數說明：

- `setdefault(ch, {})`：子節點不存在就建立，然後回傳它。
- `"$"`：結尾標記。存整個單字的好處是找到時不用再從路徑組回來（LC 212）。
- 也可以用 class `TrieNode` 搭配 `children` 和 `is_end`，面試時比較清楚，但程式碼比較長。

## 模板二：在節點上記錄經過的次數

如果要知道「有幾個單字以這個前綴開頭」，就在每個節點記一個計數：

```python
trie = {}
for word in words:
    node = trie
    for ch in word:
        if ch not in node:
            node[ch] = [0, {}]        # [經過次數, 子節點]
        node[ch][0] += 1
        node = node[ch][1]
```

查詢某個單字所有前綴的分數總和（LC 2416），就是沿路把計數加起來。

## 模板三：Trie + 網格 DFS

在網格上找很多單字時，DFS 的時候同時在 Trie 上往下走，**Trie 裡沒有的方向就不用走**：

```python
def dfs(r, c, parent):
    ch = board[r][c]
    node = parent[ch]
    if "$" in node:
        res.append(node.pop("$"))     # 找到後移除，避免重複
    board[r][c] = "#"
    for 四個方向的 (nr, nc):
        if 在範圍內 and board[nr][nc] in node:
            dfs(nr, nc, node)
    board[r][c] = ch
    if not node:
        parent.pop(ch)                # 這個分支已經沒有單字了，剪掉
```

找到的單字從 Trie 移除，空的節點也一起刪掉，之後的搜尋就不會再走進這些死路。

## 什麼時候不需要 Trie

LeetCode 把一些題目標成 Trie，但其實有更簡單的做法：

| 題目 | 更簡單的做法 |
|---|---|
| LC 1023 Camelcase Matching | 每個 query 和 pattern 用**雙指針**比對，大寫字母必須對上 |
| LC 1178 Number of Valid Words | 單字只在乎「用到哪些字母」，轉成 **26-bit 遮罩**，再枚舉謎題遮罩的子集合 |

判斷方式：如果查詢只跟「字母的集合」有關，不在乎順序，通常用位元遮罩更好。

## 複雜度

- 建 Trie：`O(所有單字的總長度)`。
- 查詢一個長度 `L` 的字串：`O(L)`。
- 空間：最壞是 `O(總長度 × 字母表大小)`；用 dict 只存實際出現的子節點，通常小很多。

## 常見錯誤

- 用 class 實作時每個節點都開 26 格的陣列：單字少但字母分散時很浪費記憶體。
- Trie + DFS 找到單字後沒有移除結尾標記：同一個單字會被重複加入答案。
- 為了用 Trie 而用 Trie：只在乎字母集合的題目，位元遮罩更快。

## 相關 LeetCode

- `LC 212` Word Search II
- `LC 2416` Sum of Prefix Scores of Strings
- `LC 1023` Camelcase Matching
- `LC 1178` Number of Valid Words for Each Puzzle
- `LC 208` Implement Trie (Prefix Tree)
