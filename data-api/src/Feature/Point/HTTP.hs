module Feature.Point.HTTP
  ( 
  ) where
--import Web.Scotty.Trans

--class Monad m => Service m where
--  getPoints ::  m [Point]



{-
routes :: (Service m, MonadIO m) => ScottyT LText m ()
routes = do
  get "/api/points" $ do
    --curUser <- Auth.optionalUser
    --pagination <- parsePagination
    --pointFilter <- parsePointFilter
    result <- lift $ getPoints 
    json $ PointsWrapper result (length result)
-}




