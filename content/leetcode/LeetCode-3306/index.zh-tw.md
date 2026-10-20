---
title: "LeetCode 3306: Count of Substrings Containing Every Vowel and K Consonants II"
summary: "LeetCode 3306 解題筆記：「剛好 k 個子音」不單調；改成「五個母音都有且子音至少 k 個」減「至少 k + 1 個」，兩個都是「至少」型的計數視窗"
description: "2026-01-21 的 LeetCode 3306 解題紀錄"
date: 2026-01-21
tags: ["medium", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-21
- 提交紀錄：Wrong Answer ×2 → Accepted → Runtime Error → Accepted

## 解題思路

「剛好 `k` 個子音」不單調。但「五個母音都有、子音**至少** `m` 個」是單調的（視窗變大只會更容易滿足），所以：

```text
剛好 k 個 = 至少 k 個 − 至少 k + 1 個
```

「至少」型的計數：合法時一直縮左邊，縮到不合法，`count += left`。

## 我的嘗試

我的寫法是另一種思路：子音數固定是 `k` 的時候，左邊多出來的母音可以拿掉也可以留著，用 `extra` 記錄「左邊還可以多拿掉幾個母音」，每個右端加 `1 + extra`。

| 版本 | 問題 |
|---|---|
| 第一版 | 每個右端只加 1，沒算左邊可以多放的母音。例如 `word = "euioeaa"`、`k = 0`：答案是 4，回傳 2 |
| 第二版 | 加上 `extra`，但它是每一輪重新從 0 開始的區域變數。左邊的多餘母音在前幾輪已經被拿掉了，這輪就算不到。同一個例子回傳 3 |
| AC | `extra` 移到迴圈外，只在子音太多、必須縮掉子音時才歸零 |
| RE | 重寫時把 `extra = 0` 放在縮子音的迴圈裡，沒縮的時候 `extra` 根本沒定義，UnboundLocalError |
| AC | 初始化移回迴圈外 |

`extra` 的做法是對的，但要想清楚什麼時候歸零；「至少」相減的做法不需要額外狀態。

## 正確解法

```python
class Solution:
    def countOfSubstrings(self, word: str, k: int) -> int:
        def at_least(m: int) -> int:               # 五個母音都有、子音至少 m 個
            vowels = Counter()
            consonants = left = count = 0
            for c in word:
                if c in "aeiou":
                    vowels[c] += 1
                else:
                    consonants += 1
                while len(vowels) == 5 and consonants >= m:
                    d = word[left]
                    if d in "aeiou":
                        vowels[d] -= 1
                        if vowels[d] == 0:
                            del vowels[d]
                    else:
                        consonants -= 1
                    left += 1
                count += left
            return count

        return at_least(k) - at_least(k + 1)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 「剛好」直接滑：不單調，左邊多餘的母音會漏算。
- 用 `extra` 的寫法時，它只能在子音被移出時歸零。

## 面試口說整理

「剛好 `k` 個子音」不單調，所以我改成「至少 `k` 個」減「至少 `k + 1` 個」。「五個母音都有而且子音至少 `m` 個」是單調的，用「至少」型的滑動視窗：合法時一直縮左邊，左端在 0 到 `left - 1` 都合法，加上 `left`。時間 `O(n)`。
