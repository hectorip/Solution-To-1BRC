# Using Elixir Flow that distributes the work across all the available cores

IO.puts(:erlang.system_info(:logical_processors_available))
alias Flow
File.stream!("../../../measurements.txt")
  # File.stream!("../../1M.txt")
|> Flow.from_enumerable()
|> Flow.map(fn line ->
  line
  |> String.trim()
  |> String.split(";")
  |> Kernel.then(fn [city, measure] -> {city, String.to_float(measure)} end)
end)
|> Flow.partition()
|> Flow.reduce(fn -> %{} end, fn {city, measure}, acc ->
  Map.update(acc, city, {0, 0, 0, 0}, fn v ->
    {count, m, mx, sum} = v
    {count + 1, min(measure, m), max(measure, mx), sum + measure}
  end)
end)
|> Enum.to_list()
|> IO.inspect()

