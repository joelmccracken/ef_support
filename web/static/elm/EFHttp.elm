module EFHttp exposing (..)
import Http
import Json.Decode as JSD
import Json.Decode exposing ((:=))
import Json.Encode as JSE
import Task
import Model exposing (Task, Model)
import Msg exposing (Msg(..))



updateTask : String -> String -> Task -> Cmd Msg
updateTask csrfToken updateTaskUrl task =
  let
    multipartData
      = [ Http.stringData "task_data" <| JSE.encode 0 <| encodeTask task
        , Http.stringData "_csrf_token" csrfToken]
    httpData = Http.multipart multipartData
  in Task.perform
    FetchFail
    TaskCreated
    (Http.post
      (JSD.at ["data", "task"] decodeTask)
      updateTaskUrl
      httpData
    )



submitNewTask : String -> String -> String -> Cmd Msg
submitNewTask createUrl csrfToken name =
  let
    multipartData
      = [ Http.stringData "name" name
        , Http.stringData "_csrf_token" csrfToken]
    httpData = Http.multipart multipartData
  in Task.perform
    FetchFail
    TaskCreated
    (Http.post
      (JSD.at ["data", "task"] decodeTask)
      createUrl
      httpData
    )



fetchBootstrap : String -> Cmd Msg
fetchBootstrap url =
  Task.perform
    FetchFail
    AppDataFetchSucceed
    (Http.get decodeBootstrap url)



decodeBootstrap : JSD.Decoder (List Task)
decodeBootstrap =
  JSD.at ["data", "tasks"] (JSD.list decodeTask)



decodeTask : JSD.Decoder Task
decodeTask =
  JSD.object3
    Task
    ("name"     := JSD.string)
    ("id"       := JSD.int)
    ("complete" := JSD.int)



encodeTask : Task -> JSE.Value
encodeTask task =
  JSE.object
    [ ( "name",     JSE.string task.name )
    , ( "id",       JSE.int task.id )
    , ( "complete", JSE.int task.complete )
    ]
