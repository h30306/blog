---
title: "LeetCode 93: Restore IP Addresses"
summary: "LeetCode 93 解題筆記：切成剛好 4 段，每段長度 1 到 3、值在 0 到 255、除了 0 本身不能有前導零"
description: "2022-11-05 的 LeetCode 93 解題紀錄"
date: 2022-11-05
tags: ["medium", "string", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-05
- 提交紀錄：Accepted ×2

## 解題思路

切割型回溯（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化五）：每一層切出 1 到 3 個字元，合法的條件是 `0 <= int(piece) <= 255` 而且 `piece == "0" or piece[0] != "0"`。切滿 4 段時剛好用完字串才記錄。剪枝：剩下的字元數要在 `剩下段數 × 1` 到 `剩下段數 × 3` 之間。

## 我的嘗試

兩次提交都 AC（2022-11），第一次的寫法沒有限制每段最多 3 個字元，靠 `int(piece) < 256` 擋掉太長的片段，也沒有用剩餘長度剪枝。

## 正確解法

```python
class Solution:
    def restoreIpAddresses(self, s: str) -> List[str]:
        res, path = [], []
        def dfs(start):
            left = 4 - len(path)
            if left == 0:
                if start == len(s):
                    res.append(".".join(path))
                return
            if not left <= len(s) - start <= 3 * left:
                return
            for end in range(start + 1, min(start + 3, len(s)) + 1):
                piece = s[start:end]
                if (piece == "0" or piece[0] != "0") and int(piece) <= 255:
                    path.append(piece)
                    dfs(end)
                    path.pop()
        dfs(0)
        return res
```

## 複雜度

時間 `O(3^4)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 前導零：`"01"` 不合法，但 `"0"` 合法。
- 必須剛好 4 段，而且用完整個字串。

## 面試口說整理

我用切割型的回溯，每段切 1 到 3 個字元，值不超過 255、除了 0 本身不能有前導零，切滿四段剛好用完字串就記錄；剩下的長度不可能分完時就剪掉。
