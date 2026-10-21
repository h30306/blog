---
title: "Hash Table 雜湊表"
summary: "計數與「次數的次數」、把陣列本身當雜湊表（負號標記）、多個 key 同時計數（列、欄、對角線）、固定左端點增量計數，以及用正規化後的 key 分組"
description: "演算法學習"
date: 2026-10-21
tags: ["hash-table", "counting", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

雜湊表讓「這個東西出現過嗎？出現幾次？」變成 `O(1)`。大部分題目只是把 `O(n)` 的線性搜尋換成雜湊表查詢，關鍵在於**選對 key**：

| 想法 | key 是什麼 | 例子 |
|---|---|---|
| 計數 | 值本身 | 次數能被 `k` 整除、只出現奇數次 |
| 次數的次數 | 出現次數 | 次數唯一的第一個元素 |
| 陣列本身當雜湊表 | `index = 值 - 1` | 第一個缺少的正整數、重複的數 |
| 多個 key | 列、欄、`r - c`、`r + c` | 燈照到哪些格子 |
| 正規化後的 key | 排序後的字串、前綴 | 異位詞、前 `k` 個字元相同 |

## 模板一：計數與次數的次數

```python
from collections import Counter

cnt = Counter(nums)                      # 值 -> 次數
freq_of_freq = Counter(cnt.values())     # 次數 -> 有幾個值是這個次數
for x in nums:                           # 由左到右找第一個
    if freq_of_freq[cnt[x]] == 1:
        return x
```

- **次數能被 `k` 整除的元素總和**（LC 3712）：`sum(x * c for x, c in cnt.items() if c % k == 0)`。
- **次數唯一的第一個元素**（LC 3843）：上面的程式。
- **開關燈泡**（LC 3842）：出現奇數次的會亮著，用集合切換或數奇偶都可以，最後要排序。
- **前 `k` 個字元相同的組數**（LC 3839）：key 是 `word[:k]`，長度不到 `k` 的字不能算。
- **用給的數字組三位偶數**（LC 2094）：反過來枚舉 100 到 998 的偶數，檢查每個數字需要的次數夠不夠。`Counter` 相減只留正數，`not (need - have)` 就是「夠用」。
- **範圍內缺少的數**（LC 3731）：先轉成集合，查詢才是 `O(1)`。

## 模板二：把陣列本身當雜湊表

值在 `[1, n]` 時，可以用 `nums[v - 1]` 的**正負號**記錄「`v` 出現過」，不用額外空間：

```python
for x in nums:
    i = abs(x) - 1                       # 值已經被改成負的，要取絕對值
    if nums[i] < 0:
        ...                              # i + 1 第二次出現
    else:
        nums[i] = -nums[i]
```

- **出現兩次的數**（LC 442）：上面的程式。
- **沒出現的數**（LC 448）：全部標記完，還是正的位置 `i` 代表 `i + 1` 沒出現。
- **第一個缺少的正整數**（LC 41）：答案一定在 `1..n + 1`。先把 `<= 0` 的值換成 `n + 1`（**不能換成 0**，0 加負號還是 0，沒辦法標記），再標記 `1..n`，第一個還是正的位置 `i` 就是答案 `i + 1`。

### 延伸：查補數、找起點、投票

- **Two Sum**（LC 1）：存「值 → index」，**先查 `target - x` 再存 `x`**，不會配到自己。
- **最長連續序列**（LC 128）：放進 set，只從 `x - 1` 不在 set 裡的起點往上數，`O(n)`。
- **多數元素**（LC 169、229）：Boyer-Moore 投票，不同的數互相抵消；超過 `n / 3` 時維護兩個候選人，最後要再數一次確認。

## 模板三：多個 key 同時計數

一盞燈會照亮它的列、欄、兩條對角線。四個方向各開一個計數器，同一條對角線上 `r - c` 相同、反對角線上 `r + c` 相同：

```python
row, col, diag, anti = Counter(), Counter(), Counter(), Counter()
on = set()
for r, c in lamps:
    if (r, c) not in on:                 # 同一盞燈可能重複出現
        on.add((r, c))
        row[r] += 1; col[c] += 1; diag[r - c] += 1; anti[r + c] += 1
lit = row[qr] or col[qc] or diag[qr - qc] or anti[qr + qc]   # 查詢 (qr, qc) 有沒有被照亮
```

關燈時四個計數器都要減，而且只對真的亮著的燈減（LC 1001）。

## 模板四：固定左端點，增量維護次數

`n` 不大時，固定左端點往右擴，每加一個數只更新 `O(1)` 個計數：

```python
for i in range(n):
    cnt, freq = {}, Counter()            # 值 -> 次數，次數 -> 個數
    for j in range(i, n):
        c = cnt.get(nums[j], 0)
        if c:
            freq[c] -= 1
            if freq[c] == 0:
                del freq[c]              # 刪掉才能用 len(freq) 判斷有幾種次數
        cnt[nums[j]] = c + 1
        freq[c + 1] += 1
```

- **次數只有 `f` 和 `2f` 兩種**（LC 3960）：`len(freq) == 2 and max(freq) == 2 * min(freq)`，或只有一種值。

## 模板五：正規化之後當 key

- **異位詞**（LC 2273）：`sorted(word)` 相同就是異位詞。題目一直刪掉「跟前一個是異位詞」的字，等於只保留跟前一個留下來的字不是異位詞的字。
- **自訂排序**（LC 3606）：先過濾合法的，再用 `(類別順序, code)` 當排序的 key。
- **分組**（LC 49）：`"".join(sorted(s))` 當 key，丟進 `defaultdict(list)`。不能用 `set(s)`：`"bb"` 和 `"b"` 的集合相同。
- **雙射**（LC 205、290）：`len(set(a)) == len(set(b)) == len(set(zip(a, b)))`。改用「第一次出現的 index」編碼時，數字之間要加分隔符號。

### 用 `Counter` 運算

| 寫法 | 意思 | 例子 |
|---|---|---|
| `not (Counter(a) - Counter(b))` | `b` 的每個字元都夠 `a` 用 | LC 383、1160、748 |
| `c1 & c2` | 每個字元取最小次數 | LC 1002 |
| `min(cnt[c] // need[c] for c in need)` | 最多能組幾份 | LC 1189 |

## 主要參數說明

- `Counter` 查詢不存在的 key 回傳 0，**不會**新增 key；`defaultdict` 查詢會新增。
- 次數減到 0 時要刪掉，才能用 `len()` 當作種類數。

## 複雜度

建表 `O(n)`，每次查詢平均 `O(1)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **在 list 上用 `in`**：每次 `O(n)`，整體 `O(n²)`，TLE（LC 442）。
- **用 0 當「不可能的值」**：0 加負號還是 0，沒辦法標記，而且全部都在時要回傳 `n + 1`（LC 41）。
- **複製貼上後計數器用錯**：查詢時用 `row_count[col]`、關燈時減 `row_count[nc]`，欄的計數一直沒對（LC 1001）。
- **判斷條件拿錯 key**：把「次數」拿去查「值 -> 次數」的表（LC 3960）。
- **重複數字的檢查用錯變數**：`j == k` 時要檢查 `counter[j]`，我寫成 `counter[i]`（LC 2094）。
- **忘了排序**：集合轉成 list 沒有順序（LC 3842）。
- **太短的字也算進去**：`word[:k]` 長度不到 `k` 時不能分組（LC 3839）。
- **字元範圍少一個**：`range(ord("a"), ord("z"))` 不包含 `z`；排序 key 的順序也寫反過（LC 3606）。
- **`d.get(x, 0) + 1` 沒有存回去**：表一直是空的（LC 242）。
- **只檢查次數的總和是 0**：正負會互相抵消，要檢查每一個（LC 242）。
- **`Counter` 相減的意思寫反**：差集不是空的代表「不夠」（LC 383）。
- **用 `set` 判斷 anagram 或共同字元**：會丟掉重複的次數（LC 49、1002）。
- **存和讀的 key 大小寫不一致**：存 `B`、查 `b`，永遠查不到（LC 748、3121）。
- **把 list 轉成 `set` 再找答案**：順序不見了，同長度時要回傳最前面的就做不到（LC 748）。
- **index 編碼沒有分隔符號**：`1` + `12` 和 `11` + `2` 都是 `112`（LC 205）。
- **先用原始次數篩選再除**：`l` 需要兩個時，要比較的是 `cnt // 2`（LC 1189）。
- **Two Sum 用 `nums.index(x)` 找 index**：相同的值會拿到同一個 index（LC 1）。
- **判斷條件寫反**：`len(set(nums)) == len(nums)` 是「沒有重複」（LC 217）；兩個上限要取 `min` 不是 `max`（LC 575）。
- **只拿 `most_common()[0]`**：次數最多的數可能不只一個（LC 697）。
- **剩下的數照次數排**：題目要由小到大，而且要保留重複的次數（LC 1122）。
- **list 當 dict 的 key**：要轉成 tuple，也要先正規化順序（LC 1128）。
- **排序找連續時長度直接覆蓋、沒處理重複**（LC 128）。
- **`round(n / 2)` 在 Python 3 是四捨六入五成雙**：取中間用 `n // 2`（LC 169）。

## 相關 LeetCode

- `LC 41` First Missing Positive
- `LC 442` Find All Duplicates in an Array
- `LC 1001` Grid Illumination
- `LC 3712` Sum of Elements With Frequency Divisible by K
- `LC 3843` First Element with Unique Frequency
- `LC 3960` Frequency Balance Subarray
- `LC 2094` Finding 3-Digit Even Numbers
- `LC 3731` Find Missing Elements
- `LC 3842` Toggle Light Bulbs
- `LC 3839` Number of Prefix Connected Groups
- `LC 3606` Coupon Code Validator
- `LC 2273` Find Resultant Array After Removing Anagrams
- `LC 594` Longest Harmonious Subsequence
- `LC 219` Contains Duplicate II
- `LC 187` Repeated DNA Sequences
- `LC 242` Valid Anagram
- `LC 49` Group Anagrams
- `LC 383` Ransom Note
- `LC 1189` Maximum Number of Balloons
- `LC 1160` Find Words That Can Be Formed by Characters
- `LC 1002` Find Common Characters
- `LC 771` Jewels and Stones
- `LC 884` Uncommon Words from Two Sentences
- `LC 819` Most Common Word
- `LC 409` Longest Palindrome
- `LC 3120` Count the Number of Special Characters I
- `LC 3121` Count the Number of Special Characters II
- `LC 748` Shortest Completing Word
- `LC 290` Word Pattern
- `LC 205` Isomorphic Strings
- `LC 1` Two Sum
- `LC 217` Contains Duplicate
- `LC 575` Distribute Candies
- `LC 169` Majority Element
- `LC 229` Majority Element II
- `LC 961` N-Repeated Element in Size 2N Array
- `LC 448` Find All Numbers Disappeared in an Array
- `LC 128` Longest Consecutive Sequence
- `LC 1122` Relative Sort Array
- `LC 697` Degree of an Array
- `LC 1128` Number of Equivalent Domino Pairs
