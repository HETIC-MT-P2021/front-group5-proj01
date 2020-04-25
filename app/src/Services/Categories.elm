module Services.Categories exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Category =
    { id : String
    , name : String
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
        { url = saveCategoryUrl category.id
        , body = encode category |> Http.jsonBody
        , expect = Http.expectJson OnCategorySave categoryDecoder
        }   


saveCategoryUrl : String -> String
saveCategoryUrl categoryId =
    apiUrl ++ "/" ++ categoryId

-- JSON handler

categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.map2 Category
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)

categoriesDecoder : Decode.Decoder (List Category)
categoriesDecoder =
    Decode.list categoryDecoder

encode : Category -> Encode.Value
encode category =
    let
        attributes =
            [ ( "id", Encode.string category.id )
            , ( "name", Encode.string category.name )
            ]
    in
    Encode.object attributes