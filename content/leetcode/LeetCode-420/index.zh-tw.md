---
title: "LeetCode 420: Strong Password Checker"
summary: "LeetCode 420 解題筆記：分長度三種情況，太長時優先刪除 len % 3 == 0 的重複段來抵銷取代次數"
description: "2026-09-02 的 LeetCode 420 解題紀錄"
date: 2026-09-02
tags: ["hard", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-02
- 提交紀錄：Wrong Answer → Runtime Error ×3 → Wrong Answer → Accepted

## 解題思路

三個條件：長度 6 到 20、包含小寫大寫數字、沒有連續三個相同字元。可以插入、刪除、取代。

先算出兩個量：

- `missing`：缺幾種字元類型，0 到 3。
- 每段連續相同字元的長度 `L`（只看 `L >= 3` 的）。一段長度 `L` 的重複，用取代要 `L // 3` 次。

接著依長度分三種情況：

**1. 長度 < 6**：一定要插入 `6 - n` 個字元。插入的字元可以同時補缺少的類型、也能打斷重複，所以答案是 `max(6 - n, missing)`。

**2. 長度 6 到 20**：不需要插入或刪除。每次取代可以同時打斷重複和補類型，答案是 `max(取代次數, missing)`。

**3. 長度 > 20**：一定要刪除 `n - 20` 個。刪除也能減少需要的取代次數，關鍵是**刪在哪裡最划算**：

- 長度 `L % 3 == 0` 的段：刪 **1** 個就能少 1 次取代（例如 3 → 2，取代從 1 次變 0 次）。
- `L % 3 == 1` 的段：刪 **2** 個少 1 次取代。
- 其他：每刪 **3** 個少 1 次取代。

所以刪除的額度依序用在這三種，最後答案是 `(n - 20) + max(剩下的取代次數, missing)`。

## 我的嘗試

### 第一版：模型就錯了

用 stack 數重複、再拿一個公式組合，沒有區分長度的三種情況，也沒考慮刪除可以抵銷取代。

### Runtime Error ×3：打錯變數名稱

改成分情況討論後，連續三次 RE：

1. 用了還沒定義的 `remainDelete`。
2. 改成 `remainDelete = maxDelete`，下一行又打錯成 `missingType`。
3. `max(replaceCount + missingTypes)`：`max` 只給了一個 int。

### Wrong Answer：剩餘刪除額度算錯

```python
remainDelete = maxDelete              # 應該是 deleteCount - maxDelete
```

用掉 `maxDelete` 之後，剩下的額度是「總刪除數減掉用掉的」，不是「用掉的數量」。

## 正確解法

```python
class Solution:
    def strongPasswordChecker(self, password: str) -> int:
        n = len(password)
        missing = 3 - (any(c.islower() for c in password)
                       + any(c.isupper() for c in password)
                       + any(c.isdigit() for c in password))

        repeats = []
        i = 0
        while i < n:
            j = i
            while j < n and password[j] == password[i]:
                j += 1
            if j - i >= 3:
                repeats.append(j - i)
            i = j

        if n < 6:
            return max(6 - n, missing)

        replace = sum(L // 3 for L in repeats)
        if n <= 20:
            return max(replace, missing)

        delete = n - 20
        remain = delete
        mod0 = sum(1 for L in repeats if L % 3 == 0)
        mod1 = sum(1 for L in repeats if L % 3 == 1)

        used = min(remain, mod0)              # 每段刪 1 個，少 1 次取代
        replace -= used
        remain -= used

        used = min(remain, mod1 * 2)          # 每段刪 2 個，少 1 次取代
        replace -= used // 2
        remain -= used

        replace -= remain // 3                # 其餘每刪 3 個，少 1 次取代
        return delete + max(replace, missing)
```

`replace` 可能被扣到負數，但最後跟 `missing`（至少 0）取 `max`，不影響答案。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 沒有分長度三種情況就想用一條公式解決。
- 刪除時沒有依 `L % 3` 的優先順序分配。
- 剩餘額度寫成「用掉的數量」。
- 改了變數名稱後沒有檢查所有用到的地方。

## 面試口說整理

我先算缺少幾種字元類型，以及每段長度至少 3 的重複段。長度不足 6 時，插入能同時補類型和打斷重複，答案是 `max(6 - n, missing)`；長度在 6 到 20 之間，答案是 `max(取代次數, missing)`。超過 20 時一定要刪 `n - 20` 個，而刪除能減少取代：優先刪 `L % 3 == 0` 的段（刪 1 省 1 次），其次 `L % 3 == 1`（刪 2 省 1 次），其餘每刪 3 省 1 次。最後加上刪除數和 `max(剩下的取代, missing)`。時間 `O(n)`。
