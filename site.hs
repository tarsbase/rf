{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Data.List (sortBy,isSuffixOf)
import GHC.IO.Encoding
import Hakyll
import Hakyll.Favicon (faviconsRules, faviconsField)
import System.FilePath.Posix (takeBaseName,takeDirectory,(</>))

main :: IO ()
main = do 
   setLocaleEncoding utf8
   hakyll $ do
      faviconsRules "icons/favicon.svg"
      match "humans.txt" $ do
         route idRoute
         compile copyFileCompiler

      match "css/*" $ do
         route   idRoute
         compile compressCssCompiler

      match (fromList ["about.md", "contact.md"]) $ do
         route $ cleanRoute
         compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls
            >>= cleanIndexUrls

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

      match "posts/*" $ do
         route $ cleanRoute
         compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            >>= cleanIndexUrls
            >>= cleanIndexHtmls

      match "index.html" $ do
         route idRoute
         compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                  listField "posts" postCtx (return posts) <> ctx
            getResourceBody
               >>= applyAsTemplate indexCtx
               >>= loadAndApplyTemplate "templates/default.html" indexCtx
               >>= relativizeUrls
               >>= cleanIndexUrls
               >>= cleanIndexHtmls

      match "templates/*" $ compile templateBodyCompiler

ctx :: Context String
ctx = defaultContext <>
      faviconsField

postCtx :: Context String
postCtx =
   (dateField "date" "%B %e, %Y") <> ctx

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
