defmodule LinkHubWeb.PageControllerTest do
  use LinkHubWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    document = conn |> html_response(200) |> LazyHTML.from_document()

    assert Enum.count(LazyHTML.query(document, "#contact-page")) == 1
    assert Enum.count(LazyHTML.query(document, "h1, .intro, #services")) == 0
    assert Enum.count(LazyHTML.query(document, "#contact-links > a")) == 5

    assert LazyHTML.attribute(LazyHTML.query(document, "#home-link img"), "src") ==
             ["/images/santehstyl-logo.png"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#telegram-link"), "href") ==
             ["https://t.me/+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#telegram-link img"), "src") ==
             ["/images/Telegram_logo.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#viber-link"), "href") ==
             ["viber://chat?number=%2B380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#viber-link img"), "src") ==
             ["/images/Chat_on_Viber_icon.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#phone-link"), "href") ==
             ["tel:+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#phone-link > span:first-child"), "class")
           |> Enum.any?(&String.contains?(&1, "contact-link__icon--round"))

    assert LazyHTML.attribute(LazyHTML.query(document, "#whatsapp-link"), "href") ==
             ["https://wa.me/380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#whatsapp-link img"), "src") ==
             ["/images/whatsapp-com-logo.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#tiktok-link"), "href") ==
             ["https://www.tiktok.com/@santehstyl.ua?_r=1&_t=ZS-9BTZwjj0I2K"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#tiktok-link img"), "src") ==
             ["/images/tiktok-com-logo.png"]
  end
end
