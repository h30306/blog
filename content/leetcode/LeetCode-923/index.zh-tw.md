---
title: "LeetCode 923: 3Sum With Multiplicity"
summary: "LeetCode 923 解題筆記：排序後固定第一個數、對撞指針找另外兩個；兩端值相同時用組合數一次算完，不同時把兩端各自的重複數相乘"
description: "2026-01-24 的 LeetCode 923 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "sorting", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：WA → AC（計數版）→ WA ×4 → AC（雙指針版）→ WA

## 解題思路

先用計數版 AC，再用雙指針重寫一次。

### 雙指針

排序後固定 `i`，在 `[i + 1, n - 1]` 用對撞指針 `j`、`k` 找 `arr[j] + arr[k] == target - arr[i]`。找到時有兩種情況：

- **`arr[j] == arr[k]`**：`j..k` 之間全部是同一個值，任選兩個都行，共 `m(m - 1) / 2` 種（`m = k - j + 1`），算完直接結束這個 `i`。
- **`arr[j] != arr[k]`**：分別數左邊有幾個跟 `arr[j]` 一樣、右邊有幾個跟 `arr[k]` 一樣，相乘，兩個指針再越過這些重複值。

### 計數

值只有 `0..100`，可以直接枚舉值 `a <= b <= c`，用 `Counter` 算組合數：三個相同是 `C(cnt, 3)`，兩個相同是 `C(cnt, 2) × 另一個的數量`，都不同是三個數量相乘。

## 我的嘗試

這題的錯大多是細節：

| 版本 | 問題 |
|---|---|
| 計數版 WA | 忘了取模。例如 3000 個 0、`target = 0`：答案是 `C(3000, 3) mod (10^9 + 7) = 495500972`，這版回傳 `4495501000` |
| 雙指針第一版 WA | 兩種情況寫反了（值相同時去數兩邊重複數，值不同時才用組合數），還把 `ans +=` 寫成 `ans =`（這版也還沒排序）。例如 `[1, 1, 1, 1]`、`target = 3`：答案是 4，這版回傳 3 |
| 第二版 WA | 修好分支，但**沒有排序**，對撞指針的前提不成立。例如 `[4, 4, 0, 4, 0, 1, 1]`、`target = 4`：答案是 3，這版回傳 4 |
| 第三版 WA | 補上排序，但沒有取模，大測資一樣錯 |
| 第四版 WA | 把 `% MOD` 寫成 `* MOD` |
| 最後一次 WA | 已經 AC 後又送了一次沒排序的版本 |

## 正確解法

```python
class Solution:
    def threeSumMulti(self, arr: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        arr.sort()
        n = len(arr)
        ans = 0
        for i in range(n - 2):
            j, k = i + 1, n - 1
            while j < k:
                s = arr[i] + arr[j] + arr[k]
                if s < target:
                    j += 1
                elif s > target:
                    k -= 1
                elif arr[j] == arr[k]:
                    m = k - j + 1                  # j..k 全部相同
                    ans += m * (m - 1) // 2
                    break
                else:
                    cnt_j = cnt_k = 1
                    while j + 1 < k and arr[j + 1] == arr[j]:
                        j += 1
                        cnt_j += 1
                    while k - 1 > j and arr[k - 1] == arr[k]:
                        k -= 1
                        cnt_k += 1
                    ans += cnt_j * cnt_k
                    j += 1
                    k -= 1
        return ans % MOD
```

計數版：

```python
class Solution:
    def threeSumMulti(self, arr: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        cnt = Counter(arr)
        ans = 0
        for a in range(101):
            for b in range(a, 101):
                c = target - a - b
                if c < b or c > 100:
                    continue
                if a == b == c:
                    ans += cnt[a] * (cnt[a] - 1) * (cnt[a] - 2) // 6
                elif a == b:
                    ans += cnt[a] * (cnt[a] - 1) // 2 * cnt[c]
                elif b == c:
                    ans += cnt[a] * cnt[b] * (cnt[b] - 1) // 2
                else:
                    ans += cnt[a] * cnt[b] * cnt[c]
        return ans % MOD
```

## 複雜度

- 雙指針：時間 `O(n^2)`，空間 `O(1)`（不算排序）。
- 計數：時間 `O(n + V^2)`，`V = 101`，空間 `O(V)`。

## 要特別避免的錯誤

- 對撞指針之前忘了排序。
- 忘了取模，或寫成 `* MOD`。
- 兩端值相同時，不能用「左邊重複數 × 右邊重複數」，要用組合數。

## 面試口說整理

我排序後固定第一個數，用對撞指針找另外兩個。總和剛好時，如果兩端值一樣，中間全部是同一個值，用 `m(m - 1) / 2` 一次算完；不一樣就分別數兩端的重複數相乘，再一起越過。時間 `O(n^2)`。因為值只有 0 到 100，也可以用計數陣列枚舉值，用組合數算，時間 `O(n + 101^2)`。
