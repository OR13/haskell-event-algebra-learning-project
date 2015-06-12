{-# LANGUAGE TemplateHaskell #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import           Control.Lens
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Snaplet.RedisDB

------------------------------------------------------------------------------
data App = App
    { _heist :: Snaplet (Heist App)
    , _redis :: Snaplet RedisDB
    }

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist


------------------------------------------------------------------------------
type AppHandler = Handler App App

