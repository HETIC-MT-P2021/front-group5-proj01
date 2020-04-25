module Services.Categories exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Category =
    { categoryId : Int
    , categoryName : String
    }

apiUrl = "http://127.0.0.1:8001/api/categories"

type alias Categories = List Category

type CategoriesMsg
    = OnFetchCategories (Result Http.Error Categories)
    | OnCategorySave (Result Http.Error Category)


fetchCategories :  Cmd CategoriesMsg
fetchCategories =
    Http.get 
    { url = apiUrl
    , expect = Http.expectJson OnFetchCategories categoriesDecoder
    }


saveCategory : Category -> Cmd CategoriesMsg
saveCategory category =
    saveCategoryRequest category


saveCategoryRequest : Category -> Cmd CategoriesMsg
saveCategoryRequest category =
    Http.post
        { url = saveCategoryUrl category.categoryId
        , body = encode category |> Http.jsonBody
        , expect = Http.expectJson OnCategorySave categoryDecoder
        }   


saveCategoryUrl : Int -> String
saveCategoryUrl categoryId =
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

encode : Category -> Encode.Value
encode category =
    let
        attributes =
            [ ( "categoryId", Encode.int category.categoryId )
            , ( "categoryName", Encode.string category.categoryName )
            ]
    in
    Encode.object attributes