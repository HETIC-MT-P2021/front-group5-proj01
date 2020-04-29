module Pages.Images.Create exposing (Flags, Model, Msg, page)

import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (Document, Page)
import File exposing (File, name)
import File.Select as Select
import Models exposing (Categories, Category, Tag, Tags, Image)
import Services.Categories exposing (fetchCategories)
import Services.Images exposing (uploadImageFile, addImage, ImageUrl)

type alias Flags =
    ()


type alias Model = {
      imageFile: Maybe File
      , description: String
      , selectedCategoryId: Maybe Int
      , selectedTags: String
      , fileUrl: String
      , categories: Maybe Categories
      , fileName: Maybe String
      , image: Maybe Image
    }


type Msg
    = ImageRequested
    | ImageLoaded File
    | OnFetchCategories (Result Error Categories)
    | SetImageDescription String
    | SetSelectedCategory String
    | SetSelectedTag String
    | SubmitForm
    | OnUploadFile (Result Error ImageUrl)
    | OnPostImage (Result Error Image)


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ({
      imageFile = Nothing
      , description = ""
      , selectedCategoryId = Nothing
      , selectedTags = ""
      , fileUrl = ""
      , categories = Nothing
      , image = Nothing
      , fileName = Nothing
    }, fetchCategories OnFetchCategories )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchCategories result ->
          case result of
            Ok fectchedCategories ->
              ( { model | categories = Just fectchedCategories }, Cmd.none)

            Err _ ->
              ( model, Cmd.none)

        ImageRequested ->
          ( model
          , Select.file ["image/png","image/jpg"] ImageLoaded
          )
        ImageLoaded file ->
          ( { model | imageFile = Just file, fileName = Just (File.name file)}
          , Cmd.none
          )

        SetImageDescription description ->
          ( { model | description = description }, Cmd.none)
        SetSelectedCategory categoryId -> 
          ( { model | selectedCategoryId = Just ( Maybe.withDefault 0 ( String.toInt categoryId) ) }, Cmd.none)
        SetSelectedTag tags -> 
          ( { model | selectedTags = tags }, Cmd.none)

        SubmitForm -> 
          case model.imageFile of
            Nothing ->
              ( model, Cmd.none)
            Just imageFile ->
              (model, uploadImageFile imageFile OnUploadFile)
        OnUploadFile result->
          case result of
            Ok fileUrl ->
              case model.selectedCategoryId of
                Just selectedCategoryId ->
                  case model.fileName of
                    Just fileName ->
                      ( { model | fileUrl = fileUrl.fileUrl }
                      , addImage { fileUrl = fileUrl.fileUrl
                        , categoryId = ( selectedCategoryId )
                        , fileName = fileName
                        , tags = model.selectedTags
                        , description = model.description
                      } OnPostImage)
                    Nothing ->
                      ( model, Cmd.none)
                Nothing ->
                  ( model, Cmd.none)
            Err _ ->
              ( model, Cmd.none)
        OnPostImage result ->
          case result of  
            Ok image ->
              ( { model | image = Just image }, Cmd.none )
            Err _ ->
              ( model, Cmd.none )

            
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Ajout d'une nouvelle image"
    , body = [
        case model.image of
          Nothing ->
            case model.imageFile of
              Nothing ->
                button [ onClick ImageRequested, id "addImageFileButton" ] [ text "Commençer par choisir un fichier" ]

              Just imageFile -> div [ id "addImageForm" ] [ 
                p 
                  [ style "white-space" "pre" ]
                  [ text ( File.name imageFile ) ]
                  , Html.form 
                    [ Html.Events.onSubmit SubmitForm] 
                    [ label [] 
                      [ text "Description de l'image"
                      , textarea 
                          [ placeholder "Description"
                          , value model.description
                          , onInput SetImageDescription ] []
                      ]
                    , case model.selectedCategoryId of 
                      Nothing ->
                        label []
                          [ text "Catégorie de l'image"
                          , select [
                            onInput SetSelectedCategory
                          ] [ categoriesOptionsList ( 
                            case model.categories of
                              Nothing ->
                                [ { categoryName = "Par défaut", categoryId = 0 } ]
                              Just categories ->
                                categories
                            )
                          ] 
                        ]
                      Just categoryId ->
                        label []
                          [ text "Catégorie de l'image"
                          , select [
                            onInput SetSelectedCategory
                            , value ( String.fromInt categoryId )
                          ] [ categoriesOptionsList (
                            case model.categories of
                              Nothing ->
                                [ { categoryName = "Par défaut", categoryId = 0 } ]
                              Just categories ->
                                categories
                            )] 
                        ]
                    , label [] 
                        [ text "Tags de l'image (format: plages,chats)"
                        , input 
                            [ type_ "text"
                            , placeholder "plages,chats"
                            , value model.selectedTags
                            , onInput SetSelectedTag ] []
                        ]
                    , button []
                      [ text "Enregister l'image"]
                    ]
                  ]
          Just image ->
            Html.p [] [ text "Bravo" ]
      ]
    }


categoriesOptionsList: Categories -> Html Msg 
categoriesOptionsList categories = optgroup [] 
   ( List.map 
    (\category ->
       Html.option [ 
         value (String.fromInt category.categoryId) 
        ] 
        [ text category.categoryName ]
      )
    categories)
