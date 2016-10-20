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
completeTask id model =
  updateTask id model (\task-> { task | complete = 1 })

updateTask : Int -> Model -> (Task -> Task) -> Model
updateTask id model updater =
  let
    tasks = (List.map (\task-> if task.id == id then (updater task) else task)
              model.tasks)
  in
    { model | tasks = tasks }


incompleteTask : Int -> Model -> Model
incompleteTask id model =
  updateTask id model (\task-> {task | complete = 0 })



init : Params -> (Model, Cmd Msg)
init params =
  (Model params [] "", fetchBootstrap params.appDataUrl)



-- UPDATE

type Msg
  = MorePlease
  | BootstrapFetchSucceed (List Task)
  | FetchSucceed String
  | FetchFail Http.Error
  | MarkComplete Int
  | MarkIncomplete Int


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

    MarkComplete id -> (completeTask id model, Cmd.none)

    MarkIncomplete id -> (incompleteTask id model, Cmd.none)

isMarkComplete task = task.complete > 0

-- VIEW


view : Model -> Html Msg
view model =
  let
    complete   = List.filter isMarkComplete model.tasks
    incomplete = List.filter (not << isMarkComplete) model.tasks
  in div []
    [ h2 [] [ text "complete"]
    , ul [] <| List.map viewTask complete
    , h2 [] [ text "incomplete"]
    , ul [] <| List.map viewTask incomplete
    ]


viewTask : Task -> Html Msg
viewTask task =
    li []
       ([ text task.name
       , text <| toString task.complete
       ] ++ buttonsForTask task)


buttonsForTask : Task -> List (Html Msg)
buttonsForTask task =
  if task.complete > 0 then
    [ button [(onClick (MarkIncomplete task.id))] [ text "Incomplete" ]]
  else
    [ button [(onClick (MarkComplete task.id))] [ text "Complete" ]]

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
