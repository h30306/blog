---
title: "LeetCode 276: Paint Fence"
summary: "LeetCode 276 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-24 的 LeetCode 276 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-24
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-24
來源：Day 27 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 276 Paint Fence
- **Pattern:** counting DP with exact end-state relationship.

#### Why This Fits
The only thing that matters at the end of post `i` is:
```text
are the last 2 posts the same color or different colors?
```

That is a clean state split because the rule is:
```text
no more than 2 adjacent posts may have the same color
```

#### Core State / Invariant
```text
same = number of valid ways where the last 2 posts have the same color
diff = number of valid ways where the last 2 posts have different colors
```

#### Base Cases
For `n = 1`:
```text
answer = k
```

For the rolling 2-state view after processing the second post:
```text
same = k
diff = k * (k - 1)
```

Why:
- to make the last 2 the same, choose one color for both posts
- to make them different, choose first color in `k` ways and second in `k - 1` ways

#### Transition
If we add one more post:
```text
new_same = diff
new_diff = (same + diff) * (k - 1)
```

Why:
- `new_same`: the new post can only match the previous post if the previous 2 were different, otherwise 3 in a row would appear
- `new_diff`: from either previous state, choose any color different from the last color

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- memorizing `same/diff` formulas without explaining the legality rule
- forgetting that `same` cannot come from previous `same`
- mishandling `n = 1`
- using combinations language instead of exact state meaning

#### Strong Spoken Explanation
I split the count into 2 exact end states: valid paintings where the last 2 posts are the same, and valid paintings where the last 2 posts are different. That is enough because the constraint is only about avoiding 3 consecutive equal colors. If I want the new last 2 posts to be the same, the previous state must have ended in `diff`; otherwise I would create 3 equal posts in a row. If I want them different, I can come from either previous state and choose any of the `k - 1` colors that differ from the last post.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def numWays(self, n: int, k: int) -> int:
        if n == 1:
            return k
        same = k
        diff = k * (k - 1)
        for _ in range(3, n + 1):
            same, diff = diff, (same + diff) * (k - 1)
        return same + diff
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Allowing three adjacent posts with the same color.
- Forgetting n=1.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
