module Lib
    ( main
    ) where
import ClassyPrelude
import qualified Platform.HTTP as HTTP
import qualified Platform.PG as PG
import qualified Platform.JWT as JWT

import qualified Feature.Point.HTTP as PT_HTTP
import qualified Feature.Point.PG as PT_PG
import qualified Feature.Point.Service as PT_SERVICE


main :: IO ()
main = do
  -- acquire resources
  pgEnv <- PG.init
  jwtEnv <- JWT.init
  -- start the app
  let runner app = flip runReaderT (pgEnv, jwtEnv) $ unAppT app
  HTTP.main runner

type Env = (PG.Env, JWT.Env)

newtype AppT a = AppT
  { unAppT :: ReaderT Env IO a
  } deriving  ( Applicative, Functor, Monad
              , MonadIO, MonadReader Env)

instance PT_HTTP.Service AppT where
  getPoints = PT_SERVICE.getPoints

instance PT_SERVICE.PointRepo AppT where
  findPoints = PT_PG.findPoints
  

