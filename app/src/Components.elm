module Components exposing (layout)

import Browser exposing (Document)
import Generated.Route as Route exposing (Route)
import Html exposing (..)
import Html.Attributes as Attr exposing (class, href, style)


layout : { page : Document msg } -> Document msg
layout { page } =
    { title = page.title
    , body =
        [ div [ class "column spacing--large h--fill" ]
            [ navbar
            , div [ class "column app-container", style "flex" "1 0 auto" ] page.body
            , footer
            ]
        ]
    }


navbar : Html msg
navbar =
    header [ class "row center-y spacing--between app-header" ]
        [ a [ class "link font--h5", href (Route.toHref Route.Top) ] [ text "La Casa De Galeria" ]
        , div [ class "row center-y spacing--medium" ]
            [ a [ class "link font--h6", href (Route.toHref Route.Home) ] [ text "Accueil" ]
            , a [ class "link font--h6", href (Route.toHref Route.Images_Create) ] [ text "Ajouter une image" ]
            , a [ class "link font--h6", href (Route.toHref Route.Categories_Top) ] [ text "Catégories" ]
            , a [ class "link font--h6", href (Route.toHref Route.About) ] [ text "À propos" ]
            ]
        ]


footer : Html msg
footer =
    Html.footer [ class "app-footer" ] [ text "built with elm ❤" ]
