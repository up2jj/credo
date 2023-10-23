%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["**/space_around_operators.ex"]
      },
      plugins: [],
      requires: [],
      strict: false,
      parse_timeout: 5000,
      halt_on_parse_timeout: false,
      color: false,
      checks: [
        {
          Credo.Check.Consistency.ExceptionNames,
          files: %{included: "**/*.ex", excluded: "**/clean.ex"}, tags: [:__initial__, :my_tag]
        },
        {
          Credo.Check.Readability.ModuleDoc,
          files: %{included: "**/*.ex", excluded: "**/*_redux.ex"}
        },
        {Credo.Check.Readability.TrailingWhiteSpace,
         [
           category: :warning,
           exit_status: 23,
           files: %{excluded: "**/*.ex"},
           priority: :high,
           tags: [:__initial__, :my_tag]
         ]}
      ]
    }
  ]
}
