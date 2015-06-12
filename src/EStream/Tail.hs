-----------------------------------------------------------------------------
-- |
-- Module      :  EStream.Tail
-- Copyright   :  (C) 2014 Parnell Springmeyer
-- License     :  AllRightsReserved
-- Maintainer  :  Parnell Springmeyer <parnell@digitalmentat.com>
-- Stability   :  stable
--
-- Library file providing the function to kick-off `watch`ing the
-- specified directory and composable `pipes` based functions for
-- building a pipeline to handle the new firmware archive event.
--
-- Specifically, we want to log the name of the file when we yield it,
-- stream its contents off of the disk through `pipes-zlib` and move
-- it to another location with a canonicalized name. Then we want to
-- publish an upgrade message using AMQP to the registered devices
-- (shouldn't they be "subscribed" though? This might be a TODO).
----------------------------------------------------------------------------

{-# LANGUAGE OverloadedStrings #-}

module EStream.Tail where

import           Control.Concurrent       (threadDelay)
import           Control.Concurrent.Async
import           Control.Monad            (forever)
import           Control.Monad.IO.Class
import           Data.Aeson
import qualified Data.ByteString.Char8    as C8
import qualified Data.ByteString.Lazy     as LB
import qualified Data.Map                 as M
import           Data.Maybe
import           Data.Monoid
import qualified Data.Text                as T
import qualified Data.Text.Encoding       as TE
import           Database.Redis
import qualified Network.WebSockets       as WS
import           Pipes.Concurrent
import           Text.Parsec

import           EStream.Internal
import           EStream.Parsec

type Out = Output T.Text

-- | Given specific account and device ids, and the logfile open up a
-- websocket connection and stream annexed data in the log to the
-- websocket client.
logTail :: Maybe Aid -> Maybe Did -> Connection -> WS.ServerApp
logTail aid did redisConn pending = do
    conn            <- WS.acceptRequest pending

    _ <- async . forever $ threadDelay 5000000 >> WS.sendPing conn ("ping" :: T.Text)

    liftIO $ runRedis redisConn $ pubSub (subscribe ["raw_gps"]) $ \msg -> do
        let s = parseBlock msg aid did
        WS.sendTextData conn s
        return mempty

parseBlock :: Message -> Maybe Aid -> Maybe Did -> T.Text
parseBlock msg a d = case parse (optionMaybe seriesBlockParser) "" (C8.concat [(msgMessage msg), "\n"]) of
        Left  e        -> T.pack $ show e
        Right Nothing  -> T.pack "Unknown line encountered.."
        Right (Just s) -> TE.decodeUtf8 . LB.toStrict . encode $ filterCriteria a d [s]

filterCriteria :: Maybe Aid -> Maybe Did -> [Series] -> [Series]
filterCriteria (Just (Aid aid)) (Just (Did did)) = filter (seriesPred "deviceID" did) . filter (seriesPred "accountID" aid)
filterCriteria Nothing          (Just (Did did)) = filter (seriesPred "deviceID" did)
filterCriteria (Just (Aid aid)) Nothing          = filter (seriesPred "accountID" aid)
filterCriteria Nothing Nothing                   = filter (notEmpty "accountID")

query :: T.Text -> Maybe (M.Map T.Text (Maybe T.Text)) -> Maybe T.Text
query t   = fromMaybe Nothing . maybe Nothing (M.lookup t)

testQ :: C8.ByteString -> Maybe T.Text -> Bool
testQ d = (==) (Just (TE.decodeUtf8 d))

seriesPred :: T.Text -> C8.ByteString -> Series -> Bool
seriesPred t d  = (testQ d) . (query t) . properties

notEmpty :: T.Text -> Series -> Bool
notEmpty t = isJust . (query t) . properties
