import Html exposing (..)
import Html.Events exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json exposing ((:=))
import Task


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Post =
  { author : String
  , text : String
  }

type alias Model =
  { posts : List Post
  }


-- UPDATE
type Msg
  = GetAuthors
  | FetchSucceed (List Post)
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetAuthors ->
      (model, getAuthors)

    FetchSucceed posts ->
      (Model posts, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP
getAuthors : Cmd Msg
getAuthors =
  let
    url =
      "https://in-development.firebaseio.com/posts.json"
  in
    Task.perform FetchFail FetchSucceed (Http.get (Json.list decodePost) url)


decodePost : Json.Decoder Post
decodePost =
  Json.object2
    Post
    ("author" := Json.string)
    ("text" := Json.string)


-- VIEW
view : Model -> Html.Html Msg
view model =
  div []
      [ texts model.posts
      , button [ onClick GetAuthors ]
               [ text "Get authors" ]
      ]


texts : List Post -> Html.Html Msg
texts posts =
  let
    textRow post =
      div []
          [ text post.text ]

    textList = List.map textRow posts

  in
    div []
        textList


-- INIT
init : (Model, Cmd Msg)
init =
  (Model [], Cmd.none)


