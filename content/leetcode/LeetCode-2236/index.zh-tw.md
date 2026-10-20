---
title: "LeetCode 2236: Root Equals Sum of Children"
summary: "LeetCode 2236 解題筆記：暖身題，順便練 C++ 的指標存取"
description: "2025-12-17 的 LeetCode 2236 解題紀錄"
date: 2025-12-17
tags: ["easy", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-17
- 提交紀錄：Python Accepted → C++ Compile Error → C++ Accepted

## 解題思路

題目保證只有根和兩個子節點，直接比較 `root.val` 和兩個子節點的和就好。

## 我的嘗試

Python 一次通過。接著用 C++ 再寫一次，第一次少了分號，出現 Compile Error：

```cpp
return (root->left->val + root->right->val) == root->val    // 少了 ;
```

## 正確解法

```python
class Solution:
    def checkTree(self, root: Optional[TreeNode]) -> bool:
        return root.val == root.left.val + root.right.val
```

```cpp
class Solution {
public:
    bool checkTree(TreeNode* root) {
        return root->val == root->left->val + root->right->val;
    }
};
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- C++ 存取指標的成員要用 `->`，不是 `.`。
- C++ 的 `return` 敘述結尾要有分號。

## 面試口說整理

題目保證樹只有三個節點，所以直接比較根的值和兩個子節點值的和，時間和空間都是 `O(1)`。
