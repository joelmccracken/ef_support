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



completeTask : Int -> Model -> Model
completeTask id model =
  updateTask id model (\task-> { task | complete = 1 })



updateTask : Int -> Model -> (Task -> Task) -> Model
updateTask id model updater =
  let
    tasks = (List.map (\task-> if task.id == id then (updater task) else task)
              model.tasks)
  in
    { model | tasks = tasks }



incompleteTask : Int -> Model -> Model
incompleteTask id model =
  updateTask id model (\task-> {task | complete = 0 })
