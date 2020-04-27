module Pages.Top exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Page exposing (Document, Page)
import Html.Attributes as Attr exposing (class, href, style, src)
import Generated.Route as Route exposing (Route)
import Models exposing (Image)


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

imageView : Image -> Html Msg
imageView model = 
  div [ class "galery-image-single-wrapper" ] [
    img [ class "galery-image-single"
      , src model.imageUrl
      ] []
  ]

galery : Html Msg
galery = 
  div [ class "galery-content" ] [
    imageView { id = 2, title = "Nom de l'image", description = "Une description à fournir", date = "12988120812", categoryId = 1, imageUrl = "https://via.placeholder.com/500" }
    , imageView { id = 3, title = "Nom de l'image", description = "Une description à fournir", date = "12988120812", categoryId = 3, imageUrl = "https://via.placeholder.com/200" }
    , imageView { id = 1, title = "Nom de l'image", description = "Une description à fournir", date = "12988120812", categoryId = 3, imageUrl = "https://via.placeholder.com/1000" }
  ]


view : Document Msg
view =
    { title = "Top"
    , body = [ 
        navbar
        , galery
     ]
    }
