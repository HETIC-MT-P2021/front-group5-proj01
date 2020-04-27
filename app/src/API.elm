module Api exposing (..)

import Http
import Json.Decode exposing (Decoder, field, string)

type Msg
  = ImageLoaded (Result Http.Error String)

getImage : Cmd Msg
getImage =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson ImageLoaded gifDecoder
    }

gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)