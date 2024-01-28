# Flow
IO.puts(:erlang.system_info(:logical_processors_available))

File.stream!("../../measurements.txt")
# File.stream!("../1M.txt")
|> Flow.from_enumerable()
|> Stream.chunk_every(85_000)
|> Task.async_stream(
  fn chunk ->
    chunk
    |> Enum.reduce(%{}, fn line, acc ->
      [k, v] = String.split(line, ";")
      v = String.to_float(String.trim(v))

      Map.get_and_update(acc, k, fn
        r = {count, min, max, sum} ->
          {r, {count + 1, min, max, sum + v}}

        nil ->
          {nil, {1, v, v, v}}
      end)
      |> elem(1)
    end)
  end,
  timeout: :infinity
)
|> Enum.reduce(%{}, fn
  {:ok, col}, %{} ->
    col

  {:ok, col}, acc ->
    col
    |> Enum.reduce(acc, fn {k, v = {c, mn, mx, s}} ->
      acc
      |> Map.update(k, v, fn {prev_count, prev_min, prev_max, prev_sum} ->
        {c + prev_count, min(prev_min, mn), max(mx, prev_max), prev_sum + s}
      end)
    end)

    {col, acc}
end)
|> IO.inspect()
