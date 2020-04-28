module Services.Tags exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Models exposing (Tag)


apiUrl = "http://127.0.0.1:8000/api/tags"


type alias Tags = List Tag


type TagsMsg
    = OnFetchTags (Result Http.Error Tags)


fetchTags :  (Result Http.Error Tags -> msg) -> Cmd msg
fetchTags onFetch =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson onFetch tagsDecoder
    }


addTag : String -> (Result Http.Error Tag -> msg) -> Cmd msg
addTag tagName onSave =
    addTagRequest tagName onSave


addTagRequest : String -> (Result Http.Error Tag -> msg) -> Cmd msg
addTagRequest tagName onSave =
    Http.post
        { url = apiUrl
        , body = encodeTagName tagName |> Http.jsonBody
        , expect = Http.expectJson onSave tagDecoder
        }


tagDecoder : Decode.Decoder Tag
tagDecoder =
    Decode.map2 Tag
        (Decode.field "tagId" Decode.int)
        (Decode.field "tagName" Decode.string)


tagsDecoder : Decode.Decoder (List Tag)
tagsDecoder =
    Decode.list tagDecoder


encodeTag : Tag -> Encode.Value
encodeTag tag =
    let
        attributes =
            [ ( "tagId", Encode.int tag.tagId )
            , ( "tagName", Encode.string tag.tagName )
            ]
    in
    Encode.object attributes


encodeTagName: String ->  Encode.Value
encodeTagName tagName =
    let
        attributes =
            [ ( "tagName", Encode.string tagName )
            ]
    in
    Encode.object attributes