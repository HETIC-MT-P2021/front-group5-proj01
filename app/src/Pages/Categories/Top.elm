module Pages.Categories.Top exposing (..)

import Http exposing (Error)
import Html
import Page exposing (Document, Page)
import Html.Attributes exposing (class, href, style, id)
import Services.Categories exposing(fetchCategories, Category, Categories)
import Generated.Route as Route exposing (Route)

type alias Flags =
    ()

type Msg = OnFetchCategories (Result Http.Error Categories)

type Model
  = Failure
  | Loading
  | Success (List Category)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> (Model, Cmd Msg)
init _ =
    ( Loading
  , fetchCategories OnFetchCategories
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnFetchCategories result ->
      case result of
        Ok categories ->
          (Success categories, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



view : Model -> Document Msg
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
              ( List.map (\category -> categoryLine category.categoryName) categories)  
              ]
              ,Html.a [ class "link", href (Route.toHref Route.Categories_Create) ] [ Html.text "Ajouter une catégorie" ]
          ]
      }

categoryLine: String -> Html.Html msg
categoryLine categoryName = 
        Html.li [] 
            [ Html.p []
                [ Html.text categoryName ]
            , Html.button []
                [ Html.text "Supprimer"]
        ]