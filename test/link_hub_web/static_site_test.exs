defmodule LinkHubWeb.StaticSiteTest do
  use LinkHubWeb.ConnCase, async: true

  test "GitHub Pages export matches the Phoenix landing page", %{conn: conn} do
    document =
      "docs/index.html"
      |> File.read!()
      |> LazyHTML.from_document()

    phoenix_document =
      conn
      |> get(~p"/")
      |> html_response(200)
      |> LazyHTML.from_document()

    assert Enum.count(LazyHTML.query(document, "#contact-page")) == 1
    assert Enum.count(LazyHTML.query(document, "h1, .intro, #services")) == 0
    assert Enum.count(LazyHTML.query(document, "#contact-links > a")) == 5
    assert Enum.count(LazyHTML.query(document, ".contact-label")) == 0
    assert Enum.count(LazyHTML.query(document, ".contact-arrow svg")) == 5
    assert Enum.count(LazyHTML.query(document, "#phone-link .phone-icon")) == 1

    assert document
           |> LazyHTML.query(".contact-value")
           |> Enum.map(&LazyHTML.text/1) ==
             ["+380 63 132 60 12", "Telegram", "Viber", "WhatsApp", "TikTok"]

    assert contact_summary(document) == contact_summary(phoenix_document)
    assert File.regular?("docs/santehstyl-logo.png")
    assert File.regular?("docs/Telegram_logo.svg")
    assert File.regular?("docs/Chat_on_Viber_icon.svg")
    assert File.regular?("docs/whatsapp-com-logo.svg")
    assert File.regular?("docs/tiktok-com-logo.png")

    assert LazyHTML.attribute(LazyHTML.query(document, "link[rel='stylesheet']"), "href") ==
             ["./styles.css"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#home-link img"), "src") ==
             ["./santehstyl-logo.png"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#phone-link"), "href") ==
             ["tel:+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#telegram-link"), "href") ==
             ["https://t.me/+380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#telegram-link img"), "src") ==
             ["./Telegram_logo.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#viber-link"), "href") ==
             ["viber://chat?number=%2B380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#viber-link img"), "src") ==
             ["./Chat_on_Viber_icon.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#whatsapp-link"), "href") ==
             ["https://wa.me/380631326012"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#whatsapp-link img"), "src") ==
             ["./whatsapp-com-logo.svg"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#tiktok-link"), "href") ==
             ["https://www.tiktok.com/@santehstyl.ua?_r=1&_t=ZS-9BTZwjj0I2K"]

    assert LazyHTML.attribute(LazyHTML.query(document, "#tiktok-link img"), "src") ==
             ["./tiktok-com-logo.png"]

    assert LazyHTML.attribute(
             LazyHTML.query(document, "#tiktok-link > span:first-child"),
             "class"
           )
           |> Enum.any?(&String.contains?(&1, "contact-icon--tiktok"))
  end

  defp contact_summary(document) do
    for id <- ~w(phone telegram viber whatsapp tiktok) do
      link = LazyHTML.query(document, "##{id}-link")
      value = LazyHTML.query(link, ".contact-link__value, .contact-value")

      {
        id,
        LazyHTML.attribute(link, "href"),
        LazyHTML.attribute(link, "target"),
        LazyHTML.attribute(link, "rel"),
        LazyHTML.attribute(link, "aria-label"),
        LazyHTML.text(value)
      }
    end
  end
end
