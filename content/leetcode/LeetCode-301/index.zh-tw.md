---
title: "LeetCode 301: Remove Invalid Parentheses"
summary: "LeetCode 301 解題筆記：先算出最少要刪幾個左右括號再回溯；或用 BFS 一層刪一個，第一個出現合法字串的層就是答案"
description: "2026-09-10 的 LeetCode 301 解題紀錄"
date: 2026-09-10
tags: ["hard", "backtracking", "bfs", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-10
- 提交紀錄：Time Limit Exceeded → Accepted ×2（回溯）→ Accepted ×2（BFS）

## 解題思路

要刪掉**最少**的括號讓字串合法，並回傳所有可能的結果。

### 第一步：算出最少要刪幾個

從左到右掃，用一個計數器記錄「還沒配對的 `(`」：

- 遇到 `(`：計數加 1。
- 遇到 `)`：有未配對的 `(` 就配對，計數減 1；沒有的話，這個 `)` 一定要刪，`r_rem += 1`。
- 掃完之後，剩下的未配對 `(` 數量就是 `l_rem`。

### 第二步：回溯，只允許刪 `l_rem` 個 `(` 和 `r_rem` 個 `)`

對每個括號有「刪」和「留」兩種選擇：

- 刪：只有對應的額度還有剩才能刪。
- 留 `)`：只有目前左括號比右括號多才能留，不然字串前綴就已經不合法。

走到結尾時，額度剛好用完就是一個答案。用 set 去重。

## 我的嘗試：沒有限制刪除數量，TLE

第一版對每個字元都試「刪」和「留」，走到結尾才比較誰刪得最少。這等於枚舉所有 `2^n` 個子序列，`n = 25` 時太慢。

先算出 `l_rem`、`r_rem`，就能把不可能是最少刪除數的分支提早剪掉。

## 解法一：回溯 + 刪除額度

```python
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        l_rem = r_rem = 0
        for ch in s:
            if ch == "(":
                l_rem += 1
            elif ch == ")":
                if l_rem > 0:
                    l_rem -= 1
                else:
                    r_rem += 1

        n = len(s)
        res = set()

        def backtrack(i: int, cur: str, open_count: int, l_rem: int, r_rem: int) -> None:
            if i == n:
                if l_rem == 0 and r_rem == 0:
                    res.add(cur)
                return
            ch = s[i]
            if ch == "(" and l_rem > 0:
                backtrack(i + 1, cur, open_count, l_rem - 1, r_rem)        # 刪
            if ch == ")" and r_rem > 0:
                backtrack(i + 1, cur, open_count, l_rem, r_rem - 1)        # 刪
            if ch == "(":
                backtrack(i + 1, cur + ch, open_count + 1, l_rem, r_rem)   # 留
            elif ch == ")":
                if open_count > 0:
                    backtrack(i + 1, cur + ch, open_count - 1, l_rem, r_rem)
            else:
                backtrack(i + 1, cur + ch, open_count, l_rem, r_rem)

        backtrack(0, "", 0, l_rem, r_rem)
        return list(res)
```

`open_count` 是目前「留下的 `(` 減掉留下的 `)`」，原本的版本用兩個計數器 `l_count`、`r_count`，意思一樣。

## 解法二：BFS，一層刪一個括號

```python
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        def is_valid(t: str) -> bool:
            count = 0
            for ch in t:
                if ch == "(":
                    count += 1
                elif ch == ")":
                    count -= 1
                    if count < 0:
                        return False
            return count == 0

        level = {s}
        while level:
            valid = [t for t in level if is_valid(t)]
            if valid:
                return valid
            level = {t[:i] + t[i + 1:] for t in level for i in range(len(t)) if t[i] in "()"}
        return [""]
```

第 `k` 層是「刪掉 `k` 個括號的所有字串」，第一個出現合法字串的層就是最少刪除數。這版跑得比回溯快很多（61ms 對 1356ms），因為最少刪除數通常很小，BFS 很早就停了。

## 複雜度

兩種做法最壞都是指數級，`O(2^n · n)`。實際上回溯靠額度剪枝，BFS 靠提早停止。

## 要特別避免的錯誤

- 沒有先算出最少刪除數，就枚舉所有子序列。
- 留下 `)` 時沒有檢查前綴是否還合法。
- 沒有去重：刪掉相鄰的同一種括號會得到同樣的字串。

## 面試口說整理

我先掃一次算出最少要刪幾個 `(` 和幾個 `)`：多出來的 `)` 一定要刪，最後沒配對的 `(` 也要刪。接著回溯，每個括號可以刪（額度還有剩時）或留（留 `)` 時前面要有未配對的 `(`），走到結尾額度剛好用完就加入答案，用 set 去重。另一種做法是 BFS 每層刪一個括號，第一個出現合法字串的層就是答案。
