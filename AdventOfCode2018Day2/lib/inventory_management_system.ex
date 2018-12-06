defmodule InventoryManagementSystem do

  @moduledoc """
  Program in Elixir for Code of Advent 2018 Day 2
  """

  @doc """
  Calculates the checksum for your list of box IDs for the input.txt file given
  """

  def inventory_management_system do
    case IO.gets "Enter the input data file name: " do
      {:error, reason} -> inventory_management_system_error {:error, reason}
      :eof -> inventory_management_system_error {:error, "Hemos encontrado un final de fichero."}
      file -> inventory_management_system_file? file
    end
  end

  def inventory_management_system_error {:error, reason} do
    IO.puts :stderr, "Error: #{reason}"
    {:error, reason}
  end

  def inventory_management_system_file? file do
    file_str = String.trim_trailing(file)
    case File.exists? file_str do
      true -> inventory_management_system_ok file_str
      false -> inventory_management_system_error {:error, "No se ha podido encontrar el archivo..."}
    end
  end

  def inventory_management_system_ok file_str do
    case File.open(file_str, [:read]) do
       {:ok, file} -> map = IO.stream(file, :line)
                        |> Stream.map(&String.trim_trailing/1)
                        |> Enum.map fn enum ->
                            chars_list = String.graphemes enum
                            map_with_redundancy = Enum.reduce chars_list, %{}, fn (char, acc) ->
                                Map.update acc, char, 1, &(&1 + 1)
                              end
                            map_no_redundancy = Enum.reduce map_with_redundancy, %{}, fn {k,v}, acc ->
                                Map.update acc, k, v, &(&1 + 1)
                              end
                            map_no_redundancy_greater_reps = Enum.reduce map_no_redundancy, %{},
                                fn {k,v}, acc  when v > 1 ->
                                  Map.update acc, k, v, &(&1)
                                {_k,v}, acc when v <= 1 ->
                                  acc
                              end
                            map_no_redundancy_greater = Enum.reduce map_no_redundancy_greater_reps, %{},
                                  fn {k1,v1}, acc ->
                                    case Enum.find_value acc, fn {_k2,v2} -> v1 == v2 end do
                                      nil -> Map.put acc, k1, v1
                                      _value -> acc
                                    end
                                end
                              List.foldl [map_no_redundancy_greater], %{}, fn map, acc ->
                                Enum.flat_map map, fn {k1, v1} ->
                                  case Enum.find_value acc, fn {_k2,v2} -> v1 == v2 end do
                                    nil -> Map.put acc, v1, 1
                                    value -> Map.update(acc, k1, value, &(&1 + 1))
                                  end
                              end
                            end
                          end
                        res = map |> List.flatten
                        |> Enum.reduce %{}, fn {k,v}, acc ->
                              case Map.has_key? acc, k do
                                true ->  Map.update acc, k, v, &(&1 + 1)
                                false -> Map.put acc, k, v
                              end
                          end
                        Enum.reduce res, 1, fn {_k,v}, acc ->
                            acc * v
                          end
       {:error, reason} -> inventory_management_system_error {:error, reason}
    end
  end
end
