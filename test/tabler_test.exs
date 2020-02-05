defmodule TableFormatterTest do
  use ExUnit.Case   # bring in the test functionality
  import ExUnit.CaptureIO   # And allow us to capture stuff sent to stdout
  
  alias Issues.Tabler, as: TBLR
  
  def test_data do
    [ 
      [ c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4" ],
      [ c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4" ], 
      [ c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4" ],
      [ c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
    ]
  end

  def headers, do: [ :c1, :c2, :c4 ]

  def split_with_three_columns,
    do: TBLR.split_into_columns(test_data, headers)

  test "split_into_columns" do
    columns = split_with_three_columns
    assert length(columns) == length(headers)
    assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"] 
    assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "column_widths" do
    widths = TBLR.widths_of(split_with_three_columns) 
    assert widths == [ 5, 6, 7 ]
  end
  
  test "correct format string returned" do
    assert TBLR.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

end