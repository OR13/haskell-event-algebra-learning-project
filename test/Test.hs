{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import           Data.Text            as T

import           Control.Applicative
import           Data.Attoparsec.Text
import           EStream.Attoparsec
import           Test.HUnit
import           Test.Tasty
import           Test.Tasty.HUnit

main :: IO ()
main = defaultMain tests

instance AssertionPredicable (Either a b) where
    assertionPredicate (Right _) = return True
    assertionPredicate (Left  _) = return False

tests :: TestTree
tests = testGroup "Tests" [parserDatetimeTests, noiseTests, propParseTests]

parserDatetimeTests :: TestTree
parserDatetimeTests = testGroup "Datetime Parser Tests"
    [ (testCase "Parse Time"      $
        (parseOnly timeParser     $
          T.pack "09:39:11.583")              @? "Parsing time failed")
    , (testCase "Parse Datetime"  $
        (parseOnly datetimeParser $
          T.pack "[2014-07-22 14:39:09,828]") @? "Parsing datetime failed")
    ]

noiseTests :: TestTree
noiseTests = testGroup "Noise Parsing Tests"
    [ (testCase "Parse Noisy Shit" $
        (parseOnly sessionMatch   $
          T.pack "ClientSession org.opengts.servers.template.TrackClientPacketHandler: tracker.gps.input.parsed")            @? "Parsing noise failed") ]

propParseTests :: TestTree
propParseTests = testGroup "Property Parsing Tests"
    [ (testCase "Parse Properties" $
        (parseOnly (many1 (propParser <* skipSpace))   $
          T.pack "accountID=ahmsa deviceID=25 uniqueID=528661655255 equipmentType= statusCode=61472 timestamp=1406021946 state=i(0,0,0,0,0),o(0,0,0,0,0) lat=26.884018333333334 lon=-101.41157 speed=0.0 ad1=0.8440233236151603 ad2=0.0 geozoneId=null routeId=null uuid=7c8d4220-6f99-4b21-b331-d33f87494d6a") @? "Parsing properties failed") ]
