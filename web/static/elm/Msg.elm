module Msg exposing (..)

import Model exposing (Task, AppInitData)
import Http

type Msg
  = AppDataFetchSucceed AppInitData
  | TaskCreated Task
  | TaskUpdated Task
  | FetchFail Http.Error
  | MarkComplete Task
  | MarkIncomplete Task
  | UpdateNewTask String
  | CreateNewTask
