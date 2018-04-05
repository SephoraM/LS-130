require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"
  def test_to_a
  assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_all_done
    assert_equal(false, @list.done?)
    @list.mark_all_done
    assert_equal(true, @list.done?)
  end

  def test_not_a_todo_error
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add("todo") }
  end

  def test_add
    @todo4 = Todo.new("Testy Todo")
    @list.add(@todo4)
    assert_equal(@todo4, @list.last)
  end

  def test_add_alias
    @todo4 = Todo.new("Testy Todo")
    @list << @todo4
    assert_equal(@todo4, @list.last)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(19) }
    assert_equal(@todo1, @list.item_at(0))
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(10) }
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(10) }
    @deleted = @list.remove_at(1)
    assert_equal(@todo2, @deleted)
    assert_equal(false, @list.to_a.include?(@todo2))
    assert_equal(true, @list.to_a.include?(@todo1))
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_with_one_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(0)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_with_all_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.mark_all_done
    assert_equal(output, @list.to_s)
  end

  def test_each
    list = []
    @list.each { |todo| list << todo }
    assert_equal(list, @todos)
  end

  def test_each_return_original
    value = @list.each { |todo| "This doesn't do anything" }
    assert_same(value, @list)
  end

  def test_select
    @list.mark_done_at(0)
    new_list = @list.select { |todo| todo.done? }
    assert_equal([@todo1], new_list.to_a)
    assert_equal(true, @list.object_id != new_list.object_id)
  end

  def test_undone
    @list.mark_all_done
    @list.mark_undone_at(0)
    assert_equal(false, @list.item_at(0).done?)
  end
end
