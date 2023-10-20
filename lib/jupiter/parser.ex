defmodule Jupiter.Parser do
  @prefix "j!"

  def get_arg_map(@prefix <> message, dump) do
    parts =
      message
      |> String.split(" ")
      |> Enum.filter(&(&1 != ""))
      |> join_parts([], nil)

    args = parse_command_body(parts, dump)
    command = Enum.at(parts, 0)

    if elem(args, 0) == :error do
      args
    else
      {:ok,
       %{
         command: command,
         args: args
       }}
    end
  end

  def get_arg_map(_, _), do: nil

  defp join_parts([], acc, _), do: acc
  defp join_parts(["\"" <> word | rest], acc, nil), do: join_parts(rest, acc, word)
  defp join_parts([word | rest], acc, nil), do: join_parts(rest, acc ++ [word], nil)

  defp join_parts([word | rest], acc, cur) do
    if String.ends_with?(word, "\"") do
      join_parts(rest, acc ++ [cur <> " " <> String.slice(word, 0..-2//1)], nil)
    else
      join_parts(rest, acc, cur <> " " <> word)
    end
  end

  defp parse_command_body([command | parts], dump) do
    Jupiter.Commands.get_commands()
    |> Map.get(command)
    |> then(fn
      nil ->
        {:error, :command_not_found}

      command_details ->
        command_details
        |> Map.get(:components, [])
        |> parse_parts(parts, %{}, dump)
    end)
  end

  defp parse_parts([], _, acc, _), do: {:ok, acc}

  defp parse_parts([{:url, name} | other_blocks], [url | rest], acc, dump) do
    if is_valid_url?(url) do
      parse_parts(other_blocks, rest, Map.put(acc, name, url), dump)
    else
      {:error, :invalid_url}
    end
  end

  defp parse_parts([{:role, name} | other_blocks], [role | rest], acc, dump) do
    if(is_valid_role?(role, dump)) do
      parse_parts(other_blocks, rest, Map.put(acc, name, role), dump)
    else
      {:error, :role_not_found}
    end
  end

  defp is_valid_url?(url),
    do: URI.parse(url) |> then(fn uri -> !is_nil(uri.scheme) && uri.host =~ "." end)

  defp is_valid_role?(role, %Nostrum.Struct.Message{
         guild_id: guild_id
       }) do
    guild_id
    |> Nostrum.Api.get_guild_roles()
    |> then(fn
      {:ok, roles} -> Enum.any?(roles, fn r -> r.name == role end)
      _ -> false
    end)
  end
end
