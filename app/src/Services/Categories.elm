module Services.Categories exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Models exposing (Category)

apiUrl = "http://127.0.0.1:8000/api/categories"

type alias Categories = List Category

type CategoriesMsg
    = OnFetchCategories (Result Http.Error Categories)


fetchCategories :  (Result Http.Error Categories -> msg) -> Cmd msg
fetchCategories onFetch =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson onFetch categoriesDecoder
    }

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


--updateCategory : Category -> Cmd CategoriesMsg
--updateCategory category =
--    updateCategoryRequest category


--updateCategoryRequest : Category -> Cmd CategoriesMsg
--updateCategoryRequest category =
--    Http.post
--        { url = updateCategoryUrl category.categoryId
--        , body = encodeCategory category |> Http.jsonBody
--        , expect = Http.expectJson OnCategorySave categoryDecoder
--        }   


--updateCategoryUrl : Int -> String
--updateCategoryUrl categoryId =
--    apiUrl ++ "/" ++ String.fromInt categoryId

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