Mix.start
Mix.shell(Mix.Shell.Test)
ExUnit.start []

defmodule MixTest.Case do
  defmacro __using__(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      import MixTest.Case

      def teardown(_) do
        Mix.Task.clear
        Mix.Shell.Test.flush
      end

      defoverridable [teardown: 1]
    end
  end

  def mix(args) do
    System.cmd "#{mix_executable} #{args}"
  end

  def mix_executable do
    File.expand_path("../../../../bin/mix", __FILE__)
  end

  def fixture_path do
    File.expand_path("../fixtures", __FILE__)
  end

  def fixture_path(extension) do
    File.join fixture_path, extension
  end

  def tmp_path do
    File.expand_path("../tmp", __FILE__)
  end

  def tmp_path(extension) do
    File.join tmp_path, extension
  end

  def purge(modules) do
    Enum.each modules, fn(m) ->
      :code.delete(m)
      :code.purge(m)
    end
  end

  defmacro in_fixture(which, block) do
    module   = inspect __CALLER__.module
    function = atom_to_binary elem(__CALLER__.function, 1)
    tmp      = File.join(module, function)

    quote do
      src  = File.join fixture_path(unquote(which)), "."
      dest = tmp_path(unquote(tmp))

      File.rm_rf!(dest)
      File.mkdir_p!(dest)
      File.cp_r!(src, dest)

      File.cd! dest, unquote(block)
    end
  end
end

defmodule Mix.Tasks.Hello do
  use Mix.Task
  @shortdoc "This is short documentation, see"

  @moduledoc """
  A test task.
  """

  def run(_) do
    "Hello, World!"
  end
end

defmodule Mix.Tasks.Invalid do
end