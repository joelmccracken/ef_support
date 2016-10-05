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


completeTask : Int -> Model -> Model
completeTask id model = model


completeTasks : Model -> List Task
completeTasks model =
    List.filter (\t-> t.complete > 0) model.tasks


init : Params -> (Model, Cmd Msg)
init params =
    (Model params [] "", fetchBootstrap params.appDataUrl)



-- UPDATE

type Msg
  = MorePlease
  | BootstrapFetchSucceed (List Task)
  | FetchSucceed String
  | FetchFail Http.Error
  | TaskComplete Int


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
      ({ model | tasks = data }, Cmd.none)

    FetchFail x ->
      ({ model | output = Debug.log "fail" (toString x)}, Cmd.none)

    TaskComplete id -> (completeTask id model, Cmd.none)

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Tasks"]
    , ul [] <| List.map viewTask model.tasks
    ]


viewTask : Task -> Html Msg
viewTask task =
    li []
       [ text task.name
       , button [(onClick (TaskComplete task.id))] []

       ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


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
