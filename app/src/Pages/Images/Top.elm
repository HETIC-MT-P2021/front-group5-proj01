module Pages.Images.Top exposing (..)

import Http exposing (Error)
import Html
import Page exposing (Document, Page)
import Html.Attributes exposing (class, href, style, id)
import Models exposing (Image, Images)
import Services.Images exposing(fetchImages)
import Generated.Route as Route exposing (Route)

type alias Flags =
    ()

type Msg = OnFetchImages (Result Http.Error Images)

type Model
  = Failure
  | Loading
  | Success (List Image)


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
  , fetchImages OnFetchImages
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnFetchImages result ->
      case result of
        Ok images ->
          (Success images, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



view : Model -> Document Msg
view model =
  case model of
    Failure ->
      { title = "Images.Top"
      , body = [Html.text "Impossible de charger les images."]
      }

    Loading ->
      { title = "Images.Top"
      , body = [Html.text "Loading"]
      }

    Success images ->
      { title = "Images.Top"
      , body = [ Html.h2 []
          [ Html.text "Listes des images" ]
          , Html.div []
              [ Html.ul [ id "categoryUl"]
              ( List.map (\image -> imageBox image) images)  
              ]
              ,Html.a [ class "link", href (Route.toHref Route.Images_Create) ] [ Html.text "Ajouter une image" ]
          ]
      }

imageBox: Image -> Html.Html msg
imageBox image = 
        Html.li [] 
            [ Html.p []
                [ Html.text image.fileName ]
            , Html.button []
                [ Html.text "Supprimer"]
        ]
