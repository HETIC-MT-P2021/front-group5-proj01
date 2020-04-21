module Models exposing (Category, Tag, TagAssoc, Image)

type alias Category = 
  { id : Int
    , name : String
  }

type alias Tag = 
  { id : Int
    , name : String
  }

type alias TagAssoc = 
  { tagId : Int
    , imageId : Int
  }

type alias Image = 
  { id : Int
    , title : String
    , description : String
    , date : String
    , categoryId : Int
    , imageUrl : String
  }