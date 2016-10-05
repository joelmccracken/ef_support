import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Task
import Debug

type alias Params =
    { appDataUrl : String}


main : Program (Params)
main =
  App.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { params : Params
  , tasks : List Task
  , output : String
  }


type alias Task = { name : String, id : Int, complete : Int}

init : Params -> (Model, Cmd Msg)
init params =
    (Model params [] "", fetchBootstrap params.appDataUrl)


fetchBootstrap : String -> Cmd Msg
fetchBootstrap url =
    Task.perform
      FetchFail
      BootstrapFetchSucceed
      (Http.get decodeBootstrap url)


decodeBootstrap : Json.Decoder (List Task)
decodeBootstrap =
    Json.at ["data", "tasks"] (Json.list decodeTask)

decodeTask =
    Json.object3
        Task
        ("name" := Json.string)
        ("id" := Json.int)
        ("complete" := Json.int)

-- UPDATE


type Msg
  = MorePlease
  | BootstrapFetchSucceed (List Task)
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      -- (model, getRandomGif model.topic)
      (model, Cmd.none)

    FetchSucceed newUrl ->
      -- (Model model.topic newUrl, Cmd.none)
      (model, Cmd.none)

    BootstrapFetchSucceed data ->
      -- (Model model.topic newUrl, Cmd.none)
      ((Debug.log "Model: " { model | tasks = data }), Cmd.none)

    FetchFail x ->
      ({ model | output = Debug.log "fail" (toString x)}, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [] --[text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [] [] --[src model.gifUrl] []
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
