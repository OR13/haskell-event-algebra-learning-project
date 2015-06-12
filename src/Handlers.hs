{-# LANGUAGE DoAndIfThenElse       #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module Handlers where

import           Application
import           Control.Applicative
import           Control.Lens
import           Control.Monad.State
import           Data.ByteString.Char8   as C8
import           Data.Version            (showVersion)
import qualified Network.WebSockets.Snap as WS
import           Paths_estream             (version)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.RedisDB

import           EStream.Internal
import           EStream.Tail

handleVersion :: AppHandler ()
handleVersion = do
    modifyResponse $ setResponseCode 200
    writeBS . C8.pack $ showVersion version

handleDeviceLog :: AppHandler ()
handleDeviceLog = do

    -- Get accountID and deviceID
    aid <- getParam "accountID"
    did <- getParam "deviceID"

    con <- gets $ view (redis . snapletValue . redisConnection)

    WS.runWebSocketsSnap $ logTail (Aid <$> aid) (Did <$> did) con
