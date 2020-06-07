module Feature.Point.Types where

import ClassyPrelude
import Platform.AesonUtil
import Database.PostgreSQL.Simple.FromRow


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


instance FromRow Point where
  fromRow = Point
    <$> field
    <*> field





