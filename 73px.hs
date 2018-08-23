#!/usr/bin/env stack
{- stack
    --resolver lts-12.2
    script
    --package text
    --package scotty
    --package blaze-html
    --package wai-middleware-static
    --package wai-extra
    --package optparse-applicative
    --package filepath
    --package directory
 -}

{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Semigroup ((<>))
import           Network.Wai.Middleware.RequestLogger
import           Network.Wai.Middleware.Static
import           Options.Applicative
import           System.FilePath.Posix
import qualified Text.Blaze.Html.Renderer.Text as BHRT
import qualified Text.Blaze.Html5 as H5
import qualified Text.Blaze.Html5.Attributes as A5
import           Text.Printf
import           Web.Scotty

data Opts = Opts {
  optsPort :: Int
  , optsStaticDir :: FilePath
  } deriving Show;

-- <!-- Global site tag (gtag.js) - Google Analytics -->
-- <script async src="https://www.googletagmanager.com/gtag/js?id=UA-123351051-1"></script>
-- <script>
--   window.dataLayer = window.dataLayer || [];
--   function gtag(){dataLayer.push(arguments);}
--   gtag('js', new Date());

--   gtag('config', 'UA-123351051-1');
-- </script>

optsParser :: Parser Opts
optsParser = Opts
             <$> option auto (long "port"
                               <> help "Listen port"
                               <> showDefault
                               <> value 3000
                               <> metavar "INT")
             <*> strOption (long "static"
                             <> help "Static directory"
                             <> showDefault
                             <> value "./static"
                             <> metavar "STRING")

-- ga :: String -> H5.Html
-- ga gid = H5.script H5.! A5.src ("https://www.googletagmanager.com/gtag/js?id=" ++ gid) $ ""
--          >> H5.script $ unlines ["window.dataLayer = window.dataLayer || [];"
--                                  "function gtag(){dataLayer.push(arguments);}"
--                                  "gtag('js', new Date());"
--                                  "gtag('config', '" ++ gid ++ "');"]

ws :: Opts -> IO()
ws (Opts port staticDir) = scotty port $ do
  middleware $ staticPolicy $ addBase staticDir
  middleware logStdoutDev
  get "/" $ html $ BHRT.renderHtml $ H5.html $ do
    H5.title "73px"
    H5.body $ do
      H5.img H5.! A5.src "/73px.png" H5.! A5.style "display: block; margin-left: auto;margin-right: auto;"
      -- ga "UA-123351051-1"

main :: IO ()
main = ws =<< execParser opts
  where
    opts = info (optsParser <**> helper)
           (fullDesc <> progDesc "73px web site")

