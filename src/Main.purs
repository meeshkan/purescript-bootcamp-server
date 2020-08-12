module Main where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Payload.Server as Payload
import Payload.Spec (Spec(Spec), GET)

type Message
  = { id :: Int
    , text :: String
    }

type Post
  = { id :: Int
    , author :: String
    , markdown :: String
    }

spec ::
  Spec
    { getMessages ::
        GET "/users/<id>/messages?limit=<limit>"
          { params :: { id :: Int }
          , query :: { limit :: Int }
          , response :: Array Message
          }
    , getPosts ::
        GET "/users/<id>/posts?limit=<limit>"
          { params :: { id :: Int }
          , query :: { limit :: Int }
          , response :: Array Post
          }
    }
spec = Spec

getMessages :: { params :: { id :: Int }, query :: { limit :: Int } } -> Aff (Array Message)
getMessages { params: { id }, query: { limit } } =
  pure
    [ { id: 1, text: "Hey there " <> show id }, { id: 2, text: "Limit " <> show limit } ]

getPosts :: { params :: { id :: Int }, query :: { limit :: Int } } -> Aff (Array Post)
getPosts { params: { id }, query: { limit } } =
  pure
    [ { id: 1, author: "Mike", markdown: "# Hello" } ]

handlers = { getMessages, getPosts }

main :: Effect Unit
main = Payload.launch spec handlers
