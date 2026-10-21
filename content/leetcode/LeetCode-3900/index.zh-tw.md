---
title: "LeetCode 3900: Longest Balanced Substring After One Swap"
summary: "LeetCode 3900 解題筆記：前綴差值相同就平衡；差 2 的子字串只要外面有可以換進來的字元也行，每個差值記最早的兩個位置就夠"
description: "2026-04-12 的 LeetCode 3900 解題紀錄"
date: 2026-04-12
tags: ["medium", "prefix-sum", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-12
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

令 `d[p]` 是前 `p` 個字元的 `ones - zeros`。子字串 `s[q:p]` 平衡就是 `d[p] == d[q]`（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板三）。

交換一次可以把子字串裡的一個 1 換成外面的一個 0（或反過來），差值改變 2：

- `d[p] - d[q] == 2`（多兩個 1）：需要子字串**外面**還有 0，也就是 `子字串裡的 0 < 全部的 0`。
- `d[p] - d[q] == -2`（多兩個 0）：需要外面還有 1。

要最長，就要最早的 `q`。如果最早的 `q` 不合格（全部的 0 都在子字串裡），第二早的 `q'` 一定合格：`s[q:q']` 的差值是 0，長度至少 2，裡面至少有一個 0，這個 0 移到子字串外面了。所以每個差值只要記**最早的兩個**位置。

## 我的嘗試

前三版都用滑動視窗，想辦法讓視窗「差最多 2，而且旁邊有字元可以換」：

1. 第一版縮視窗的條件不完整，連奇數長度的視窗都算進答案。例如 `"001"`：答案是 2，回傳 3。
2. 第二版只看右邊還有沒有可以換的字元，把本來就平衡的視窗縮掉了。例如 `"000111"`：整個字串就平衡，答案 6，回傳 4。
3. 第三版用 `max(count) × 2` 當長度，等於假設一次交換能補任何差距。例如 `"0011111100"`：答案 6，回傳 8。

平衡不是單調的條件，視窗縮小不一定變好，所以改成前綴差值 + 雜湊表就 AC 了。

## 正確解法

```python
class Solution:
    def longestBalanced(self, s: str) -> int:
        total0, total1 = s.count("0"), s.count("1")
        first = {0: [0]}                       # 差值 -> 最早的兩個前綴長度
        zeros = [0]                            # zeros[p]：s[:p] 裡 0 的個數
        d = best = 0
        for p, ch in enumerate(s, 1):
            d += 1 if ch == "1" else -1
            zeros.append(zeros[-1] + (ch == "0"))
            if d in first:                     # 本來就平衡
                best = max(best, p - first[d][0])
            for q in first.get(d - 2, ()):     # 多兩個 1：外面要有 0
                if zeros[p] - zeros[q] < total0:
                    best = max(best, p - q)
                    break
            for q in first.get(d + 2, ()):     # 多兩個 0：外面要有 1
                if (p - q) - (zeros[p] - zeros[q]) < total1:
                    best = max(best, p - q)
                    break
            pos = first.setdefault(d, [])
            if len(pos) < 2:
                pos.append(p)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 平衡條件不單調，不要用滑動視窗。
- 一次交換只能修正差 2 的子字串，而且外面要有能換進來的字元。

## 面試口說整理

我用前綴的 `ones - zeros`，差值相同的兩個位置之間就平衡。交換一次可以修正差 2 的子字串，只要外面還有對應的字元。要最長就找最早的位置；最早的不行時第二早的一定行，所以每個差值記兩個位置就好。時間 `O(n)`。
