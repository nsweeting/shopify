defmodule Shopify.Comment do
  @derive [Poison.Encoder]
  @singular "comment"
  @plural "comments"

  use Shopify.Resource,
    import: [
      :all,
      :find,
      :create,
      :update,
      :count
    ]

  defstruct [
    :article_id,
    :author,
    :blog_id,
    :body,
    :body_html,
    :created_at,
    :email,
    :id,
    :ip,
    :published_at,
    :status,
    :updated_at,
    :user_agent
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  defp non_rest_url(id, sub_url), do: @plural <> "/#{id}/#{sub_url}.json"

  defp non_rest_post(session, id, sub_url) do
    session
    |> Request.new(non_rest_url(id, sub_url), empty_resource())
    |> Client.post()
  end

  @doc """
  Requests to mark a comment as spam.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Comment.spam(1)
      {:ok, %Shopify.Response{}}
  """
  @spec spam(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def spam(session, id) do
    session |> non_rest_post(id, "spam")
  end

  @doc """
  Requests to mark a comment as not spam.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Comment.not_spam(1)
      {:ok, %Shopify.Response{}}
  """
  @spec not_spam(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def not_spam(session, id) do
    session |> non_rest_post(id, "not_spam")
  end

  @doc """
  Requests to approve a comment that is currently pending unapproved so that it will be published on the site.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Comment.approve(1)
      {:ok, %Shopify.Response{}}
  """
  @spec approve(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def approve(session, id) do
    session |> non_rest_post(id, "approve")
  end

  @doc """
  Requests to remove a comment.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Comment.remove(1)
      {:ok, %Shopify.Response{}}
  """
  @spec remove(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def remove(session, id) do
    session |> non_rest_post(id, "remove")
  end

  @doc """
  Requests to restore a comment.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Comment.restore(1)
      {:ok, %Shopify.Response{}}
  """
  @spec restore(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def restore(session, id) do
    session |> non_rest_post(id, "restore")
  end
end
