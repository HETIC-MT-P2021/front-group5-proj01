module Pages.Categories.Create exposing (..)


import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page exposing (Document, Page)
import Services.Categories exposing(addCategory, Category)
import Generated.Route as Route exposing (Route)

type alias Flags =
    ()


type Model
  = Waiting String
  | Failure
  | Loading
  | Success Category


type Msg = SubmitForm String
    | SetCategoryName String
    | OnCategorySave (Result Error Category)
    | ResetForm


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


init : () -> (Model, Cmd Msg)
init _ =
    ( Waiting ""
  , Cmd.none
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetCategoryName newCategoryName ->
        (Waiting newCategoryName, Cmd.none)
    SubmitForm categoryName ->
        (Loading, addCategory categoryName OnCategorySave) 
    OnCategorySave result ->
      case result of
        Ok category ->
          (Success category, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)
    ResetForm -> 
        ( Waiting ""
        , Cmd.none
        )


view : Model -> Document Msg
view model =
  case model of
    Waiting categoryName -> 
        { title = "Création de catégories"
        , body = [ Html.form 
            [ Html.Events.onSubmit (SubmitForm categoryName)] 
            [
                label [ ] 
                    [ text "Nom de la catégorie"
                    , input 
                        [ type_ "text"
                        , placeholder "Nom de la catégorie"
                        , value categoryName
                        , onInput SetCategoryName
                        , id "categoryInput" ] []
                    ]
                , button [ id "categorySubmitButton" ]
                    [ text "Submit"]
            ]
        ] 
        }
    Failure ->
      { title = "Création de catégories"
      , body = [ text "Impossible d'ajouter la catégorie."]
      }

    Loading ->
      { title = "Création de catégories"
      , body = [ text "Ajout de la catégorie..."]
      }

    Success category ->
      { title = "Création de catégories"
      , body = [ h2 [] 
        [ text ("La catégorie " ++ category.categoryName ++ " à été créé") ] 
        , Html.a [ class "link addCategoryButtons", href (Route.toHref Route.Categories_Top) ] [ Html.text "Retour à la liste des catégories" ]
        , div [ class "addCategoryButtons" ] [
            button [ Html.Events.onClick ResetForm ] [ text "Ajouter un nouvelle catégorie"]
        ]
      ]
      }