module Pages.Top exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Page exposing (Document, Page)
import Html.Attributes as Attr exposing (class, href, style, src)
import Generated.Route as Route exposing (Route)


type alias Flags =
    ()


type alias Model =
    ()


type alias Msg =
    Never


page : Page Flags Model Msg
page =
    Page.static
        { view = view
        }


navbar : Html Msg
navbar = 
  div [ class "app-sub-header" ] [
    div [ class "content-filters" ] [
      select [ class "filter-option-input" ] [
        option [ Attr.disabled True, Attr.selected True ] [ text "Catégories" ]
        , option [] [ text "Une option" ]
        , option [] [ text "Une deuxième option" ]
        , option [] [ text "Une troisième option" ]
        , option [] [ text "Une quatrième option" ]
      ]
      , select [ class "filter-option-input" ] [
        option [ Attr.disabled True, Attr.selected True ] [ text "Tags" ]
        , option [] [ text "Une option" ]
        , option [] [ text "Une deuxième option" ]
        , option [] [ text "Une troisième option" ]
        , option [] [ text "Une quatrième option" ]
      ]
      , input [ class "filter-option-input", Attr.type_ "date" ] []
    ]
    , div [ class "add-image-wrapper" ] [
      a [ class "link font--h6", href (Route.toHref Route.Images_Create) ] [ text "Ajouter une image" ]
    ]
  ]

imageView : String -> Html Msg
imageView photoUrl = 
  div [ class "galery-image-single-wrapper" ] [
    img [ class "galery-image-single"
      , src photoUrl
      ] []
  ]

galery : Html Msg
galery = 
  div [ class "galery-content" ] [
    imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/100"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
    , imageView "https://via.placeholder.com/200"
  ]


view : Document Msg
view =
    { title = "Top"
    , body = [ 
        navbar
        , galery
     ]
    }
