class TodoMVC extends Batman.App
  @root 'todos#all'
  @route "/completed", "todos#completed"
  @route "/active", "todos#active"

  @model 'todo'
  @controller 'todos'

window.TodoMVC = TodoMVC
TodoMVC.run()