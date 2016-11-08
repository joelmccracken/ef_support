module EFHttp exposing (..)

import Http
import Json.Decode as JSD
import Json.Decode exposing ((:=))
import Json.Encode as JSE
import Task
import Model exposing (Task, AppState, Idable, TaskAttrs, AppInitData)
import Msg exposing (Msg(..))

import JsonApi.Resources
import JsonApi
import JsonApi.Documents
import JsonApi.Http



-- updateTask : String -> String -> Task -> Cmd Msg
-- updateTask csrfToken updateTaskUrl task =
--   let
--     multipartData
--       = [ Http.stringData "task_data" <| JSE.encode 0 <| encodeTask task
--         , Http.stringData "id" <| toString task.id
--         , Http.stringData "_csrf_token" csrfToken]
--     httpData = Http.multipart multipartData
--   in Task.perform
--     FetchFail
--     TaskUpdated
--     (Http.post
--       (JSD.at ["data", "task"] decodeTask)
--       updateTaskUrl
--       httpData
--     )



-- submitNewTask : String -> String -> String -> Cmd Msg
-- submitNewTask createUrl csrfToken name =
--   let
--     multipartData
--       = [ Http.stringData "name" name
--         , Http.stringData "_csrf_token" csrfToken]
--     httpData = Http.multipart multipartData
--   in Task.perform
--     FetchFail
--     TaskCreated
--     (Http.post
--       (JSD.at ["data", "task"] decodeTask)
--       createUrl
--       httpData
--     )



fetchAppInit : String -> Cmd Msg
fetchAppInit url =
  ( Task.andThen
    ( JsonApi.Http.getDocument url )
    ( Task.fromResult << parseAppInit ) )
  |> (Task.perform FetchFail AppDataFetchSucceed)



parseAppInit : JsonApi.Document -> Result Http.Error AppInitData
parseAppInit doc =
  let
    apiPrimaryResource = JsonApi.Documents.primaryResource doc
    allTaskLinks = apiPrimaryResource
      -|> (JsonApi.Resources.relatedLinks "tasks")
    taskCollectionLink =
      allTaskLinks -|> \atl-> Result.fromMaybe "API result did not include task collection link" atl.self
    tasksData = apiPrimaryResource
      -|> JsonApi.Resources.relatedResourceCollection "tasks"
      -|> (Ok << decodeTasks)
  in
    Result.map2
      AppInitData
      taskCollectionLink
      tasksData
    |> Result.formatError Http.UnexpectedPayload

-- infix wrapper for Result.andThen
-- (shrug) it works and is prettier.
-- Cause bacticks are going away in 18??
(-|>) : Result e a -> (a -> Result e b) -> Result e b
(-|>) a b = Result.andThen a b



decodeTasks : (List JsonApi.Resource) -> (List Task)
decodeTasks = List.filterMap <| decodeTask



decodeTask : JsonApi.Resource -> Maybe Task
decodeTask resource =
  Result.andThen
    (JsonApi.Resources.attributes decodeTaskAttrs resource)
    (Ok << (setResourceIDOn resource))
  |> Result.toMaybe



setResourceIDOn : JsonApi.Resource -> Model.TaskAttrs -> Model.Task
setResourceIDOn resource taskAttrs =
  { id = JsonApi.Resources.id resource
  , name = taskAttrs.name
  , complete = taskAttrs.complete }



decodeTaskAttrs : JSD.Decoder Model.TaskAttrs
decodeTaskAttrs =
  JSD.object2
    Model.TaskAttrs
    ("name"     := JSD.string )
    ("complete" := JSD.int )



encodeTask : Task -> JSE.Value
encodeTask task =
  JSE.object
    [ ( "name",     JSE.string task.name )
    , ( "id",       JSE.string task.id )
    , ( "complete", JSE.int task.complete )
    ]
