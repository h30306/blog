---
title: "LeetCode 1220: Count Vowels Permutation"
summary: "LeetCode 1220 解題筆記：狀態機 DP，狀態是最後一個母音；把「誰後面可以接誰」反過來寫成「誰可以接在誰後面」"
description: "2026-10-15 的 LeetCode 1220 解題紀錄"
date: 2026-10-15
tags: ["hard", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-15
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

狀態是「最後一個母音」，`a, e, i, o, u` 分別代表以它結尾的字串數。題目給的是「`x` 後面只能接誰」，寫成轉移時要反過來看「`x` 前面可以是誰」：

| 結尾 | 前一個可以是 |
|---|---|
| `a` | `e`、`i`、`u` |
| `e` | `a`、`i` |
| `i` | `e`、`o` |
| `o` | `i` |
| `u` | `i`、`o` |

長度 1 時每個都是 1，跑 `n - 1` 次轉移。

## 我的嘗試

1. **第一版**：模數寫成 `10 % 9 + 7`（等於 8），應該是 `10 ** 9 + 7`；最後的加總也沒取模。例如 `n = 5`：答案是 68，回傳 20。
2. **第二版**：補上最後的取模，但模數還是 8。例如 `n = 2`：答案是 10，回傳 `10 % 8 = 2`。
3. 改成 `10 ** 9 + 7` 就 AC 了。

## 正確解法

```python
class Solution:
    def countVowelPermutation(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        a = e = i = o = u = 1
        for _ in range(n - 1):
            a, e, i, o, u = (
                (e + i + u) % MOD,                 # 前一個可以是 e、i、u
                (a + i) % MOD,
                (e + o) % MOD,
                i % MOD,
                (i + o) % MOD,
            )
        return (a + e + i + o + u) % MOD
```

用同時賦值就不用另外存 `prev_a` 這些變數。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `10 % 9 + 7` 跟 `10 ** 9 + 7` 只差一個字元，小測資會過、大測資才錯。
- 規則是「`x` 後面接誰」，轉移要反過來寫。

## 面試口說整理

狀態是最後一個母音，五個變數分別代表以它結尾的字串數。題目給的是誰後面能接誰，我把它反過來，算每個母音前面可以是誰，每一步同時更新五個值，最後加總取模。時間 `O(n)`。
