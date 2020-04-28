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
      , body = [ 
        Html.div [] 
          [ Html.text "Impossible de charger les catégories."
          , Html.a [ class "link", href (Route.toHref Route.Categories_Create) ] [ Html.text "Ajouter une catégorie" ]
          ]
      ]
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
              ( List.map (\category -> categoryLine category) categories)  
              ]
              ,Html.a [ class "link", href (Route.toHref Route.Categories_Create) ] [ Html.text "Ajouter une catégorie" ]
          ]
      }


categoryLine: Category -> Html.Html msg
categoryLine category = 
        Html.li [] 
            [ Html.p []
                [ Html.text category.categoryName ]
            , Html.button []
                [ Html.text "Supprimer"]
            ,Html.a [ class "link addCategoryButtons", href (Route.toHref (Route.Categories_Dynamic { param1 = String.fromInt category.categoryId } )) ] [ Html.text "Modifier" ]
        ]