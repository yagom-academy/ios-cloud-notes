extension String {
  func truncated(limit: Int) -> String {
    if self.count > limit {
      let endIndex = self.index(self.startIndex, offsetBy: limit)
      return String(self[...endIndex])
    }
    return self
  }
}
