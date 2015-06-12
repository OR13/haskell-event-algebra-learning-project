-----------------------------------------------------------------------------
-- |
-- Module      :  EStream.Parsec
-- Copyright   :  (C) 2014 Parnell Springmeyer
-- License     :  AllRightsReserved
-- Maintainer  :  Parnell Springmeyer <parnell@digitalmentat.com>
-- Stability   :  stable
--
-- Attoparsec parsers for parsing and filtering the log lines.
----------------------------------------------------------------------------

{-# LANGUAGE OverloadedStrings #-}

module EStream.Parsec where

import           Control.Applicative
import qualified Data.Map.Strict        as M
import qualified Data.Text              as T
import           Data.Time
import           Text.Parsec
import           Text.Parsec.ByteString as BP (GenParser)
import           Text.Parsec.Prim       as PP

import           EStream.Internal

datetimeParser :: BP.GenParser () st LocalTime
datetimeParser = do
    y  <- char '['      *>
          count 4 digit <* char '-'
    mm <- count 2 digit <* char '-'
    d  <- count 2 digit <* char ' '
    h  <- count 2 digit <* char ':'
    m  <- count 2 digit <* char ':'
    s  <- count 2 digit <* char ','
    _  <- count 3 digit <* char ']'
    return $
      LocalTime { localDay = fromGregorian (read y) (read mm) (read d)
                , localTimeOfDay = TimeOfDay (read h) (read m) (read s)
                }

propParser :: BP.GenParser () st (T.Text, Maybe T.Text)
propParser = do
    key <- propKeyParser
    val <- manyTill anyChar ((test' newline) PP.<|> (test' propKeyParser))
    return (T.pack key, if val == "" || val == "null"
                 then Nothing
                 else Just . T.strip $ T.pack val)

test' :: BP.GenParser () st a -> BP.GenParser () st ()
test' p = lookAhead $ try p >> return ()

propKeyParser :: BP.GenParser () st String
propKeyParser = many1 (noneOf "= \n\r") <* char '='

seriesBlockParser :: BP.GenParser () st Series
seriesBlockParser = do
    _     <- string "INFO"                  <* spaces
    ts    <- datetimeParser                 <* spaces
    _     <- manyTill anyChar (char ':')    <* spaces
    _     <- manyTill anyChar (test' propParser)    <* spaces
    prp   <- optionMaybe (many1 propParser) <* spaces

    return $ Series ts (fmap M.fromList prp)
