### [isKnownUniquelyReferenced](https://developer.apple.com/documentation/swift/2429905-isknownuniquelyreferenced)
`Swift`官方文档中推荐开发者在实现比较大的数据结构时实现写时复制语义

`Swift`标准库提供可一个函数`isKnownUniquelyReferenced`，用来检查某个实例是不是唯一的引用，如果是，说明该实例没有被共享，我们可以直接修改当前的实例，如果不是，说明实例被共享，这时对它进行更改就需要先复制

```Swift
struct PaintingPlan {
  // 私有的引用类型, for "deep storage"
  private var bucket = Bucket(color: .blue)
  var bucketColor: Color {
    get {
      return bucket.color
    }
    set {
      //优化
      if isKnownUniquelyReferenced(&bucket) {
        bucket.color = bucketColor
      } else {
        bucket = Bucket(color: newValue)
      }
    }
  }
}
```

属性监听

```Swift
// Data Binding
class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

let code: Box<String?> = Box(nil)

code.value = "right code"

code.bind {
    print($0 ?? "")
}
```