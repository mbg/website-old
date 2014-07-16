--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Applicative ((<$>))
import           Data.Monoid         (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    {-match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls -}

    match "papers/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            
    match "articles/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "projects/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/project.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            
    match "teaching/**" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/project.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            
    create ["publications.html"] $ do
        route idRoute
        compile $ do
            papers <- recentFirst =<< loadAll "papers/*"
            articles <- recentFirst =<< loadAll "articles/*"
            let archiveCtx =
                    listField "posts"   postCtx (return papers)   `mappend`
                    listField "articles" postCtx (return articles) `mappend`
                    constField "title" "Publications"              `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/publications.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- recentFirst =<< loadAll "projects/*"
            let projectsCtx =
                    listField "posts" postCtx (return projects)   `mappend`
                    constField "title" "Projects"                `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/projects.html" projectsCtx
                >>= loadAndApplyTemplate "templates/default.html" projectsCtx
                >>= relativizeUrls
             
    match "resources.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "ideas.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls
                
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "papers/*"
            let indexCtx =
                    listField "posts" postCtx (return (take 3 posts))   `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls
                
    match "activities.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "teaching.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "ideas.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls
                
    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%e %B %Y" `mappend`
    defaultContext


    