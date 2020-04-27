module Generated.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Top
    | About
    | Home
    | NotFound
    | Categories_Top
    | Categories_Create
    | Images_Create


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routes


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map About (Parser.s "about")
        , Parser.map Home (Parser.s "home")
        , Parser.map NotFound (Parser.s "not-found")
        , Parser.map Categories_Top (Parser.s "categories")
        , Parser.map Categories_Create (Parser.s "categories" </> Parser.s "create")
        , Parser.map Images_Create (Parser.s "images" </> Parser.s "create")
        ]


toHref : Route -> String
toHref route =
    let
        segments : List String
        segments =
            case route of
                Top ->
                    []
                
                About ->
                    [ "about" ]
                
                Home ->
                    [ "home" ]
                
                NotFound ->
                    [ "not-found" ]
                
                Categories_Top ->
                    [ "categories" ]
                
                Categories_Create ->
                    [ "categories", "create" ]
                
                Images_Create ->
                    [ "images", "create" ]
    in
    segments
        |> String.join "/"
        |> String.append "/"