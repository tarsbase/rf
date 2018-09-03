{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Data.List (sortBy,isSuffixOf)
import Data.Typeable
import GHC.IO.Encoding
import Hakyll
import Hakyll.Favicon (faviconsRules, faviconsField)
import System.FilePath.Posix (takeBaseName,takeDirectory,(</>))

main :: IO ()
main = do 
   
   -- Set the encoding so w3c doesnt complain
   setLocaleEncoding utf8
   hakyll $ do

      -- Generate the favicons
      faviconsRules "icons/favicon.svg"

      -- Straight copying of files
      match (fromList ["humans.txt", "robots.txt", "fonts/*"]) $ do
         route idRoute
         compile copyFileCompiler

      -- CSS needs to be compiled and minified
      match "css/*" $ do
         route   idRoute
         compile compressCssCompiler

      -- Load pages that need to be formatted
      match (fromList ["about.md", "contact.md"]) $ do
         route $ cleanRoute
         compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls
            >>= cleanIndexUrls

      -- Render Atom + Rss feeds
      create ["atom.xml"] $ do
         route idRoute
         (compileFeed renderAtom)

      create ["rss.xml"] $ do
         route idRoute
         (compileFeed renderRss)

      -- Compile the templates
      match "templates/*" $ compile templateBodyCompiler

      -- Compile the archive page and post list
      match "archive.md" $ do
         route $ cleanRoute
         compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/archive.html" ctx
            >>= relativizeUrls
            >>= cleanIndexUrls

         compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                  listField "posts" postCtx (return posts) <>
                  ctx
            pandocCompiler
               >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
               >>= loadAndApplyTemplate "templates/default.html" archiveCtx
               >>= relativizeUrls
               >>= cleanIndexUrls

      -- Compile posts + save snapshots for the web feeds
      match "posts/*" $ do
         route $ cleanRoute
         compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            >>= cleanIndexUrls
            >>= cleanIndexHtmls

      -- Compile and load posts
      match "index.html" $ do
         route idRoute
         compile $ do
            posts <- (return . (take 5))
                     =<< recentFirst
                     =<< loadAll "posts/*"
            let indexCtx =
                  listField "posts" postCtx (return posts) <> ctx
            getResourceBody
               >>= applyAsTemplate indexCtx
               >>= loadAndApplyTemplate "templates/default.html" indexCtx
               >>= relativizeUrls
               >>= cleanIndexUrls
               >>= cleanIndexHtmls

-- Agnememnon the Fuck-Upperer - Conquerer of Small Type Declarations
compileFeed ::
   (FeedConfiguration
      -> Context String
      -> [Item String]
      -> Compiler (Item String)
   ) -> Rules ()
-- For those left alive, this abstracts out creating
-- Atom and RSS feeds
compileFeed f = compile $ do
   let feedCtx = postCtx <>
                 bodyField "description"
   posts <- fmap (take 10) . recentFirst
      =<< loadAllSnapshots "posts/*" "content"
   f feedConfig feedCtx posts

-- The configuration for our Atom/RSS feeds
feedConfig :: FeedConfiguration
feedConfig = FeedConfiguration {
      feedTitle = "Regular Flolloping"
   ,  feedDescription = "tA's Blog"
   ,  feedAuthorName = "Shaun Kerr"
   ,  feedAuthorEmail = "s@p7.co.nz"
   ,  feedRoot = "https://regularflolloping.com"
   }

-- Our default context for pages
ctx :: Context String
ctx = defaultContext <>
      faviconsField

-- Default context for posts
postCtx :: Context String
postCtx =
   (dateField "date" "%B %e, %Y") <> ctx

-- Functions to convert pages to /name/index.html
cleanRoute :: Routes
cleanRoute = customRoute createIndexRoute
   where
      createIndexRoute ident =
         takeDirectory p </> takeBaseName p </> "index.html"
            where p = toFilePath ident

cleanIndexUrls :: Item String -> Compiler (Item String)
cleanIndexUrls = return . fmap (withUrls cleanIndex)

cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (replaceAll pattern replacement)
   where
      pattern = "/index.html"
      replacement = const "/"

cleanIndex :: String -> String
cleanIndex url
    | idx `isSuffixOf` url = take (length url - length idx) url
    | otherwise            = url
   where idx = "index.html"
