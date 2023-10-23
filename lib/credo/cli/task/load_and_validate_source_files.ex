defmodule Credo.CLI.Task.LoadAndValidateSourceFiles do
  @moduledoc false

  use Credo.Execution.Task

  alias Credo.CLI.Output
  alias Credo.Sources

  @exit_status Credo.CLI.ExitStatus.generic_error()

  def call(exec, _opts \\ []) do
    {time_load, source_files} =
      :timer.tc(fn ->
        exec
        |> Sources.find()
        |> Enum.group_by(& &1.status)
      end)

    invalid_files = Map.get(source_files, :invalid, [])
    timed_out_files = Map.get(source_files, :timed_out, [])

    Output.complain_about_invalid_source_files(invalid_files)
    Output.complain_about_timed_out_source_files(timed_out_files)

    if exec.halt_on_parse_timeout and not Enum.empty?(timed_out_files) do
      exec
      |> put_exit_status(@exit_status)
      |> halt("Parse timeout has occurred!")
    else
      valid_source_files = Map.get(source_files, :valid, [])

      exec
      |> put_source_files(valid_source_files)
      |> put_assign("credo.time.source_files", time_load)
    end
  end
end
