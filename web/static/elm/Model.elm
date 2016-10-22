module Model exposing (..)



type alias Params =
    { appInitUrl : String
    , createTaskUrl :   String
    , updateTaskUrl :   String
    , csrfToken :       String
    }



type alias Model =
  { params :      Params
  , tasks :       List Task
  , output :      String
  , newTaskText : String
  }



initialModel =
  { params = { appInitUrl = ""
             , createTaskUrl = ""
             , updateTaskUrl = ""
             , csrfToken = ""
             }
  , tasks  = []
  , output = ""
  , newTaskText = ""
  }



type alias Task = { name : String, id : Int, complete : Int}



markIndividualTaskComplete : Task -> Task
markIndividualTaskComplete task =
  { task | complete = 1 }



markIndividualTaskIncomplete: Task -> Task
markIndividualTaskIncomplete task =
  { task | complete = 0 }



completeTask : Task -> Model -> Model
completeTask task model =
  updateTask task model markIndividualTaskComplete



incompleteTask : Task -> Model -> Model
incompleteTask task model =
  updateTask task model markIndividualTaskIncomplete



updateTask : Task -> Model -> (Task -> Task) -> Model
updateTask task model updater =
  let
    tasks = (List.map (\t-> if task == t then (updater t) else t)
                 model.tasks)
  in
    { model | tasks = tasks }
