defmodule Mix.Tasks.Iex do
  use Mix.Task

  @hidden true

  def run(_) do
    raise Mix.Error, message: "Cannot start IEx after the VM was booted, " <>
                              "to use IEx with Mix, please run: iex -S mix"
  end
end
