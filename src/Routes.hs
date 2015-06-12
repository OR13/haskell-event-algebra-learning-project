{-# LANGUAGE OverloadedStrings #-}

module Routes
  ( appRoutes
  ) where

import           Application         (AppHandler)
import           Data.ByteString     (ByteString)
import           Handlers
import           Snap.Core
import           Snap.Util.FileServe

appRoutes :: [(ByteString, AppHandler ())]
appRoutes = [
              ("version",  method GET handleVersion)
            , ("/logs/:accountID/:deviceID", method GET handleDeviceLog)
            , ("/logs"                     , method GET handleDeviceLog)
            , ("/static",  serveDirectory "static")
            ]
