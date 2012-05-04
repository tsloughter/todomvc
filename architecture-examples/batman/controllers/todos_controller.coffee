class TodoMVC.TodosController extends Batman.Controller
  constructor: ->
    super
    @set 'newTodo', new TodoMVC.Todo(isDone: false)

  all: ->
    @set 'currentTodos', TodoMVC.Todo.get('all')

  completed: ->
    @set 'currentTodos', TodoMVC.Todo.get('completed')
    @render source: 'todos/all'

  active: ->
    @set 'currentTodos', TodoMVC.Todo.get('active')
    @render source: 'todos/all'

  createTodo: ->
    @get('newTodo').save (err, todo) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @set 'newTodo', new TodoMVC.Todo(isDone: false, body: "")

  todoDoneChanged: (node, event, context) ->
    todo = context.get('todo')
    todo.save (err) ->
      throw err if err && !err instanceof Batman.ErrorsSet

  destroyTodo: (node, event, context) ->
    todo = context.get('todo')
    todo.destroy (err) -> throw err if err

  toggleAll: (node, context) ->
    TodoMVC.Todo.get('all').forEach (todo) ->
      todo.set('isDone', !!node.checked)
      todo.save (err) ->
        throw err if err && !err instanceof Batman.ErrorsSet

  clearCompleted: ->
    TodoMVC.Todo.get('completed').forEach (todo) ->
      todo.destroy (err) -> throw err if err

  toggleEditing: (node, event, context) ->
    todo = context.get('todo')
    editing = todo.set('editing', !todo.get('editing'))
    if editing
      input = document.getElementById("todo-input-#{todo.get('id')}")
      input.focus()
      input.select()
    else
      if todo.get('body')?.length > 0
        todo.save (err, todo) ->
          throw err if err && !err instanceof Batman.ErrorsSet
      else
        todo.destroy (err, todo) ->
          throw err if err

  disableEditingUponSubmit: (node, event, context) ->
    if Batman.DOM.events.isEnter(event)
      @toggleEditing(node, event, context)