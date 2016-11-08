module Model exposing ( .. )



type alias Params =
    { appInitUrl : String
    , createTaskUrl :   String
    , csrfToken :       String
    }



type alias AppState =
  { params :      Params
  , tasks :       List Task
  , output :      String
  , newTaskText : String
  }



initialAppState =
  { params = { appInitUrl = ""
             , createTaskUrl = ""
             , csrfToken = ""
             }
  , tasks  = []
  , output = ""
  , newTaskText = ""
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
