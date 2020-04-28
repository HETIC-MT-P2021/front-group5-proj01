module Pages.Top exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Http exposing (Error)
import Page exposing (Document, Page)
import Html.Attributes as Attr exposing (..)
import Html.Events as Events exposing (..)
import Json.Decode as Json
import Generated.Route as Route exposing (Route)
import Models exposing (Image, Images, Category, Categories, Tag, Tags)
import Services.Images exposing (fetchImages)
import Services.Categories exposing (fetchCategories)
import Services.Tags exposing (fetchTags)


type alias Flags =
    ()


type Msg
  = OnFetchImages (Result Http.Error Images)
  | OnFetchCategories (Result Http.Error Categories)
  | OnFetchTags (Result Http.Error Tags)
  | OnLoading
  | OnFailure
  | SetSelectedCategoryId String


type alias Model = {
    images : (List Image),
    categories : (List Category),
    tags : (List Tag),
    selectedCategoryId : String,
    selectedTagId : String
  }


initialState : Model
initialState =
  { images = []
    , categories = [
        {
          categoryId = 1,
          categoryName = "Une 1ère catégorie"
        }
        , {
          categoryId = 2,
          categoryName = "Une 2ème catégorie"
        }
        , {
          categoryId = 3,
          categoryName = "Une 3ème catégorie"
        }
      ]
    , tags = []
    , selectedCategoryId = "0"
    , selectedTagId = "0"
  }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


applyFilters : Image -> Bool
applyFilters image =
  image.imageId == 1


categoryOptionView : Category -> Html Msg
categoryOptionView category = 
  option [ value (category.categoryId |> String.fromInt) ] [ text category.categoryName ]


tagOptionView : Tag -> Html Msg
tagOptionView tag = 
  option [ value (tag.tagId |> String.fromInt) ] [ text tag.tagName ]


targetValueParseInt : Json.Decoder Int
targetValueParseInt =
  Json.at ["target", "value"] Json.int


filterBar : (Categories, Tags) -> Html Msg
filterBar (categories, tags) = 
  div [ class "app-sub-header" ] [
    div [ class "content-filters" ] [
      select [ class "filter-option-input", Events.on "change" (Json.map SetSelectedCategoryId targetValue) ] (
        [ option [ Attr.disabled True, Attr.selected True ] [ text "Catégories" ] ]
        ++ ( List.map (\category -> categoryOptionView category) categories)
      )
      , select [ class "filter-option-input", Attr.multiple False ] (
        [ option [ Attr.disabled True, Attr.selected True ] [ text "Tags" ] ]
        ++ ( List.map (\tag -> tagOptionView tag) tags)
      )
      , input [ class "filter-option-input", Attr.type_ "date" ] []
    ]
    , div [ class "add-image-wrapper" ] [
      a [ class "link font--h6", href (Route.toHref Route.Images_Create) ] [ text "Ajouter une image" ]
    ]
  ]


imageView : Image -> Html Msg
imageView image = 
  div [ class "galery-image-single-wrapper" ] [
    img [ class "galery-image-single"
      , src image.fileUrl
      ] []
  ]


galery : (Images, String) -> Html Msg
galery (images, selectedCategoryId) = 
  div [ class "galery-content" ] ( 
    List.map imageView (List.filter(\image -> image.imageId == Maybe.withDefault 0 (selectedCategoryId |> String.toInt)) images)
  )


fetchAllData : Cmd Msg
fetchAllData =
  Cmd.batch
    [ fetchCategories OnFetchCategories
      , fetchImages OnFetchImages
      , fetchTags OnFetchTags
    ]


init : () -> (Model, Cmd Msg)
init _ =
  ( initialState , fetchAllData )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnLoading ->
      (initialState, Cmd.none)
    OnFailure ->
      (initialState, Cmd.none)
    SetSelectedCategoryId selectedCategoryId ->
      ( { model | selectedCategoryId = selectedCategoryId }, Cmd.none )
    OnFetchCategories result ->
      case result of
        Ok categories ->
          ( { model | categories = categories } , Cmd.none)
        Err _ ->
          (model, Cmd.none)
    OnFetchImages result ->
      case result of
        Ok images ->
          ( { model | images = images } , Cmd.none)
        Err _ ->
          (model, Cmd.none)
    OnFetchTags result ->
      case result of
        Ok tags ->
          ( { model | tags = tags } , Cmd.none)
        Err _ ->
          (model, Cmd.none)


view : Model -> Document Msg
view model =
  { title = "Top"
    , body = [ 
      filterBar (model.categories, model.tags)
      , Html.text (model.selectedCategoryId)
      , galery (model.images, model.selectedCategoryId)
    ]
  }
