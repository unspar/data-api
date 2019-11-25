module Feature.Point.Types where


import Platform.AesonUtil

data Point = Point 
  { time :: UTCTime
  , value :: Double
  } deriving (Eq, Show)


newtype PointWrapper a = PointWrapper { pointWrapperPoint :: a } deriving (Eq, Show) 
data PointsWrapper a = PointsWrapper { pointsWrapperPoints :: [a], pointsWrapperArticlesCount :: Int } deriving (Eq, Show)

$(commonJSONDeriveMany
  [ ''Point
  , ''PointWrapper
  , ''PointsWrapper
  ])




