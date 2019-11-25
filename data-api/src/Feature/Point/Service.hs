module Feature.Point.Service where

import ClassyPrelude
import Control.Monad.Except
--import Feature.Point.Types
--import Feature.Auth.Types
--import Feature.Common.Types
import qualified Web.Slug as WSlug
import Data.Convertible (convert)
--import System.Posix.Types (EpochTime)

getArticles :: (ArticleRepo m) => Maybe CurrentUser -> ArticleFilter -> Pagination -> m [Article]
getArticles = findArticles Nothing Nothing

