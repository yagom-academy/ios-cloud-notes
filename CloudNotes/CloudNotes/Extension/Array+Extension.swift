extension Array {
  subscript(safe index: Int) -> Element? {
    return index < self.count ? self[index] : nil
  }
}
