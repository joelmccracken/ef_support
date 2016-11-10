import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug
import EFHttp as EFHttp
import Msg exposing (Msg(..))
import Model exposing (AppState, Task, incompleteTask, completeTask, Params)
import Model as M



main : Program (Params)
main =
  App.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



init : Params -> (AppState, Cmd Msg)
init params =
  ( AppState params "" [] "" "", EFHttp.fetchAppInit params.appInitUrl )



-- UPDATE

update : Msg -> AppState -> (AppState, Cmd Msg)
update msg model =
  case msg of
    AppDataFetchSucceed appInitData ->
      ({ model | tasks = appInitData.tasks, createTaskUrl = appInitData.createTaskUrl}, Cmd.none)

    FetchFail x ->
      ({ model | output = Debug.log "fail" (toString x)}, Cmd.none)

    MarkComplete task ->
      let
        completedTask = M.markIndividualTaskComplete task
        -- serverCmd = EFHttp.updateTask model.params.csrfToken "FILL ME IN LATER" completedTask
        serverCmd = Cmd.none
      in
        (completeTask task model, serverCmd)

    MarkIncomplete task ->
      let
        completedTask = M.markIndividualTaskIncomplete task
        -- serverCmd = EFHttp.updateTask model.params.csrfToken "FILL ME IN LATER" completedTask
        serverCmd = Cmd.none
      in
        (incompleteTask task model, serverCmd)

    UpdateNewTask str -> ({ model | newTaskText = str }, Cmd.none)

    CreateNewTask ->
      let
        newTask = model.newTaskText
        clearedNewTask = { model | newTaskText = "" }
        -- createCmd = EFHttp.createNewTask model newTask
        createCmd = Cmd.none
      in
        (clearedNewTask, createCmd)

    TaskCreated task ->
      ({ model | tasks = task :: model.tasks }, Cmd.none)

    TaskUpdated task ->
      ({ model | tasks = replaceExistingTask task model.tasks }, Cmd.none)



isMarkComplete : Task -> Bool
isMarkComplete task = task.complete > 0



replaceExistingTask : Task -> List Task -> List Task
replaceExistingTask task existingTasks =
  List.map
      (\t-> if task.id == t.id then task else t)
      existingTasks



-- VIEW

view : AppState -> Html Msg
view model =
  let
    complete   = List.filter isMarkComplete model.tasks
    incomplete = List.filter (not << isMarkComplete) model.tasks
  in div []
    [ input [ onInput UpdateNewTask, value model.newTaskText ] [ ]
    , button [ onClick CreateNewTask ] [ text "Accept" ]
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
    [ button [(onClick (MarkIncomplete task))] [ text "Incomplete" ]]
  else
    [ button [(onClick (MarkComplete task))] [ text "Complete" ]]



-- SUBSCRIPTIONS

subscriptions : AppState -> Sub Msg
subscriptions model =
  Sub.none
