module Generated.Pages exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Generated.Route as Route exposing (Route)
import Global
import Page exposing (Bundle, Document)
import Pages.Top
import Pages.About
import Pages.Home
import Pages.NotFound
import Pages.Categories.Top
import Pages.Images.Top
import Pages.Categories.Create
import Pages.Images.Create



-- TYPES


type Model
    = Top_Model Pages.Top.Model
    | About_Model Pages.About.Model
    | Home_Model Pages.Home.Model
    | NotFound_Model Pages.NotFound.Model
    | Categories_Top_Model Pages.Categories.Top.Model
    | Images_Top_Model Pages.Images.Top.Model
    | Categories_Create_Model Pages.Categories.Create.Model
    | Images_Create_Model Pages.Images.Create.Model


type Msg
    = Top_Msg Pages.Top.Msg
    | About_Msg Pages.About.Msg
    | Home_Msg Pages.Home.Msg
    | NotFound_Msg Pages.NotFound.Msg
    | Categories_Top_Msg Pages.Categories.Top.Msg
    | Images_Top_Msg Pages.Images.Top.Msg
    | Categories_Create_Msg Pages.Categories.Create.Msg
    | Images_Create_Msg Pages.Images.Create.Msg



-- PAGES


type alias UpgradedPage flags model msg =
    { init : flags -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
    , update : msg -> model -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
    , bundle : model -> Global.Model -> Bundle Msg
    }


type alias UpgradedPages =
    { top : UpgradedPage Pages.Top.Flags Pages.Top.Model Pages.Top.Msg
    , about : UpgradedPage Pages.About.Flags Pages.About.Model Pages.About.Msg
    , home : UpgradedPage Pages.Home.Flags Pages.Home.Model Pages.Home.Msg
    , notFound : UpgradedPage Pages.NotFound.Flags Pages.NotFound.Model Pages.NotFound.Msg
    , categories_top : UpgradedPage Pages.Categories.Top.Flags Pages.Categories.Top.Model Pages.Categories.Top.Msg
    , images_top : UpgradedPage Pages.Images.Top.Flags Pages.Images.Top.Model Pages.Images.Top.Msg
    , categories_create : UpgradedPage Pages.Categories.Create.Flags Pages.Categories.Create.Model Pages.Categories.Create.Msg
    , images_create : UpgradedPage Pages.Images.Create.Flags Pages.Images.Create.Model Pages.Images.Create.Msg
    }


pages : UpgradedPages
pages =
    { top = Pages.Top.page |> Page.upgrade Top_Model Top_Msg
    , about = Pages.About.page |> Page.upgrade About_Model About_Msg
    , home = Pages.Home.page |> Page.upgrade Home_Model Home_Msg
    , notFound = Pages.NotFound.page |> Page.upgrade NotFound_Model NotFound_Msg
    , categories_top = Pages.Categories.Top.page |> Page.upgrade Categories_Top_Model Categories_Top_Msg
    , images_top = Pages.Images.Top.page |> Page.upgrade Images_Top_Model Images_Top_Msg
    , categories_create = Pages.Categories.Create.page |> Page.upgrade Categories_Create_Model Categories_Create_Msg
    , images_create = Pages.Images.Create.page |> Page.upgrade Images_Create_Model Images_Create_Msg
    }



-- INIT


init : Route -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
init route =
    case route of
        Route.Top ->
            pages.top.init ()
        
        Route.About ->
            pages.about.init ()
        
        Route.Home ->
            pages.home.init ()
        
        Route.NotFound ->
            pages.notFound.init ()
        
        Route.Categories_Top ->
            pages.categories_top.init ()
        
        Route.Images_Top ->
            pages.images_top.init ()
        
        Route.Categories_Create ->
            pages.categories_create.init ()
        
        Route.Images_Create ->
            pages.images_create.init ()



-- UPDATE


update : Msg -> Model -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update bigMsg bigModel =
    case ( bigMsg, bigModel ) of
        ( Top_Msg msg, Top_Model model ) ->
            pages.top.update msg model
        
        ( About_Msg msg, About_Model model ) ->
            pages.about.update msg model
        
        ( Home_Msg msg, Home_Model model ) ->
            pages.home.update msg model
        
        ( NotFound_Msg msg, NotFound_Model model ) ->
            pages.notFound.update msg model
        
        ( Categories_Top_Msg msg, Categories_Top_Model model ) ->
            pages.categories_top.update msg model
        
        ( Images_Top_Msg msg, Images_Top_Model model ) ->
            pages.images_top.update msg model
        
        ( Categories_Create_Msg msg, Categories_Create_Model model ) ->
            pages.categories_create.update msg model
        
        ( Images_Create_Msg msg, Images_Create_Model model ) ->
            pages.images_create.update msg model
        
        _ ->
            always ( bigModel, Cmd.none, Cmd.none )



-- BUNDLE - (view + subscriptions)


bundle : Model -> Global.Model -> Bundle Msg
bundle bigModel =
    case bigModel of
        Top_Model model ->
            pages.top.bundle model
        
        About_Model model ->
            pages.about.bundle model
        
        Home_Model model ->
            pages.home.bundle model
        
        NotFound_Model model ->
            pages.notFound.bundle model
        
        Categories_Top_Model model ->
            pages.categories_top.bundle model
        
        Images_Top_Model model ->
            pages.images_top.bundle model
        
        Categories_Create_Model model ->
            pages.categories_create.bundle model
        
        Images_Create_Model model ->
            pages.images_create.bundle model


view : Model -> Global.Model -> Document Msg
view model =
    bundle model >> .view


subscriptions : Model -> Global.Model -> Sub Msg
subscriptions model =
    bundle model >> .subscriptions