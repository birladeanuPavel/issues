defmodule Issues.TableForamtter do

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

  def split_into_columns(rows, headers) do
    for header <- headers  do
      for row <- rows,  do: printable(row[header])
    end
  end

  def printable(data) when is_binary(data), do: data
  def printable(data), do: to_string(data)

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
