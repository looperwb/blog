## 栈（Stack）
栈是一种“后进先出（`Last In First Out`）”的数据结构，简称`(LIFO)`。与链表和数组一样，栈的数据也是线性排列，但在栈中，添加和删除数据的操作只能在一端进行，访问数据也只能访问到顶端的数据。想要访问中间的数据时，就必须通过出栈操作将目标数据移到栈顶才行。

![](../images/stack-1.png)
![](../images/stack-2.png)

```Swift
struct Stack<Element> {
    private var elements: [Element] = []
    init() { }
}

extension Stack: CustomStringConvertible {
    
    var description: String {
        let topDivider = "====top====\n"
        let bottomDivider = "\n====bottom====\n"
        let stackElements = elements.reversed().map { "\($0)" }.joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
    
}
```

```Swift
extension Stack {
    mutating func push(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
}
```

```Swift
extension Stack {
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var top: Element? {
        return elements.last
    }
}

```


### [算法题：有效的括号](https://leetcode-cn.com/problems/valid-parentheses/description/)
给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。
注意空字符串可被认为是有效字符串。

```Swift
class Solution {
    func isValid(_ s: String) -> Bool {
        var stack = ""
        let pairs: [Character: Character] = ["}": "{", "]": "[", ")": "("]
        
        for character in s {
            guard let expectedPrevBracket = pairs[character] else { stack.append(character); continue }
            
            if let last = stack.last, expectedPrevBracket == last {
                stack.removeLast()
            } else {
                return false
            }
        }
        
        return stack.isEmpty
    }
}
```
