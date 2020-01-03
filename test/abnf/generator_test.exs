defmodule Abnf.GeneratorTest do
  use ExUnit.Case, async: true
  alias Abnf.Generator

  test "generating a rulelist" do
    expected_rulelist =
      """
      defrule(:DQUOTE) do
        literal('"')
      end
      """
      |> String.trim_trailing()

    generated_rulelist =
      Generator.generate(
        {:rule, "DQUOTE = %x22\r\n",
         [
           {:rulename, "DQUOTE",
            [
              {:ALPHA, "D", []},
              {:ALPHA, "Q", []},
              {:ALPHA, "U", []},
              {:ALPHA, "O", []},
              {:ALPHA, "T", []},
              {:ALPHA, "E", []}
            ]},
           {:"defined-as", " = ",
            [
              {:"c-wsp", " ",
               [
                 {:WSP, " ",
                  [
                    {:SP, " ", []}
                  ]}
               ]},
              {:literal, "=", []},
              {:"c-wsp", " ",
               [
                 {:WSP, " ",
                  [
                    {:SP, " ", []}
                  ]}
               ]}
            ]},
           {:elements, "%x22",
            [
              {:"num-val", "%x22",
               [
                 {:literal, "%", []},
                 {:"hex-val", "x22",
                  [
                    {:literal, "x", []},
                    {:HEXDIG, "2", [{:digit, "2", []}]},
                    {:HEXDIG, "2", [{:digit, "2", []}]}
                  ]}
               ]}
            ]},
           {:"c-nl", "\r\n",
            [
              {:CRLF, "\r\n",
               [
                 {:CR, "\r", []},
                 {:LF, "\n", []}
               ]}
            ]}
         ]}
      )
      |> Macro.to_string()

    assert expected_rulelist == generated_rulelist
  end

  test "generate with prose-val" do
    expected_rulelist =
      """
      defrule(:"prose-val") do
        concatenate([literal('<'), repeat(0, :infinity, alternate([range(32, 61), range(63, 126)])), literal('>')])
      end
      """
      |> String.trim_trailing()

    generated_rulelist =
      Generator.generate(
        {:rule, "ipath-empty = 0<ipchar>\r\n",
         [
           {:rulename, "ipath-empty",
            [
              {:ALPHA, "i", []},
              {:ALPHA, "p", []},
              {:ALPHA, "a", []},
              {:ALPHA, "t", []},
              {:ALPHA, "h", []},
              {:literal, "-", []},
              {:ALPHA, "e", []},
              {:ALPHA, "m", []},
              {:ALPHA, "p", []},
              {:ALPHA, "t", []},
              {:ALPHA, "y", []}
            ]},
           {:"defined-as", " = ",
            [
              {:"c-wsp", " ",
               [
                 {:WSP, " ",
                  [
                    {:SP, " ", []}
                  ]}
               ]},
              {:literal, "=", []},
              {:"c-wsp", " ",
               [
                 {:WSP, " ",
                  [
                    {:SP, " ", []}
                  ]}
               ]}
            ]},
           {:elements, "0<ipchar>",
            [
              {:"num-val", "0",
               [
                 {:"dec-val", "0",
                  [
                    {:DIGIT, "0", [{:digit, "0", []}]}
                  ]}
               ]},
              {:"prose-val", "<ipchar>",
               [
                 {:literal, "<", []},
                 {:ALPHA, "i", []},
                 {:ALPHA, "p", []},
                 {:ALPHA, "c", []},
                 {:ALPHA, "h", []},
                 {:ALPHA, "a", []},
                 {:ALPHA, "r", []},
                 {:literal, ">", []}
               ]}
            ]},
           {:"c-nl", "\r\n",
            [
              {:CRLF, "\r\n",
               [
                 {:CR, "\r", []},
                 {:LF, "\n", []}
               ]}
            ]}
         ]}
      )
      |> Macro.to_string()

    assert generated_rulelist = expected_rulelist
  end
end
