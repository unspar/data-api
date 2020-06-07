module Feature.Point.HTTP
  ( routes
  , Service(..)
  ) where
import ClassyPrelude
import Feature.Point.Types
import Web.Scotty.Trans

class Monad m => Service m where
  getPoints ::  m [Point]




routes :: (Service m, MonadIO m) => ScottyT LText m ()
routes = do
  get "/api/points" $ do
    --curUser <- Auth.optionalUser
    --pagination <- parsePagination
    --pointFilter <- parsePointFilter
    result <- lift $ getPoints 
    json $ PointsWrapper result (length result)




