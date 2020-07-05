{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE StandaloneDeriving #-}

module Feature.Point.Types where

import Data.Text
--import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH


share [ mkPersist sqlSettings, mkDeleteCascade sqlSettings, mkMigrate "migrateAll" ][persistLowerCase|
  Point
    stream Text
    time Double
    value Text
    deriving Eq Show 
|]


