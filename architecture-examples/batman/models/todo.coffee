class TodoMVC.Todo extends Batman.Model
  @persist Batman.LocalStorage
  @encode 'body', 'isDone'
  @validate 'body', presence: true

  body: ''
  isDone: false

  @classAccessor 'active', ->
    @get('all').filter (todo) -> !todo.get('isDone')

  @classAccessor 'completed', ->
    @get('all').filter (todo) -> todo.get('isDone')

  @wrapAccessor 'body', (core) ->
    set: (key, value) -> core.set.call(@, key, value?.trim())