{-# LANGUAGE OverloadedStrings #-}

--
module Database ( dbMigration, createProfile ) where

import Database.Persist
import Database.Persist.Class
import Database.Persist.Sqlite as DbSql
import System.Environment
import qualified Data.Text as T
import Model
import Data.Maybe ( fromMaybe )
import Control.Monad.Trans.Resource
import Control.Monad.Trans.Control
import Control.Monad.Logger

-- Database connection string
databaseConnectionString :: IO T.Text
databaseConnectionString = do
    dbConnectionString <- lookupEnv "DATABASE_CONNECTION_URL"
    return $ T.pack $ fromMaybe "realworld.db" dbConnectionString

-- With connection to postgres
withDbRun :: SqlPersistT (NoLoggingT (ResourceT IO)) b -> IO b
withDbRun command = do
    connection <- databaseConnectionString
    runSqlite connection command

-- Run all migrations
dbMigration :: IO ()
dbMigration = withDbRun $ runMigration $ migrateAll

-- Queries
-- User Queries
createProfile :: User -> IO (Key User)
createProfile user = withDbRun $ DbSql.insert user
