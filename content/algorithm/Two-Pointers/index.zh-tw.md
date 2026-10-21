---
title: "Two Pointers 雙指針"
summary: "對撞指針、兩個序列各一個指針、跳過空白比對位置、排序後數 pair，以及原地覆寫的寫入指針"
description: "演算法學習"
date: 2026-10-20
tags: ["two-pointers", "string", "sorting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

雙指針用兩個 index 一起掃描，每一步根據條件決定移動哪一個，讓原本 `O(n^2)` 的兩兩比較降到 `O(n)`。

關鍵是**每個指針都只往一個方向走**：只要能證明「這個位置之後不會再用到」，就可以放心地移動它。

常見的三種形式：

| 形式 | 指針怎麼走 | 例子 |
|---|---|---|
| 對撞指針 | 一個從頭、一個從尾，往中間靠 | 回文、反轉、排序後找 pair |
| 兩個序列各一個 | 各自在自己的序列上往前 | 合併、比對、子序列判斷 |
| 同向快慢 | 兩個都從頭開始，速度不同 | 滑動窗口、去重 |

滑動窗口另外有一篇；同向快慢這篇只講「寫入指針」（模板五），也就是原地刪除、去重、搬移元素。

## 模板一：對撞指針

```python
left, right = 0, len(s) - 1
while left < right:
    if 符合條件(s[left], s[right]):
        處理()
    left += 1
    right -= 1
```

- **檢查回文 / 改成回文**（LC 2697）：兩端不同時，改成比較小的那個字元，字典序最小。
- **反轉，但跳過某些字元**（LC 3823）：兩邊各自先跳到要處理的字元，再交換。
- **兩個字串拼成回文**（LC 1616）：外側貪心配對，配不下去時，剩下的中間段必須整段來自同一個字串，而且本身是回文。

Python 的字串不能修改，要交換字元得先 `list(s)`，最後再 `"".join(...)`（LC 3794）。

- **跳過不算的字元再比較**（LC 125、917、345）：用 `if / elif / else` 一次只動一邊，兩邊都停在有效字元上才比較或交換。
- **刪掉一個字元的回文**（LC 680）：第一對不同時只有「刪左」和「刪右」兩種，分別檢查剩下的區間。
- **貪心移動比較矮的一邊**（LC 11）：面積受限於比較矮的那一邊，移動比較高的一邊不可能變大。

### 延伸：k-sum（LC 15、16、18）

排序後固定前面 `k - 2` 個數，最後兩個用對撞指針，`O(n^(k-1))`。去重要做在三個地方：

```python
nums.sort()
for i in range(n):
    if i > 0 and nums[i] == nums[i - 1]:
        continue                       # 第一個數去重
    l, r = i + 1, n - 1                # 從 i + 1 開始，不是 0
    while l < r:
        s = nums[i] + nums[l] + nums[r]
        if s < target:
            l += 1
        elif s > target:
            r -= 1
        else:
            res.append([nums[i], nums[l], nums[r]])
            l += 1
            while l < r and nums[l] == nums[l - 1]:
                l += 1                 # 找到之後跳過相同的值
            r -= 1
```

4Sum 多一層 `j`，它的去重條件是 `j > i + 1`；3Sum Closest 不用去重，改成比 `abs(s - target)`。

## 模板二：兩個序列各一個指針

```python
i = j = 0
while i < len(a) and j < len(b):
    if a[i] == b[j]:
        ...
        i += 1
        j += 1
    elif a[i] < b[j]:
        i += 1
    else:
        j += 1
# 處理剩下的部分
```

- **合併兩個有序序列**（LC 2570）：跟 merge sort 的 merge 一樣。
- **找共同元素**（LC 2540）：比較小的那邊往前。
- **子序列判斷**（LC 522）：相同時兩邊都前進，不同時只有長字串前進。
- **連續段比對**（LC 809）：兩邊各自數出目前這段相同字元有多長，再比較長度。

### 主要參數說明：

- **迴圈結束後要確認兩邊都用完了**：只檢查其中一邊，另一邊剩下的字元會被忽略（LC 809）。
- **其中一邊先用完時，不能再讀它**：讀之前要先檢查 index（LC 2337 的 Runtime Error）。

## 模板三：跳過空白，比對棋子的位置

`L` 只能往左、`R` 只能往右、`_` 或 `X` 是空位（LC 2337、777）：

1. 去掉空位之後，兩個字串的棋子順序必須完全一樣（棋子不能互相跨越）。
2. 每一對對應的棋子：`L` 在起點的位置必須 `>=` 終點的位置；`R` 必須 `<=`。

```python
i = j = 0
while True:
    while i < n and start[i] == "_":
        i += 1
    while j < n and target[j] == "_":
        j += 1
    if i == n or j == n:
        return i == n and j == n
    if start[i] != target[j]:
        return False
    if start[i] == "L" and i < j or start[i] == "R" and i > j:
        return False
    i += 1
    j += 1
```

只比較字元的數量（`Counter`）不夠：順序和移動方向都要檢查（LC 777 的第一次 WA）。

## 模板四：排序後數 pair

陣列排序後，固定一端，另一端用指針或 bisect 找出符合條件的範圍：

```python
nums.sort()
left, right = 0, len(nums) - 1
while left < right:
    if nums[left] + nums[right] > target:
        right -= 1                    # 太大，只能縮小最大的那個
    else:
        count += right - left         # left 跟 (left, right] 都可以配
        left += 1
```

這是 Two Sum 的排序版本，也是很多「數有幾對 pair」題目的骨架。

## 模板五：寫入指針（原地覆寫）

`k` 指向「下一個要寫入的位置」，`i` 掃過整個陣列。`nums[:k]` 永遠是已經處理好、要保留的元素，因為 `k <= i`，寫入不會蓋掉還沒讀的值：

```python
k = 0
for x in nums:
    if 要保留(x):
        nums[k] = x
        k += 1
return k                               # nums[:k] 是答案
```

| 題目 | 要保留的條件 |
|---|---|
| LC 27 Remove Element | `x != val` |
| LC 26 Remove Duplicates | `k == 0 or x != nums[k - 1]` |
| LC 80 最多保留兩個 | `k < 2 or x != nums[k - 2]` |
| LC 283 Move Zeroes | `x != 0`，用交換讓 0 跑到後面 |
| LC 905 Sort Array By Parity | `x` 是偶數，用交換 |

- 比較的對象是**已經寫入的** `nums[k - 1]`、`nums[k - 2]`，不是原本的 `nums[i - 1]`，後者可能已經被覆寫了（LC 80）。
- 寫入後會變長的題目（LC 1089 Duplicate Zeros）要**從後往前**寫，先算出每個元素的最終位置，才不會蓋掉還沒處理的值。
- 三種值的分類（LC 75 Sort Colors）用三個指針：`low` 以前是 0、`high` 以後是 2；跟 `high` 交換之後 `i` 不要前進，換過來的值還沒檢查。

## 複雜度

雙指針本身是 `O(n)`。需要排序時是 `O(n log n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **`while` 迴圈裡忘記移動指針**：無限迴圈，TLE（LC 1768）。
- **`right += 1` 寫成往外走**：對撞指針的右指針要減（LC 1750）。
- **重疊的區間重複輸出**：用一個指針記住「已經輸出到哪裡」（LC 2200）。
- **只看下一個元素就下結論**：LC 1826 要比對整段剩下的資料，還要處理兩種情況都成立的歧義。
- **同一個檢查呼叫了兩次**：`check(a, b) or check(a, b)`，第二個應該是 `check(b, a)`（LC 1616）。
- **只比較數量，不看順序**（LC 777）。
- **只把字母當成有效字元**：題目說 alphanumeric 時數字也要比（LC 125）。
- **只數「有幾對不同」**：刪掉一個字元後後面的配對會整個錯開，要真的刪掉再檢查（LC 680）。
- **兩個指針都從 0 開始**：對撞指針的 `while left < right` 一次都不會執行（LC 917）。
- **反轉每一段時只做了第一段**，或剩不到 `k` 個的最後一段沒做（LC 541）。
- **`split(" ")` 遇到連續空白會產生空字串**，要用 `split()`（LC 151）。
- **兩個指針都沒走完才繼續**：其中一個先走完時，另一邊剩下的元素完全沒檢查（LC 925）。
- **比較原本的 `nums[i - 2]`**：它可能已經被寫入指針蓋掉了（LC 80）。
- **寫入指針放在 `if` 外面**：只有寫入之後才前進（LC 283）。
- **k-sum 找到之後沒有跳過相同的值**，同一組答案重複加入；第二個數從 0 開始也不對（LC 15）。
- **4Sum 第二層的去重寫成 `j > 0`**，會跳過合法的答案（LC 18）。
- **跟 `high` 交換之後 `i` 還前進**：換過來的值沒檢查到（LC 75）。

## 相關 LeetCode

- `LC 1768` Merge Strings Alternately
- `LC 2570` Merge Two 2D Arrays by Summing Values
- `LC 2540` Minimum Common Value
- `LC 2441` Largest Positive Integer That Exists With Its Negative
- `LC 3794` Reverse String Prefix
- `LC 3823` Reverse Letters Then Special Characters in a String
- `LC 3643` Flip Square Submatrix Vertically
- `LC 3750` Minimum Number of Flips to Reverse Binary String
- `LC 3884` First Matching Character From Both Ends
- `LC 2697` Lexicographically Smallest Palindrome
- `LC 1750` Minimum Length of String After Deleting Similar Ends
- `LC 1616` Split Two Strings to Make Palindrome
- `LC 2200` Find All K-Distant Indices in an Array
- `LC 3775` Reverse Words With Same Vowel Count
- `LC 1826` Faulty Sensor
- `LC 522` Longest Uncommon Subsequence II
- `LC 809` Expressive Words
- `LC 2337` Move Pieces to Obtain a String
- `LC 777` Swap Adjacent in LR String
- `LC 2410` Maximum Matching of Players With Trainers
- `LC 3649` Number of Perfect Pairs
- `LC 825` Friends Of Appropriate Ages
- `LC 923` 3Sum With Multiplicity
- `LC 1782` Count Pairs Of Nodes
- `LC 948` Bag of Tokens
- `LC 2105` Watering Plants II
- `LC 1877` Minimize Maximum Pair Sum in Array
- `LC 1498` Number of Subsequences That Satisfy the Given Sum Condition
- `LC 1471` The k Strongest Values in an Array
- `LC 633` Sum of Square Numbers
- `LC 2563` Count the Number of Fair Pairs
- `LC 1574` Shortest Subarray to be Removed to Make Array Sorted
- `LC 2972` Count the Number of Incremovable Subarrays II
- `LC 2122` Recover the Original Array
- `LC 1989` Maximum Number of People That Can Be Caught in Tag
- `LC 3555` Smallest Subarray to Sort in Every Sliding Window
- `LC 581` Shortest Unsorted Continuous Subarray
- `LC 1793` Maximum Score of a Good Subarray
- `LC 986` Interval List Intersections
- `LC 244` Shortest Word Distance II
- `LC 1570` Dot Product of Two Sparse Vectors
- `LC 1229` Meeting Scheduler
- `LC 4026` Maximum Gap Between Stations
- `LC 2193` Minimum Number of Moves to Make Palindrome
- `LC 1842` Next Palindrome Using Same Digits
- `LC 125` Valid Palindrome
- `LC 680` Valid Palindrome II
- `LC 344` Reverse String
- `LC 541` Reverse String II
- `LC 917` Reverse Only Letters
- `LC 345` Reverse Vowels of a String
- `LC 151` Reverse Words in a String
- `LC 557` Reverse Words in a String III
- `LC 832` Flipping an Image
- `LC 942` DI String Match
- `LC 165` Compare Version Numbers
- `LC 925` Long Pressed Name
- `LC 11` Container With Most Water
- `LC 15` 3Sum
- `LC 16` 3Sum Closest
- `LC 18` 4Sum
- `LC 977` Squares of a Sorted Array
- `LC 455` Assign Cookies
- `LC 922` Sort Array By Parity II
- `LC 189` Rotate Array
- `LC 31` Next Permutation
- `LC 3069` Distribute Elements Into Two Arrays I
- `LC 26` Remove Duplicates from Sorted Array
- `LC 27` Remove Element
- `LC 80` Remove Duplicates from Sorted Array II
- `LC 283` Move Zeroes
- `LC 905` Sort Array By Parity
- `LC 1089` Duplicate Zeros
- `LC 75` Sort Colors
- `LC 42` Trapping Rain Water
- `LC 392` Is Subsequence
