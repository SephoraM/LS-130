class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError.new("Can only add Todo objects") unless todo.class == Todo
    todos.push(todo)
  end

  def <<(todo)
    add(todo)
  end

  def to_a
    todos
  end

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def item_at(idx)
    todos.fetch(idx)
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(idx)
    item_at(idx)
    todos.delete_at(idx)
  end

  def each
    todos.each { |todo| yield(todo) }
    self
  end

  def select
    new_list = TodoList.new(title)
    each { |todo| new_list.add(todo) if yield(todo) }
    new_list
  end

  def find_by_title(str)
    matching_todos = []
    each { |todo| matching_todos << todo if str == todo.title }
    matching_todos.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(str)
    find_by_title(str) && find_by_title(str).done!
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end

  def done?
    all_done.size == 3
  end

  def to_s
    "---- Today's Todos ----\n#{todos.join("\n")}"
  end

  protected

  attr_accessor :todos
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

todo1.done!

list.find_by_title("Buy milk")
list.find_by_title("Incorrect title")
#=> the first Todo object that matches the argument. nil if no todo is found.

list.all_done
#=> new TodoList object containing only the done items

list.all_not_done
#=> new TodoList object containing only the not done items

list.mark_done("Clean room")
# mark_done	takes a string as argument, and marks the first Todo object that matches the argument as done.

list.mark_all_done
puts list
# mark_all_done	mark every todo as done

list.mark_all_undone
puts list
# mark_all_undone	mark every todo as not done
