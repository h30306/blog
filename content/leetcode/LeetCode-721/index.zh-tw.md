---
title: "LeetCode 721: Accounts Merge"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-12
tags: ["LeetCode", "blog", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-12
- 總花費時間：20:00.00

## 解題思路

這是一道沒有明確提供關係的並查集（Union Find）問題。  
一開始，我採用暴力解法：遍歷每一對帳號並比較它們的 email 集合。  
如果他們有超過一個共同元素（例如相同名字且至少一個 email 相同），就將它們 union 起來。  
但這個方法的時間複雜度是 O(n²)，還需要額外的邏輯來追蹤用戶名稱並避免 email 重複，結果導致程式又亂又慢。

更好、更有效率的方法是建立一個 email 到 index 的對應表。  
每次遇到一個 email，我們檢查它是否已經出現在 map 裡：  
- 如果有，將目前的帳號與 map 中對應的帳號 index 做 union。  
- 如果沒有，就將這個 email 記錄在 map 中，指向目前的帳號 index。  

這樣我們只對有共同 email 的帳號做 union，就不需要重複比較整份帳號清單。  
最後，我們可以根據 email map，用 root index 來分組 emails，並用 `accounts[idx][0]` 補上用戶名稱。

關鍵觀念：  
- 利用 email 對應到帳號 index 來建立聯繫。  
- 並查集僅對 index 運作，不需要對 email 字串做 union。  
- union 後以 root index 為基礎進行分組。

### 時間複雜度：
- 第一種方法：O(n² * m)，其中 m 為每個帳號平均 email 數。
- 第二種方法：O(n·α(n))，α 為阿克曼函數的反函數。

### 空間複雜度：
- O(n + m)，來自對應表與並查集結構。

## 解法

### Compare all email account
我想在這種做法中，我卡在了「共同項目」這個問題上。  
我之前從沒想到可以直接把所有 email 當作鍵來處理，當發現某個 email 已經被另一個人使用（透過 index 連結）時，就可以使用並查集（Union Find）來將這兩個帳號連接起來。

```python
class Solution:
    def accountsMerge(self, accounts: List[List[str]]) -> List[List[str]]:
        n = len(accounts)
        uf = UF(n)

        for i in range(n):
            for j in range(i+1, n):
                if len(set(accounts[i]) & set(accounts[j]))>1:
                    uf.union(i, j)

        result = defaultdict(set)
        account = []
        for i in range(n):
            group = uf.find(i)
            if result[group] == set():
                account.append(accounts[i][0])
            result[group].update(accounts[i][1:])
        
        return [[acc, *sorted(value)] for acc, value in zip(account, result.values())]
        
class UF:
    def __init__(self, n):
        self.parent = [i for i in range(n)]

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        self.parent[root_y] = root_x
```
### iterate through email account
```python
class UF:
    def __init__(self,n):
        self.root = list(range(n))

    def find(self,x):
        if x == self.root[x]:
            return x
        self.root[x] = self.find(self.root[x])
        return self.root[x]

    def union(self,x,y):
        rootX = self.find(x)
        rootY = self.find(y)
        if rootX != rootY:
            self.root[rootX] = rootY

class Solution:
    def accountsMerge(self, accounts: List[List[str]]) -> List[List[str]]:
        n = len(accounts)
        uf = UF(n)

        owner = {}
        for idx,(_,*emails) in enumerate(accounts):
            for e in emails:
                if e in owner:
                    uf.union(idx,owner[e])    
                else:            
                    owner[e] = idx

        result = defaultdict(list)
        for email,num in owner.items():
            root = uf.find(num) 
            result[root].append(email)

        return [[accounts[idx][0]] + sorted(email) for idx,email in result.items()]
```


## 收穫

## 遇到的問題