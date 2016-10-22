module Msg exposing (..)

import Model exposing (Task)
import Http

type Msg
  = MorePlease
  | AppDataFetchSucceed (List Task)
  | TaskCreated Task
  | FetchFail Http.Error
  | MarkComplete Int
  | MarkIncomplete Int
  | UpdateNewTask String
  | AcceptNewTask
