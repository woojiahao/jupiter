defmodule Jupiter.Parser do
  @prefix "j!"
  @parse_blocks %{
    "help" => [],
    "ping" => [],
    "register" => [{:url, "invite_link"}, {:role, "role"}],
    "unregister" => [{:url, "invite_link"}],
    "editregister" => [{:url, "invite_link"}, {:role, "role"}],
    "setlogging" => [],
    "list" => []
  }

  def get_arg_map(@prefix <> message, dump) do
    parts =
      message
      |> String.split(" ")
      |> Enum.filter(&(&1 != ""))
      |> parse([], nil)
    args = parse_command_body(parts, dump)
    command = Enum.at(parts, 0)
    %{
      command: command,
      args: args
    }
  end

  def get_arg_map(_, _), do: nil

  defp parse([], acc, _), do: acc

  defp parse(["\"" <> word | rest], acc, nil) do
    parse(rest, acc, word)
  end

  defp parse([word | rest], acc, nil) do
    parse(rest, acc ++ [word], nil)
  end

  defp parse([word | rest], acc, cur) do
    if String.ends_with?(word, "\"") do
      parse(rest, acc ++ [cur <> " " <> String.slice(word, 0..-2//1)], nil)
    else
      parse(rest, acc, cur <> " " <> word)
    end
  end

  defp parse_command_body([command | _], _) when not is_map_key(@parse_blocks, command), do: nil

  defp parse_command_body([command | parts], dump) do
    @parse_blocks
    |> Map.get(command)
    |> parse_blocks(parts, %{}, dump)
  end

  defp parse_blocks([], _, acc, _), do: acc

  defp parse_blocks([{:url, name} | other_blocks], [url | rest], acc, dump) do
    if is_valid_url?(url) do
      parse_blocks(other_blocks, rest, Map.put(acc, name, url), dump)
    else
      nil
    end
  end

  defp parse_blocks([{:role, name} | other_blocks], [role | rest], acc, dump) do
    if(is_valid_role?(role, dump)) do
      parse_blocks(other_blocks, rest, Map.put(acc, name, role), dump)
    else
      nil
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
