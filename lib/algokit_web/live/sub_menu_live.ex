defmodule AlgokitWeb.SubMenuLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Categories

  def render(assigns) do
    ~H"""
      <.link href={~p"/"}>戻る</.link>
      <div class="text-xl"><%= @category.name %></div>
      <%= if Enum.count(@algorithms) == 0 do %>
        <p>登録されていません。</p>
      <% else %>
        <%= for algorithm <- @algorithms do %>
          <.link href={~p"/category/#{@category_id}/algorithm/#{algorithm.id}"}><%= algorithm.name %></.link>
        <% end %>
      <% end %>
    """
  end

  def mount(%{"category_id" => category_id}, _session, socket) do
    category = Categories.get(category_id)
    algorithms =
      category_id
      |> Algorithms.list_algorithms_by_category_id()

    {:ok, assign(socket,
      category_id: category_id,
      category: category,
      algorithms: algorithms
    )}
  end
end
