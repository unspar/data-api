module Feature.Point.PG where

import ClassyPrelude
import Feature.Point.Types
--import Feature.Auth.Types
--import Feature.Common.Types
import qualified Platform.PG as PG
import qualified Database.PostgreSQL.Simple as PSQL


findPoints  :: PG.PG r m => m [Point]
findPoints = PG.withConn $ \conn -> (PSQL.query_ conn  "SELECT * FROM points LIMIT 1;":: IO [Point] )



