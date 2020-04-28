module Models exposing (..)

type alias Category = 
  { categoryId : Int
    , categoryName : String
  }
type alias Categories = List Category

type alias Tag = 
  { tagId : Int
    , tagName : String
  }
type alias Tags = List Tag

type alias TagAssoc = 
  { tagId : Int
    , imageId : Int
  }

type alias Image = 
  { imageId : Int
    , fileName : String
    , description : String
    , createdAt : String
    , fileUrl : String
    , categoryId : Int
  }
type alias Images = List Image