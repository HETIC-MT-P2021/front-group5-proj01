module Pages.Images.Dynamic exposing (..)

import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page exposing (Document, Page)
import Services.Images exposing (fetchImage, updateImage)
import Generated.Route as Route exposing (Route)
import Models exposing (Image)

type alias Flags =
    { param1 : String }


type Model 
    = Waiting Image
    | Failure
    | Loading
    | UpdateSuccess Image


type Msg = SubmitForm
    | SetImageName String
    | OnImageUpdate (Result Error Image)
    | OnImageFetch (Result Error Image)

page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Loading
    , fetchImage ( String.toInt flags.param1 ) OnImageFetch )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetImageName fileName ->
        case model of 
            Waiting image ->
                (Waiting 
                    { imageId = image.imageId
                    , description = image.description  
                    , createdAt = image.createdAt  
                    , fileUrl = image.fileUrl  
                    , categoryId = image.categoryId  
                    , fileName = fileName  
                }, Cmd.none)
            _ ->
                (model, Cmd.none)
    OnImageFetch result -> 
        case result of
            Ok image ->
                (Waiting image, Cmd.none)

            Err _ ->
                (Failure, Cmd.none)
    OnImageUpdate result ->
        case result of
            Ok image ->
                (UpdateSuccess image, Cmd.none)

            Err _ ->
                (Failure, Cmd.none)
    SubmitForm ->
        case model of 
            Waiting image ->
                (Loading, updateImage image OnImageUpdate ) 
            _ ->
                (model, Cmd.none)
            
    
    

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


imageView : Image -> Html Msg
imageView image =
  div [ class "details-image-container" ] [
    div [ class "details-image-single-wrapper" ] [
      img [ class "details-image-single" , src image.fileUrl ] []
    ]
    , Html.form 
      [ class "image-form", Html.Events.onSubmit SubmitForm] 
      [
        label [ ] 
          [ Html.text "Nom"
          , Html.input 
              [ type_ "text"
              , placeholder "Nom de l'image"
              , value image.fileName
              , disabled True
              , class "form-control"
              , id "imageNameInput" ] []
          ]
        , label [ ] 
          [ Html.text "Description"
          , Html.textarea 
              [ placeholder "Description de l'image"
              , value image.description
              , disabled True
              , class "form-control"
              , id "imageDescriptionInput" ] []
          ]
        , button [ id "imageSubmitButton", hidden True ]
          [ Html.text "Mettre à jour"]
      ]
  ]


view : Model -> Document Msg
view model =
  case model of
    Waiting image -> 
        { title = "Détails | " ++ image.fileName
        , body = [
            div [ class "app-content" ] [
              Html.a [ class "link addImageButtons", href (Route.toHref Route.Top) ] [ Html.text "< Retour" ]
              , imageView image
            ]
          ]
        }
    Failure ->
      { title = "Détails d'une image"
      , body = [ Html.text "Impossible de récupérer ou mettre à jour l'image"]
      }

    Loading ->
      { title = "Détails d'une image"
      , body = [ Html.text "Chargement..." ]
      }

    UpdateSuccess image ->
      { title = "Modification d'une image"
      , body = [ 
          Html.h2 [] [ Html.text ("L'image " ++ image.fileName ++ " à été mise à jour") ] 
          , imageView image
          , Html.a [ class "link addImageButtons", href (Route.toHref Route.Top) ] [ Html.text "Retour à la liste des images" ]
        ]
      }