module Feature.Point.HTTP
	( routes
  , Service(..)
  ) where




class Monad m => Service m where
  getPoints :: Maybe CurrentUser -> ArticleFilter -> Pagination -> m [Article]
 )




routes :: (Auth.Service m, Service m, MonadIO m) => ScottyT LText m ()
routes = do
  get "/api/points" $ do
    curUser <- Auth.optionalUser
    pagination <- parsePagination
    pointFilter <- parsePointFilter
    result <- lift $ getPoints curUser pointFilter pagination
    json $ ArticlesWrapper result (length result)




