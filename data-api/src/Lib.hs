module Lib
  ( main
  ) where
import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import Feature.Point.HTTP

--import Database
main :: IO ()
main = do
  -- Run migrations
  --dbMigration
  -- Start  application server
  --quickHttpServe mainRouter
  quickHttpServe site


mainRouter :: Snap ()
mainRouter =  route [ ("", writeBS "") -- Base / route
                    , ("point", pointRouter) -- /bookmarks route
                    ]

pointRouter :: Snap ()
pointRouter =  route [ ("", method GET  pointIndex)  
                     , (    "", method POST  pointPost) 
                     , ("/:id", method GET pointGet)  
                     --, ("/:id", method PUT pointPut)
                     --, ("/:id", method DELETE pointDelete)
                     ]



pointIndex :: Snap ()
pointIndex = do
  -- Get the limit and start paramters (?limit=:limit&start=:start) if sent
  maybeLimitTo  <- getParam "limit"
  maybeOffsetBy <- getParam "start"
  maybeCollection <- getParam "collection"
  -- Get a list or array of bookmarks from the database
  points <- liftIO $ getPoints maybeCollection maybeLimitTo maybeOffsetBy
  -- Set the content type to JSON
  -- We will be responding with JSON
  modifyResponse $ setHeader "Content-Type" "application/json"
  -- Write out the JSON response
  writeLBS $ encode $ Prelude.map entityIdToJSON points


site :: Snap ()
site = ifTop (writeBS "hello world")
  <|> route [ ( "foo", writeBS "bar" ), ( "echo/:echoparam", echoHandler ) ]
  <|> dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
  param <- getParam "echoparam"
  maybe (writeBS "must specify echo/param in URL") writeBS param
