import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug
import EFHttp as EFHttp
import Msg exposing (Msg(..))
import Model exposing (Model, Task, incompleteTask, completeTask, Params)




main : Program (Params)
main =
  App.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



init : Params -> (Model, Cmd Msg)
init params =
  (Model params [] "" "", EFHttp.fetchBootstrap params.appBootstrapUrl)



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AppDataFetchSucceed data ->
      -- (Model model.topic newUrl, Cmd.none)
      ({ model | tasks = data }, Cmd.none)

    FetchFail x ->
      ({ model | output = Debug.log "fail" (toString x)}, Cmd.none)

    MarkComplete id -> (completeTask id model, Cmd.none)

    MarkIncomplete id -> (incompleteTask id model, Cmd.none)

    UpdateNewTask str -> ({ model | newTaskText = str }, Cmd.none)

    AcceptNewTask ->
      let
        newTask = model.newTaskText
        clearedNewTask = { model | newTaskText = "" }
        createCmd = EFHttp.submitNewTask model.params.createTaskUrl model.params.csrfToken newTask
      in
        (clearedNewTask, createCmd)

    TaskCreated task ->
      ({ model | tasks = task :: model.tasks }, Cmd.none)



isMarkComplete : Task -> Bool
isMarkComplete task = task.complete > 0



-- VIEW

view : Model -> Html Msg
view model =
  let
    complete   = List.filter isMarkComplete model.tasks
    incomplete = List.filter (not << isMarkComplete) model.tasks
  in div []
    [ input [ onInput UpdateNewTask, value model.newTaskText ] [ ]
    , button [ onClick AcceptNewTask ] [ text "Accept" ]
    , h2 [] [ text "incomplete"]
    , ul [] <| List.map viewTask incomplete
    , h2 [] [ text "complete"]
    , ul [] <| List.map viewTask complete
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
