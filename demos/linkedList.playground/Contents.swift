import UIKit

final class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    init(value: T, next: LinkedListNode? = nil) {
        self.value = value
        self.next = next
    }
}

extension LinkedListNode: CustomStringConvertible {
    var description: String {
        guard let next = next else { return "\(value)" }
        return "\(value) -> \(String(describing: next))"
    }
}

let node1 = LinkedListNode(value: 1)
let node2 = LinkedListNode(value: 2)
let node3 = LinkedListNode(value: 3)

node1.next = node2
node2.next = node3

print(node1)
print(node3)

struct LinkedList<T> {
    var head: LinkedListNode<T>?
    var tail: LinkedListNode<T>?
    init() { }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else { return "Empty list" }
        return String(describing: head)
    }
}

extension LinkedList {
    var isEmpty: Bool {
        return head == nil
    }
}

extension LinkedList {
    
    mutating func append(_ value: T) {
        copyNodes()
        
        guard !isEmpty else {
            let node = LinkedListNode(value: value)
            head = node
            tail = node
            return
        }
        let next = LinkedListNode(value: value)
        tail?.next = next
        tail = next
    }
    
    mutating func insert(_ value: T, after node: LinkedListNode<T>) {
        guard tail !== node else { append(value); return }
        node.next = LinkedListNode(value: value, next: node.next)
    }
}

extension LinkedList {
    mutating func removeLast() -> T? {
        guard let head = head else { return nil }
        
        guard head.next != nil else {
            let headValue = head.value
            self.head = nil
            self.tail = nil
            return headValue
        }
        
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    // remove(after:)：defer里面的代码会在return语句执行之后运行，所以在return node.next?.value之后，判断node的下一个元素是否是最后一个元素，如果是，最后一个元素就变成了node；因为我们删除了node的下一个元素，所以node.next变成了node.next?.next。
    mutating func remove(after node: LinkedListNode<T>) -> T? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList {
    func node(at index: Int) -> LinkedListNode<T>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return currentNode
    }
}

extension LinkedList: Collection {
    
    struct Index: Comparable {
        var node: LinkedListNode<T>?
        
        static func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    var startIndex: Index {
        return Index(node: head)
    }
    
    var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    subscript(index: Index) -> T {
        return index.node!.value
    }
}

extension LinkedList {
    private mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }
        
        head = LinkedListNode(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            let nextNewNode = LinkedListNode(value: nextOldNode.value)
            newNode?.next = nextNewNode
            newNode = nextNewNode
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
}

var list1 = LinkedList<Int>()
list1.append(1)
list1.append(2)
list1.append(3)

let list2 = list1

print("list1: \(list1)")
print("list2: \(list2)")

print("========分割线========")

list1.append(4)

print("list1: \(list1)")
print("list2: \(list2)")

for i in list1 {
    print(i)
}


