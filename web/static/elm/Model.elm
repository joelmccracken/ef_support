module Model exposing ( .. )

import JsonApi exposing (Document)


type alias Params =
    { appInitUrl : String
    , csrfToken  : String
    }



type alias AppState =
  { params :      Params
  , createTaskUrl : String
  , tasks :       List Task
  , output :      String
  , newTaskText : String
  }



type alias AppInitData =
   { createTaskUrl : String
   , tasks : List Task
   }



type alias Idable = { id : String }



type alias TaskAttrs = { name : String, complete : Int }



type alias Task =
    { id : String
    , name : String
    , complete : Int
    }



markIndividualTaskComplete : Task -> Task
markIndividualTaskComplete task =
  { task | complete = 1 }



markIndividualTaskIncomplete: Task -> Task
markIndividualTaskIncomplete task =
  { task | complete = 0 }



completeTask : Task -> AppState -> AppState
completeTask task model =
  updateTask task model markIndividualTaskComplete



incompleteTask : Task -> AppState -> AppState
incompleteTask task model =
  updateTask task model markIndividualTaskIncomplete



updateTask : Task -> AppState -> (Task -> Task) -> AppState
updateTask task model updater =
  let
    tasks = (List.map (\t-> if task == t then (updater t) else t)
                 model.tasks)
  in
    { model | tasks = tasks }
