defmodule Shopify.PaginationTest do
  use ExUnit.Case, async: true

  alias Shopify.{Error, Pagination, Response, Session}

  @next_link "<https://x.myshopify.com/admin/api/2019-10/products.json?limit=10&page_info=eyJsYXN0X2lkIjoxNTQwOTYwNTUwOTgyLCJsYXN0X3ZhbHVlIjoiRW5lcmd5IiwiZGlyZWN0aW9uIjoibmV4dCJ9>; rel=\"next\""
  @next_prev_link "<https://x.myshopify.com/admin/api/2019-10/products.json?limit=10&page_info=eyJkaXJlY3Rpb24iOiJwcmV2IiwibGFzdF9pZCI6MTkzOTI2Nzc4MDY3OCwibGFzdF92YWx1ZSI6IkVuZXJneSBTYW1wbGVyIn0>; rel=\"previous\", <https://x.myshopify.com/admin/api/2019-10/products.json?limit=10&page_info=eyJkaXJlY3Rpb24iOiJuZXh0IiwibGFzdF9pZCI6MTc1MTIwMjM5ODI3OCwibGFzdF92YWx1ZSI6IkhhdCAtIFRoZXJlIGlzIG5vIG1hZ2ljIHBpbGwifQ>; rel=\"next\""

  defp next_link(limit, page_info) do
    {"Link", "<https://x.com/path?limit=#{limit}&page_info=#{page_info}>; rel=\"next\""}
  end

  defp mock_list(%Session{}, p) when p == %{} do
    {:ok, %Response{data: ["a1", "a2"], headers: [next_link("10", "p_a2")]}}
  end

  defp mock_list(%Session{}, p) when p == %{"limit" => "10", "page_info" => "p_a2"} do
    {:ok, %Response{data: ["a3", "a4"], headers: []}}
  end

  defp mock_list(%Session{}, p) when p == %{broken: "end"} do
    {:ok, %Response{data: ["b1", "b2", "b3"], headers: [next_link("10", "p_b2")]}}
  end

  defp mock_list(%Session{}, p) when p == %{"limit" => "10", "page_info" => "p_b2"} do
    {:error, %Error{reason: :timeout, source: :httpoison}}
  end

  defp mock_list(%Session{}, p) when p == %{key: "foo"} do
    {:ok, %Response{data: ["f1", "f2", "f3"], headers: [next_link("20", "p_f2")]}}
  end

  defp mock_list(%Session{}, p) when p == %{"limit" => "20", "page_info" => "p_f2"} do
    {:ok, %Response{data: ["f4"], headers: []}}
  end

  test "enumerable with Enum.into/2" do
    assert ["a1", "a2", "a3", "a4"] ==
             Shopify.session()
             |> Pagination.enumerable(&mock_list/2)
             |> Enum.into([])

    assert ["f1", "f2", "f3", "f4"] ==
             Shopify.session()
             |> Pagination.enumerable(&mock_list/2, key: "foo")
             |> Enum.into([])

    exception =
      assert_raise(Error, fn ->
        Shopify.session() |> Pagination.enumerable(&mock_list/2, broken: "end") |> Enum.into([])
      end)

    assert exception == %Error{reason: :timeout, source: :httpoison}
  end

  test "enumerable with Enum.take/2 (coverage for :halt)" do
    assert ["b1", "b2"] ==
             Shopify.session()
             |> Pagination.enumerable(&mock_list/2, broken: "end")
             |> Enum.take(2)
  end

  test "enumerable with Enum.zip/2 (coverage for :suspend)" do
    assert [{"a1", "f1"}, {"a2", "f2"}, {"a3", "f3"}, {"a4", "f4"}] ==
             Enum.zip(
               Shopify.session() |> Pagination.enumerable(&mock_list/2),
               Shopify.session() |> Pagination.enumerable(&mock_list/2, key: "foo")
             )
  end

  test "next_page_params" do
    assert nil == Pagination.next_page_params(%Response{headers: []})

    assert %{
             "limit" => "10",
             "page_info" =>
               "eyJsYXN0X2lkIjoxNTQwOTYwNTUwOTgyLCJsYXN0X3ZhbHVlIjoiRW5lcmd5IiwiZGlyZWN0aW9uIjoibmV4dCJ9"
           } ==
             %Response{headers: [{"Link", @next_link}]}
             |> Pagination.next_page_params()

    assert %{
             "limit" => "10",
             "page_info" =>
               "eyJkaXJlY3Rpb24iOiJuZXh0IiwibGFzdF9pZCI6MTc1MTIwMjM5ODI3OCwibGFzdF92YWx1ZSI6IkhhdCAtIFRoZXJlIGlzIG5vIG1hZ2ljIHBpbGwifQ"
           } ==
             %Response{headers: [{"Link", @next_prev_link}]}
             |> Pagination.next_page_params()

    assert_raise MatchError, fn ->
      Pagination.next_page_params(%Response{headers: [{"Link", "nonsense"}]})
    end
  end
end
