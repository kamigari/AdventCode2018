defmodule ChronalCalibration do

  @moduledoc """
  Program in Elixir for Code of Advent 2018 Day 1
  """

  @doc """
  Calculates the chronal calibration for the input.txt file
  """

  def chronal_calibration do
    case IO.gets "Enter the input data file name: " do
      {:error, reason} -> chronal_calibration_error {:error, reason}
      :eof -> chronal_calibration_error {:error, "Hemos encontrado un final de fichero."}
      file_str -> chronal_calibration_ok file_str
    end
  end

  def chronal_calibration_error {:error, reason} do
    :stderr |> IO.puts reason
    {:error, reason}
  end

  def chronal_calibration_ok file do
    file_str = String.trim_trailing(file)
    case File.exists? file_str do
      true -> {:ok, file} = File.open(file_str, [:binary])
        acc = IO.stream(file, :line)
          |> Stream.map(&String.trim_trailing/1)
          |> Enum.map(fn x -> String.to_integer x end)
          |> Enum.reduce 0,
            fn(x,acc)
              -> x + acc
            end
          acc |> IO.puts
      false -> chronal_calibration_error {:error, "No se ha podido encontrar el archivo..."}
    end
  end

end
