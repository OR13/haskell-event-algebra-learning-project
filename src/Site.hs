{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Database.Redis       (defaultConnectInfo)
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Snaplet.RedisDB

------------------------------------------------------------------------------
import           Application
import           Routes

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    d <- nestSnaplet "" redis $ redisDBInit defaultConnectInfo
    addRoutes appRoutes
    return $ App h d

