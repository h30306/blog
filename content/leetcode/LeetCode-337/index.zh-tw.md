---
title: "LeetCode 337: House Robber III"
summary: "LeetCode 337 解題筆記：樹上 DP，每個節點回傳（搶它、不搶它）的最大值；不是一層一層交錯搶"
description: "2022-11-16 的 LeetCode 337 解題紀錄"
date: 2022-11-16
tags: ["medium", "dynamic-programming", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×2
- 2026-10-30 重寫：Wrong Answer → Time Limit Exceeded → Accepted ×2

## 解題思路

不能搶相鄰（父子）的兩個節點。每個節點回傳兩個值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板七）：

- `rob`：搶這個節點，小孩都不能搶：`val + 左.skip + 右.skip`。
- `skip`：不搶它，小孩可搶可不搶，各自取較大的：`max(左) + max(右)`。

根的答案是兩者較大的。

## 我的嘗試

第一版用「奇數層全搶或偶數層全搶」，但最好的組合可能跳過連續兩層。例如 `[1, 2, 3, 8]`：搶 8 和 3 是 11，奇偶層的做法只得到 9。之後改成遞迴時，一版沒有回傳值，一版對 tuple 做了錯的運算（TypeError）。

## 正確解法

```python
class Solution:
    def rob(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return 0, 0                          # (搶它, 不搶它)
            lr, ls = dfs(node.left)
            rr, rs = dfs(node.right)
            return node.val + ls + rs, max(lr, ls) + max(rr, rs)
        return max(dfs(root))
```

## 2026-10 重寫

這次先寫「帶狀態的遞迴」，再改成上面的回傳兩個值：

1. `dfs(node, rob)`：`rob` 表示父節點有沒有被搶。最後 `return` 後面忘了寫東西，回傳 `None`。
2. 補上 `dfs(root, False)`，答案對了但 **TLE**：沒有記憶化，搶和不搶兩條分支往下都會再呼叫小孩，同一個 `(節點, 狀態)` 被重算很多次，次數隨深度指數成長。
3. 加 `@cache` 就過了。`TreeNode` 預設用物件身分做 hash，所以可以直接當 key。
4. 再寫成上面的版本：每個節點回傳 `[不搶, 搶]`，`搶 = val + 左[0] + 右[0]`、`不搶 = max(左) + max(右)`，只走一次，也過了。

第 4 版就是把第 3 版的 cache 拿掉，改成一次回傳兩種狀態，空間從 `O(n)` 的 cache 變成只有遞迴深度 `O(h)`。

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 不能只算奇數層和偶數層的總和：最好的組合可能跳過連續兩層。

## 面試口說整理

這是樹上 DP：每個節點回傳搶它和不搶它的最大值。搶它就不能搶小孩，不搶它的話小孩各自取較好的選擇，最後根取兩者較大的。時間 `O(n)`。
