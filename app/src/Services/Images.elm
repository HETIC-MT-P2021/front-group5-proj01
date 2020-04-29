module Services.Images exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Models exposing (Image)

apiUrl = "http://127.0.0.1:8000/api/image"

type alias Images = List Image

type ImagesMsg
    = OnFetchImages (Result Http.Error Images)


fetchImages :  (Result Http.Error Images -> msg) -> Cmd msg
fetchImages onFetch =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson onFetch imagesDecoder
    }


fetchImage: Maybe Int -> (Result Http.Error Image -> msg) ->  Cmd msg
fetchImage imageId onFetch =
    case imageId of 
        Just id ->
            Http.get 
            { url = imageByIdUrl id
            , expect = Http.expectJson onFetch imageDecoder
            }
        Nothing -> 
            Cmd.none

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

updateImage : Image -> (Result Http.Error Image -> msg) -> Cmd msg
updateImage image onUpdate =
    updateImageRequest image onUpdate

updateImageRequest : Image -> (Result Http.Error Image -> msg) -> Cmd msg
updateImageRequest image onUpdate =
    Http.request
       { method = "PUT"
        , headers = []
        , url = imageByIdUrl image.imageId
        , body = encodeImage image |> Http.jsonBody
        , expect = Http.expectJson onUpdate imageDecoder
        , timeout = Nothing
        , tracker = Nothing
        }  

imageDecoder : Decode.Decoder Image
imageDecoder =
    Decode.map6 Image
        (Decode.field "imageId" Decode.int)
        (Decode.field "fileName" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "createdAt" Decode.string)
        (Decode.field "fileUrl" Decode.string)
        (Decode.field "categoryId" Decode.int)

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
            , ( "categoryId", Encode.int image.categoryId )
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

imageByIdUrl : Int -> String
imageByIdUrl imageId =
    apiUrl ++ "/" ++ String.fromInt imageId