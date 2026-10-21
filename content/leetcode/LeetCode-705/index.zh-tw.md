---
title: "LeetCode 705: Design HashSet"
summary: "LeetCode 705 解題筆記：固定數量的桶子，key 對桶子數取餘數決定放哪一桶，每個桶子用 list 處理碰撞"
description: "2022-08-31 的 LeetCode 705 解題紀錄"
date: 2022-08-31
tags: ["easy", "array", "hash-table", "linked-list", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-31
- 提交紀錄：Runtime Error ×2 → Accepted

## 解題思路

題目要自己實作，不能直接用內建的 `set`。最基本的雜湊表（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})、[Linked List]({{< relref "/algorithm/Linked-List" >}})「其他」）：

- 開固定數量的桶子（選一個質數，例如 1009，讓 key 分得比較平均）。
- `key % 桶子數` 決定放哪一桶。
- 不同的 key 可能落在同一桶（碰撞），每個桶子用一個 list 存，操作時在那一桶裡找。

## 我的嘗試

我當時其實是包了一層內建的 `set`：第一版的 `remove` 呼叫到自己（無限遞迴）；第二版用 `set.remove`，刪不存在的 key 時 KeyError；第三版改成 `discard` 才過。這裡改成真的自己實作的版本。

## 正確解法

```python
class MyHashSet:
    def __init__(self):
        self.size = 1009
        self.buckets = [[] for _ in range(self.size)]

    def add(self, key: int) -> None:
        b = self.buckets[key % self.size]
        if key not in b:
            b.append(key)

    def remove(self, key: int) -> None:
        b = self.buckets[key % self.size]
        if key in b:
            b.remove(key)

    def contains(self, key: int) -> bool:
        return key in self.buckets[key % self.size]
```

## 複雜度

每個操作平均 `O(n / 桶子數)`，空間 `O(桶子數 + n)`。

## 要特別避免的錯誤

- 刪除不存在的 key 不能報錯。
- 桶子數用質數，key 比較不會集中在少數桶子。

## 面試口說整理

我開固定數量的桶子，用 key 對桶子數取餘數決定位置，每個桶子用 list 處理碰撞，加入前先檢查是否已存在、刪除前先檢查是否存在。平均每次操作是 `O(n / 桶子數)`。
