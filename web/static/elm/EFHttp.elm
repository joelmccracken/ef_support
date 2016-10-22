module EFHttp exposing (..)
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Task
import Model exposing (Task, Model)
import Msg exposing (Msg(..))



updateTaskAttributes : Task -> Cmd Msg
updateTaskAttributes csrfToken task =
  let
    multipartData
      = [ Http.stringData "name" name
        , Http.stringData "_csrf_token" csrfToken]
    httpData = Http.multipart multipartData
  in Task.perform
    FetchFail
    TaskCreated
    (Http.post
      (Json.at ["data", "task"] decodeTask)

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
      (Json.at ["data", "task"] decodeTask)
      createUrl
      httpData
    )



fetchBootstrap : String -> Cmd Msg
fetchBootstrap url =
  Task.perform
    FetchFail
    BootstrapFetchSucceed
    (Http.get decodeBootstrap url)



decodeBootstrap : Json.Decoder (List Task)
decodeBootstrap =
  Json.at ["data", "tasks"] (Json.list decodeTask)



decodeTask : Json.Decoder Task
decodeTask =
  Json.object3
    Task
    ("name"     := Json.string)
    ("id"       := Json.int)
    ("complete" := Json.int)
