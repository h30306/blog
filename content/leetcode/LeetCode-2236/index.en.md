---
title: "LeetCode 2236: Root Equals Sum of Children"
summary: "LeetCode 2236 note: a warm-up, plus practice with C++ pointer access"
description: "LeetCode 2236 record from 2025-12-17"
date: 2025-12-17
tags: ["easy", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-12-17
- Submissions: Python Accepted → C++ Compile Error → C++ Accepted

## Approach

The tree is guaranteed to have only a root and two children, so compare `root.val` with the sum of the two children.

## My Attempts

Python passed on the first try. The C++ rewrite first failed to compile because of a missing semicolon:

```cpp
return (root->left->val + root->right->val) == root->val    // missing ;
```

## Solution

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

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- In C++, access members through a pointer with `->`, not `.`.
- A C++ `return` statement needs a trailing semicolon.

## Interview Explanation

The tree always has exactly three nodes, so I compare the root value with the sum of its two children. Time and space are `O(1)`.
