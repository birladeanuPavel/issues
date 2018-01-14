defmodule Issues.TableFormatter do

  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
      put_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      put_in_columns(data_by_columns, format)
    end
  end

  @doc """
  Given a list of rows, where each row contains a keyed list
  of columns, return a list containing lists of the data in
  each column. The `headers` parameter contains the
  list of columns to extract
  ## Example

    iex> list = [Enum.into([{"a", "1"},{"b", "2"},{"c", "3"}], %{}),
    ...>          Enum.into([{"a", "4"},{"b", "5"},{"c", "6"}], %{})]
    iex> Issues.TableFormatter.split_into_columns(list, [ "a", "b", "c" ])
    [ ["1", "4"], ["2", "5"], ["3", "6"] ]

  """
  def split_into_columns(rows, headers) do
    for header <- headers  do
      for row <- rows,  do: printable(row[header])
    end
  end

  def printable(data) when is_binary(data), do: data
  def printable(data), do: to_string(data)

  @doc """
  Given a list containing sublists, where each sublist contains the data for
  a column, return a list containing the maximum width of each column

  ## Example
    iex> columns = [["first", "second", "third"], ["a", "ab"]]
    iex> Issues.TableFormatter.widths_of columns
    [6, 2]
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def put_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&put_one_line_in_columns(&1, format))
  end

  def put_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

end
