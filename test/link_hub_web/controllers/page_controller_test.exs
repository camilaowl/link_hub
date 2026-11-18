defmodule LinkHubWeb.PageControllerTest do
  use LinkHubWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    document = conn |> html_response(200) |> LazyHTML.from_document()

    assert Enum.count(LazyHTML.query(document, "#contact-page")) == 1
    assert Enum.count(LazyHTML.query(document, "#services > div")) == 3
    assert Enum.count(LazyHTML.query(document, "#contact-links > a")) == 4

    assert LazyHTML.attribute(LazyHTML.query(document, "#telegram-link"), "href") ==
             ["https://t.me/+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#viber-link"), "href") ==
             ["viber://chat?number=%2B380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#phone-link"), "href") ==
             ["tel:+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#tiktok-link"), "href") ==
             ["https://www.tiktok.com/@santehstyl.ua?_r=1&_t=ZS-9BTZwjj0I2K"]
  end
end
