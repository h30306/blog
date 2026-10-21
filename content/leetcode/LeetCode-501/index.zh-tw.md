---
title: "LeetCode 501: Find Mode in Binary Search Tree"
summary: "LeetCode 501 解題筆記：BST 中序是排序的，相同的值會連在一起；中序時數目前這段的長度，比最大值大就重設答案，一樣大就加入"
description: "2022-08-25 的 LeetCode 501 解題紀錄"
date: 2022-08-25
tags: ["easy", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Accepted ×2 → Runtime Error → Accepted ×3 → Runtime Error → Accepted → Runtime Error → Accepted ×7 → Runtime Error ×10 → Wrong Answer ×3 → Accepted ×2

## 解題思路

題目的 BST 允許重複值（左 `<=` 根 `<=` 右），中序遍歷是排序的，**相同的值一定連在一起**（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。中序走的時候記住前一個值和目前這段的長度：

- 跟前一個一樣就長度加 1，否則重設成 1。
- 長度超過目前的最大值：答案重設成只有這個值。
- 長度等於最大值：把這個值加進答案。

除了答案和遞迴，不用額外的雜湊表。

## 我的嘗試

這題提交了 31 次。前面十幾次都是在寫「中序遍歷 + 計數」時的各種錯（變數沒定義、對 `None` 取值、遞迴沒有結束條件），後來先用 `Counter` 數完再挑最大的 AC；之後又練了不用雜湊表的寫法，在初始化上錯了幾次，例如只有一個節點 `[4]` 回傳 `[0]`。

## 正確解法

```python
class Solution:
    def findMode(self, root: Optional[TreeNode]) -> List[int]:
        res, best, run, prev = [], 0, 0, None
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            run = run + 1 if cur.val == prev else 1
            prev = cur.val
            if run > best:
                best, res = run, [cur.val]
            elif run == best:
                res.append(cur.val)
            cur = cur.right
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(h)`（不算輸出）。

## 要特別避免的錯誤

- 「前一個值」的初始值要用 `None`，用 0 的話第一個節點剛好是 0 時會被當成重複。

## 面試口說整理

BST 中序是排序的，同樣的值會連在一起，所以我中序遍歷時數目前這段相同值的長度，比最大值長就重設答案，一樣長就加進答案。只走一次，時間 `O(n)`。
