module Services.Images exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Models exposing (Image)

apiUrl = "http://127.0.0.1:8000/api/images"

type alias Images = List Image

type ImagesMsg
    = OnFetchImages (Result Http.Error Images)


fetchImages :  (Result Http.Error Images -> msg) -> Cmd msg
fetchImages onFetch =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson onFetch imagesDecoder
    }

addImage : String -> (Result Http.Error Image -> msg) -> Cmd msg
addImage name onSave =
    addImageRequest name onSave

addImageRequest : String -> (Result Http.Error Image -> msg) -> Cmd msg
addImageRequest name onSave =
    Http.post
        { url = apiUrl
        , body = encodeImageTitle name |> Http.jsonBody
        , expect = Http.expectJson onSave imageDecoder
        }

imageDecoder : Decode.Decoder Image
imageDecoder =
    Decode.map5 Image
        (Decode.field "imageId" Decode.int)
        (Decode.field "fileName" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "createdAt" Decode.string)
        (Decode.field "fileUrl" Decode.string)

imagesDecoder : Decode.Decoder (List Image)
imagesDecoder =
    Decode.list imageDecoder

encodeImage : Image -> Encode.Value
encodeImage image =
    let
        attributes =
            [ ( "imageId", Encode.int image.imageId )
            , ( "fileName", Encode.string image.fileName )
            , ( "description", Encode.string image.description )
            , ( "createdAt", Encode.string image.createdAt )
            , ( "fileUrl", Encode.string image.fileUrl )
            ]
    in
    Encode.object attributes

encodeImageTitle: String ->  Encode.Value
encodeImageTitle imageTitle =
    let
        attributes =
            [ ( "imageTitle", Encode.string imageTitle )
            ]
    in
    Encode.object attributes