module Pages.Images.Create exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Page exposing (Document, Page)
import File exposing (File)
import File.Select as Select
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as D


type alias Flags =
    ()


type alias Model =
    {
      plant: {
        photoUrl: String
      }
    }


type Msg
    = NoOp
    | UserSelectedNewImageUpload
    | UserSelectedImage File


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ({
      plant = {
        photoUrl = ""
      }
    }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        UserSelectedNewImageUpload ->
            (model, Select.file ["image/*"] UserSelectedImage)
        UserSelectedImage _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Ajout d'une nouvelle image"
    , body = [
      Html.text "Uploader une nouvelle image avec les détails"
      , img [ class "preview"
            , src model.plant.photoUrl
            , onClick UserSelectedNewImageUpload
            ] []
      ]
    }
