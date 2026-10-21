---
title: "LeetCode 417: Pacific Atlantic Water Flow"
summary: "LeetCode 417 解題筆記：反過來從海邊往內走，只能走到不比自己低的格子；兩個海都走得到的格子就是答案"
description: "2022-10-30 的 LeetCode 417 解題紀錄"
date: 2022-10-30
tags: ["medium", "array", "depth-first-search", "breadth-first-search", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-30
- 提交紀錄：Runtime Error ×4 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×5 → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error ×2 → Wrong Answer ×3 → Accepted ×2

## 解題思路

從每一格出發往下流去找海，最壞是 `O((mn)²)`。反過來（[BFS]({{< relref "/algorithm/BFS" >}}) 模板三，多源）：從太平洋的邊（第一列、第一欄）出發，**往不比自己低**的格子走，走得到的就是能流進太平洋的格子；大西洋（最後一列、最後一欄）同理。兩個集合的交集就是答案，每個海各 `O(mn)`。

## 我的嘗試

這題提交了 22 次：

- 下午先寫「每一格往下流找海」的 DFS，大西洋邊界的判斷把列數和欄數**對調**（`i == len(heights[0]) - 1`），非正方形時判斷錯誤；修好之後每一格都重新 DFS，TLE 了兩次。
- 晚上改成從海邊反著走，又錯在三個地方：條件寫成 `<= prev` 就停，**起點自己的高度等於 `prev`，一開始就被擋掉**（`[[1]]` 回傳 `[]`）；`visit.add([r, c])` 放了 list（TypeError）；最右邊那一欄放進了太平洋的集合。三個都改掉才 AC。

## 正確解法

```python
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        m, n = len(heights), len(heights[0])
        def reach(starts):
            seen = set(starts)
            stack = list(starts)
            while stack:
                i, j = stack.pop()
                for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)):
                    if (0 <= x < m and 0 <= y < n and (x, y) not in seen
                            and heights[x][y] >= heights[i][j]):
                        seen.add((x, y))
                        stack.append((x, y))
            return seen
        pacific = reach([(0, j) for j in range(n)] + [(i, 0) for i in range(m)])
        atlantic = reach([(m - 1, j) for j in range(n)] + [(i, n - 1) for i in range(m)])
        return [[i, j] for i, j in pacific & atlantic]
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`。

## 要特別避免的錯誤

- 反著走時條件是「不比自己低」（`>=`），一樣高也能流。
- 起點本身就在集合裡，不能被「比前一格高」的條件擋掉。
- 太平洋是第一列、第一欄；大西洋是最後一列、最後一欄，不要放錯集合。
- `set` 裡要放 tuple，list 不能 hash。

## 面試口說整理

從每一格往下找海太慢，所以我反過來，從兩個海的邊出發，往不比自己低的格子走，分別得到能流進太平洋和大西洋的格子，兩者的交集就是答案。每個海走一次，時間 `O(mn)`。
