defmodule Shopify.OAuth do
  defstruct [
    :access_token,
    :scope,
    :expires_in,
    :associated_user_scope,
    :associated_user
  ]

  def permission_url(session, scopes \\ [], redirct_uri \\ "", options \\ %{}) do
    scopes = scopes |> Enum.join(",")
    session.base_url <> authorize_url <> "?client_id=#{session.client_id}&scope=#{scopes}&redirect_uri=#{redirct_uri}&state=#{options[:state]}&grant_options[]=#{options[:grant_options]}"
  end

  def request_token(session, code) do
    session
      |> Request.new(access_url(), %{}, %Shopify.OAuth{})
      |> Request.get
  end

  def authorize_url, do: "oauth/authorize"

  def access_url, do: "oauth/access_token"
end