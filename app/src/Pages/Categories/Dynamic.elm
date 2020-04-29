module Pages.Categories.Dynamic exposing (..)

import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page exposing (Document, Page)
import Services.Categories exposing (fetchCategory, updateCategory)
import Generated.Route as Route exposing (Route)
import Models exposing (Category)

type alias Flags =
    { param1 : String }


type Model 
    = Waiting Category
    | Failure
    | Loading
    | UpdateSuccess Category


type Msg = SubmitForm
    | SetCategoryName String
    | OnCategoryUpdate (Result Error Category)
    | OnCategoryFetch (Result Error Category)

page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Loading
    , fetchCategory ( String.toInt flags.param1 ) OnCategoryFetch )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetCategoryName categoryName ->
        case model of 
            Waiting category ->
                (Waiting 
                    { categoryId = category.categoryId
                    , categoryName = categoryName  
                }, Cmd.none)
            _ ->
                (model, Cmd.none)
    OnCategoryFetch result -> 
        case result of
            Ok category ->
                (Waiting category, Cmd.none)

            Err _ ->
                (Failure, Cmd.none)
    OnCategoryUpdate result ->
        case result of
            Ok category ->
                (UpdateSuccess category, Cmd.none)

            Err _ ->
                (Failure, Cmd.none)
    SubmitForm ->
        case model of 
            Waiting category ->
                (Loading, updateCategory category OnCategoryUpdate ) 
            _ ->
                (model, Cmd.none)
            
    
    

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
  case model of
    Waiting category -> 
        { title = "Modification | " ++ category.categoryName
        , body = [ Html.form 
            [ Html.Events.onSubmit SubmitForm] 
            [
                label [ ] 
                    [ Html.text "Nom de la catégorie"
                    , Html.input 
                        [ type_ "text"
                        , placeholder "Nom de la catégorie"
                        , value category.categoryName
                        , onInput SetCategoryName
                        , id "categoryInput" ] []
                    ]
                , button [ id "categorySubmitButton" ]
                    [ Html.text "Mettre à jours"]
            ]
        ] 
        }
    Failure ->
      { title = "Modification d'une catégorie"
      , body = [ Html.text "Impossible de récupérer ou mettre à jours la catégorie"]
      }

    Loading ->
      { title = "Modification d'une catégorie"
      , body = [ Html.text "Chargement..." ]
      }

    UpdateSuccess category ->
      { title = "Modification d'une catégorie"
      , body = [ Html.h2 [] 
        [ Html.text ("La catégorie " ++ category.categoryName ++ " à été mise à jours") ] 
        , Html.a [ class "link addCategoryButtons", href (Route.toHref Route.Categories_Top) ] [ Html.text "Retour à la liste des catégories" ]
      ]
      }