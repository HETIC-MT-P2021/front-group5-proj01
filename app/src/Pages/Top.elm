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
  | SetSelectedTagId String
  | SetSelectedDate String


type alias Model = {
    images : (List Image),
    categories : (List Category),
    tags : (List Tag),
    selectedDate : String,
    selectedCategoryId : String,
    selectedTagId : String
  }


initialState : Model
initialState =
  { images = []
    , categories = []
    , tags = [
      {
        tagId = 1,
        tagName = "Un tag"
      }
      , {
        tagId = 2,
        tagName = "Un 2ème tag"
      }
      , {
        tagId = 3,
        tagName = "Un 3ème tag"
      }
      , {
        tagId = 4,
        tagName = "Un 4ème tag"
      }
      , {
        tagId = 5,
        tagName = "Un 5ème tag"
      }
      , {
        tagId = 6,
        tagName = "Un 6ème tag"
      }
      , {
        tagId = 7,
        tagName = "Un 7ème tag"
      }
    ]
    , selectedDate = "0"
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
      , select [ class "filter-option-input", Attr.multiple False, Events.on "change" (Json.map SetSelectedTagId targetValue) ] (
        [ option [ Attr.disabled True, Attr.selected True ] [ text "Tags" ] ]
        ++ ( List.map (\tag -> tagOptionView tag) tags)
      )
      , input [ class "filter-option-input", Attr.type_ "date", Events.onInput SetSelectedDate ] []
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


galery : Model -> Html Msg
galery model = 
  div [ class "galery-content" ] ( 
    List.map imageView (List.filter(
      \image -> 
        ((
          image.categoryId == Maybe.withDefault 0 (model.selectedCategoryId |> String.toInt)
          && (String.contains model.selectedDate image.createdAt)
          -- TODO: Replace @image.imageId here by image.tags.contains ...
          && image.imageId == Maybe.withDefault 0 (model.selectedTagId |> String.toInt)
        )
    )) model.images)
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
    SetSelectedTagId selectedTagId ->
      ( { model | selectedTagId = selectedTagId }, Cmd.none )
    SetSelectedDate selectedDate ->
      ( { model | selectedDate = selectedDate }, Cmd.none )
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
          ( model, Cmd.none)
        Err _ ->
          (model, Cmd.none)


view : Model -> Document Msg
view model =
  { title = "Top"
    , body = [ 
      filterBar (model.categories, model.tags)
      , galery model
    ]
  }
