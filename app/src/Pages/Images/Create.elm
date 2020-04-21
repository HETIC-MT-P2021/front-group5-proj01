module Pages.Images.Create exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Page exposing (Document, Page)
import File exposing (File)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as D


type alias Flags =
    ()


type alias Model = 
  { image: Maybe File
  }


type Msg
    = GotSelectedFile (File)


page : Page Flags Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    (Model Nothing)


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotSelectedFile file ->
          ( { model | image = Just file }
          )


view : Model -> Document Msg
view model =
    { title = "Ajout d'une nouvelle image"
    , body = [ 
        div []
            [ input [ type_ "file", multiple False , on "change" (D.map GotSelectedFile filesDecoder) ] [] ]
            , div [] []
      ]
    }

filesDecoder : D.Decoder (File)
filesDecoder =
  D.at ["target","files"] (File.decoder)