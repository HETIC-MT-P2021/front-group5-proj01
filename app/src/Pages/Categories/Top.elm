module Pages.Categories.Top exposing (..)

import Html
import Page exposing (Document, Page)
import Html.Attributes exposing (class, href, style, id)
import Services.Categories exposing(fetchCategories, CategoriesMsg(..), Category)

type alias Flags =
    ()


type Model
  = Failure
  | Loading
  | Success (List Category)


subscriptions : Model -> Sub CategoriesMsg
subscriptions model =
  Sub.none


page : Page Flags Model CategoriesMsg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> (Model, Cmd CategoriesMsg)
init _ =
    ( Loading
  , fetchCategories
  )


update : CategoriesMsg -> Model -> (Model, Cmd CategoriesMsg)
update msg model =
  case msg of
    OnFetchCategories result ->
      case result of
        Ok categories ->
          (Success categories, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)
    _ ->
      (model, Cmd.none)



view : Model -> Document CategoriesMsg
view model =
  case model of
    Failure ->
      { title = "Categories.Top"
      , body = [Html.text "Impossible de charger les catégories."]
      }

    Loading ->
      { title = "Categories.Top"
      , body = [Html.text "Loading"]
      }

    Success categories ->
      { title = "Categories.Top"
      , body = [ Html.h2 []
          [ Html.text "Listes des catégories" ]
          , Html.div []
              [ Html.ul [ id "categoryUl"]
              ( List.map (\category -> categoryLine category.name) categories)  
              ]
              , Html.button [] 
              [ Html.text "Ajouter une catégorie"]
          ]
      }

categoryLine: String -> Html.Html msg
categoryLine name = 
        Html.li [] 
            [ Html.p []
                [ Html.text name ]
            , Html.button []
                [ Html.text "Supprimer"]
        ]