Mix.install([
  {:explorer, "~> 0.8.0"}
])

Explorer.DataFrame.new("../1M.txt")
|> Explorer.DataFrame.print()
