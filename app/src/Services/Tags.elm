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
addTag tagTitle onSave =
    addTagRequest tagTitle onSave


addTagRequest : String -> (Result Http.Error Tag -> msg) -> Cmd msg
addTagRequest tagTitle onSave =
    Http.post
        { url = apiUrl
        , body = encodeTagTitle tagTitle |> Http.jsonBody
        , expect = Http.expectJson onSave tagDecoder
        }


tagDecoder : Decode.Decoder Tag
tagDecoder =
    Decode.map2 Tag
        (Decode.field "tagName" Decode.int)
        (Decode.field "tagTitle" Decode.string)


tagsDecoder : Decode.Decoder (List Tag)
tagsDecoder =
    Decode.list tagDecoder


encodeTag : Tag -> Encode.Value
encodeTag tag =
    let
        attributes =
            [ ( "tagName", Encode.int tag.tagName )
            , ( "tagTitle", Encode.string tag.tagTitle )
            ]
    in
    Encode.object attributes


encodeTagTitle: String ->  Encode.Value
encodeTagTitle tagTitle =
    let
        attributes =
            [ ( "tagTitle", Encode.string tagTitle )
            ]
    in
    Encode.object attributes