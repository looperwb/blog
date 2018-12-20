### `Swift Extension`

#### `String`

```Swift
extension String {
    var filterQuote: String {
        return self.replacingOccurrences(of: "'", with: "\"")
    }
}
```