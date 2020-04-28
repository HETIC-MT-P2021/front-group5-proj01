module Services.Categories exposing (Categories, Category, fetchCategory, fetchCategories, updateCategory, addCategory)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Category =
    { categoryId : Int
    , categoryName : String
    }

apiUrl = "http://127.0.0.1:8001/api/categories"

type alias Categories = List Category

fetchCategories :  (Result Http.Error Categories -> msg) -> Cmd msg
fetchCategories onFetch =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson onFetch categoriesDecoder
    }

fetchCategory: Maybe Int -> (Result Http.Error Category -> msg) ->  Cmd msg
fetchCategory categoryId onFetch =
    case categoryId of 
        Just id ->
            Http.get 
            { url = categoryByIdUrl id
            , expect = Http.expectJson onFetch categoryDecoder
            }
        Nothing -> 
            Cmd.none

addCategory : String -> (Result Http.Error Category -> msg) -> Cmd msg
addCategory categoryName onSave =
    addCategoryRequest categoryName onSave

addCategoryRequest : String -> (Result Http.Error Category -> msg) -> Cmd msg
addCategoryRequest categoryName onSave =
    Http.post
        { url = apiUrl
        , body = encodeCategoryName categoryName |> Http.jsonBody
        , expect = Http.expectJson onSave categoryDecoder
        }   


updateCategory : Category -> (Result Http.Error Category -> msg) -> Cmd msg
updateCategory category onUpdate =
    updateCategoryRequest category onUpdate


updateCategoryRequest : Category -> (Result Http.Error Category -> msg) -> Cmd msg
updateCategoryRequest category onUpdate =
    Http.request
       { method = "PUT"
        , headers = []
        , url = categoryByIdUrl category.categoryId
        , body = encodeCategory category |> Http.jsonBody
        , expect = Http.expectJson onUpdate categoryDecoder
        , timeout = Nothing
        , tracker = Nothing
        }   

categoryByIdUrl : Int -> String
categoryByIdUrl categoryId =
    apiUrl ++ "/" ++ String.fromInt categoryId



-- JSON handler

categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.map2 Category
        (Decode.field "categoryId" Decode.int)
        (Decode.field "categoryName" Decode.string)

categoriesDecoder : Decode.Decoder (List Category)
categoriesDecoder =
    Decode.list categoryDecoder

encodeCategory : Category -> Encode.Value
encodeCategory category =
    let
        attributes =
            [ ( "categoryId", Encode.int category.categoryId )
            , ( "categoryName", Encode.string category.categoryName )
            ]
    in
    Encode.object attributes

encodeCategoryName: String ->  Encode.Value
encodeCategoryName categoryName =
    let
        attributes =
            [ ( "categoryName", Encode.string categoryName )
            ]
    in
    Encode.object attributes