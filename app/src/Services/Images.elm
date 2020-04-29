module Services.Images exposing (..)

import Http
import File exposing (File)
import Json.Decode as Decode
import Json.Encode as Encode
import Models exposing (Image, Images)

apiUrl = "http://127.0.0.1:8000/api/image"

type alias ImageUrl = { fileUrl: String }

type ImagesMsg
    = OnFetchImages (Result Http.Error Images)
type alias PostImage =
    { fileName: String
    , fileUrl: String
    , categoryId: Int
    , tags: String
    , description: String
    }

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


addImage : PostImage -> (Result Http.Error Image -> msg) -> Cmd msg
addImage postImage onSave =
    addImageRequest postImage onSave

addImageRequest : PostImage -> (Result Http.Error Image -> msg) -> Cmd msg
addImageRequest postImage onSave =
    Http.post
        { url = apiUrl
        , body = encodePostImage postImage |> Http.jsonBody
        , expect = Http.expectJson onSave imageDecoder
        }


uploadImageFile : File -> (Result Http.Error ImageUrl -> msg) -> Cmd msg
uploadImageFile file onUpload =
    uploadImageFile file onUpload

uploadImageRequest : File -> (Result Http.Error ImageUrl -> msg) -> Cmd msg
uploadImageRequest file onUpload =
    Http.post
        { url = apiUrl ++ "/upload"
        , body = Http.fileBody file
        , expect = Http.expectJson onUpload fileUrlDecoder
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

fileUrlDecoder: Decode.Decoder ImageUrl
fileUrlDecoder = 
    Decode.map ImageUrl
        (Decode.field "fileUrl" Decode.string)

encodePostImage: PostImage -> Encode.Value
encodePostImage postImage =
    let
        attributes =
            [ ( "fileName", Encode.string postImage.fileName )
            , ( "description", Encode.string postImage.description )
            , ( "fileUrl", Encode.string postImage.fileUrl )
            , ( "categoryId", Encode.int postImage.categoryId )
            , ( "tags", Encode.string postImage.tags )
            ]
    in
    Encode.object attributes
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