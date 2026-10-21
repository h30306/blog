---
title: "String 字串處理"
summary: "用 list 組字串的模擬、在每個位置嘗試比對的解析、長度 k 的所有子字串、字元分類計數，以及固定起點的平衡子字串判斷"
description: "演算法學習"
date: 2026-10-21
tags: ["string", "simulation", "hash-table"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

字串題大多不需要特別的演算法，難的是**細節**：index 的邊界、操作的先後順序、Python 字串不可變。幾個固定的寫法：

| 形式 | 做法 | 例子 |
|---|---|---|
| 模擬 | 用 list 當 stack 組結果，最後 `join` | 特殊字元操作、合併相近字元 |
| 解析 | 每個位置嘗試比對所有 pattern，比對到就跳過 | HTML entity |
| 長度 `k` 的子字串 | 枚舉起點，丟進集合 | 所有二進位碼、三個相同數字 |
| 字元分類 | 母音 / 子音 / 數字分開計數 | 最多的母音和子音、母音排序 |
| 固定起點往右擴 | 增量維護計數 | 每種字元次數相同 |

字串上的 DP（LCS、編輯距離）見 [String DP]({{< relref "/algorithm/String-DP" >}})。

## 模板一：用 list 模擬

Python 字串不可變，`s += c` 每次都會複製。用 list 當結果，最後再 `"".join`：

```python
res = []
for ch in s:
    if ch == "*":
        if res:                          # 判斷寫在裡面，不要寫成 ch == "*" and res
            res.pop()
    elif ch == "#":
        res += res
    elif ch == "%":
        res.reverse()
    else:
        res.append(ch)
return "".join(res)
```

- **特殊字元操作**（LC 3612）：上面的程式。
- **合併相近的相同字元**（LC 4019）：保留下來的字不會再變，所以只要記每種字元**在結果裡**最後的位置，新字元跟它的距離 `<= k` 就丟掉。
- **最大的偶數**（LC 3798）：把結尾的 1 一直刪掉。

## 模板二：在每個位置嘗試比對

```python
i, out = 0, []
while i < len(text):
    for pattern, rep in table.items():
        if text.startswith(pattern, i):  # 不會超出範圍
            out.append(rep)
            i += len(pattern)
            break
    else:
        out.append(text[i])
        i += 1
```

- **HTML entity**（LC 1410）：不能用一連串的 `replace`：先換出來的 `&` 會跟後面的字組成新的 entity。

## 模板三：長度 `k` 的所有子字串

```python
seen = {s[i:i + k] for i in range(len(s) - k + 1)}   # 最後一個起點是 len(s) - k
```

- **所有長度 `k` 的二進位碼**（LC 1461）：集合大小要是 `2^k`；子字串數量 `len(s) - k + 1` 不到 `2^k` 就一定不夠。
- **三個相同的數字**（LC 2264）：只有 10 種候選，從 `"999"` 往下檢查 `in num`。

## 模板四：字元分類計數

```python
vowels = set("aeiou")
cnt = Counter(s)
best_vowel = max((cnt[c] for c in vowels), default=0)
best_consonant = max((v for c, v in cnt.items() if c not in vowels), default=0)
```

- **最多的母音加最多的子音**（LC 3541）：上面的程式。
- **母音比子音的分數**（LC 3813）：只算字母，空白和數字都不算。
- **依次數排序母音**（LC 3913）：只把母音抽出來，用 `(-次數, 第一次出現的位置)` 排序後放回原本母音的位置。
- **前綴的不同字元數**（LC 3803）：邊掃邊把字元加進集合。
- **相鄰數字的差**（LC 3931）：直接比較相鄰兩個。

## 模板五：固定起點往右擴

```python
for i in range(n):
    cnt = Counter()
    max_freq = 0
    for j in range(i, n):
        cnt[s[j]] += 1
        max_freq = max(max_freq, cnt[s[j]])
        if max_freq * len(cnt) == j - i + 1:     # 每種字元都出現 max_freq 次
            best = max(best, j - i + 1)
```

- **每種字元次數都相同**（LC 3713）：「每種都一樣多」等於「最多的次數 × 種類數 = 長度」，每一步 `O(1)` 判斷。

## 主要參數說明

- `s[i:j]` 不包含 `j`；長度 `k` 的子字串最後一個起點是 `len(s) - k`。
- `str.startswith(p, i)` 從 `i` 開始比對，超出範圍時回傳 `False`，不會報錯。

## 複雜度

模擬和計數是 `O(n)`；收集所有長度 `k` 的子字串是 `O(n · k)`；固定起點往右擴是 `O(n²)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **連續 `replace`**：`"&amp;gt;"` 先換成 `"&gt;"`，再被換成 `">"`（LC 1410）。
- **往後看沒檢查邊界**：`&` 在字串最後時 `text[right]` 超出範圍（LC 1410）。
- **條件寫成 `ch == "*" and res`**：結果是空的時候條件不成立，`*` 掉到最後的 `else` 被加進結果（LC 3612）。
- **子字串的範圍差一**：寫成 `s[right - k: right]`，最後一個視窗沒收到（LC 1461）。
- **用原本的 index 換算目前的位置**：刪除的數量算錯，距離就錯了；直接記結果裡的位置比較簡單（LC 4019）。
- **多了一層不必要的迴圈**：外面再枚舉 26 種「種類數」，TLE（LC 3713）。

## 相關 LeetCode

- `LC 1410` HTML Entity Parser
- `LC 3803` Count Residue Prefixes
- `LC 4019` Merge Close Characters II
- `LC 1461` Check If a String Contains All Binary Codes of Size K
- `LC 3541` Find Most Frequent Vowel and Consonant
- `LC 3713` Longest Balanced Substring I
- `LC 2264` Largest 3-Same-Digit Number in String
- `LC 3798` Largest Even Number
- `LC 3931` Check Adjacent Digit Differences
- `LC 3612` Process String with Special Operations I
- `LC 3813` Vowel-Consonant Score
- `LC 3913` Sort Vowels by Frequency
