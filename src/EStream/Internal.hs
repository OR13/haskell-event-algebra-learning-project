-----------------------------------------------------------------------------
-- |
-- Module      :  EStream.Internal
-- Copyright   :  (C) 2014 Parnell Springmeyer
-- License     :  AllRightsReserved
-- Maintainer  :  Parnell Springmeyer <parnell@digitalmentat.com>
-- Stability   :  stable
--
-- Application types, mostly.
----------------------------------------------------------------------------

{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module EStream.Internal where

import           Data.Aeson
import           Data.ByteString.Char8     as C8
import qualified Data.Map.Strict           as M
import qualified Data.Text                 as T
import           Data.Time
import qualified Filesystem.Path.CurrentOS as FS

newtype Aid     = Aid C8.ByteString deriving (Eq, Ord)
newtype Did     = Did C8.ByteString deriving (Eq, Ord)
newtype LogFile = LogFile {unLogFile :: FS.FilePath }

-- | Log entry grouping.
data Series = Series
    { timestamp  :: LocalTime
    , properties :: Maybe (M.Map T.Text (Maybe T.Text))
    } deriving (Eq, Ord, Show)

instance ToJSON Series where
    toJSON (Series t p) =
         object [
           "timestamp" .= t,
           "properties".= p
         ]

instance ToJSON LocalTime where
    toJSON t = String . T.pack $ show t

