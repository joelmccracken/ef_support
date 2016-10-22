module Msg exposing (..)

import Model exposing (Task)
import Http

type Msg
  = AppDataFetchSucceed (List Task)
  | TaskCreated Task
  | TaskUpdated Task
  | FetchFail Http.Error
  | MarkComplete Int
  | MarkIncomplete Int
  | UpdateNewTask String
  | AcceptNewTask
