# frozen_string_literal: true

require_relative 'node'

# Implementation of Linked List using node objects
class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def append(value)
    if @head.nil?
      @head = Node.new
      @head.value = value
    else
      last_node = tail
      last_node.next_node = Node.new
      last_node.next_node.value = value
    end
  end

  def tail
    result = nil
    each { |n| result = n if n.next_node.nil? }
    result
  end

  def prepend(value)
    previous_head = @head
    @head = Node.new
    @head.value = value
    @head.next_node = previous_head
  end

  def size
    result = 0

    each { result += 1 }
    result
  end

  def at(index)
    each_with_index { |n, i| return n if i == index }
  end

  def pop
    last_node = tail
    each do |node|
      node.next_node = nil if node.next_node == last_node
    end
    last_node
  end

  def contains?(value)
    result = false
    each do |node|
      result = true if node.value == value
    end
    result
  end

  def find(value)
    each { |n| return n if n.value == value }
  end

  def to_s
    result = ''

    each { |n| result += "( #{n.value} ) -> " }
    "#{result}nil"
  end

  def insert_at(value, index)
    new_node = nil
    each_with_index do |node, i|
      next unless i == index - 1

      new_node = Node.new
      new_node.value = value
      new_node.next_node = node.next_node
      node.next_node = new_node
    end
    new_node
  end

  def remove_at(index)
    previous_node = nil
    deleted_node = nil
    each_with_index do |node, i|
      if i == index - 1
        previous_node = node
      elsif i == index
        previous_node.next_node = node.next_node
        deleted_node = node
      end
    end
    deleted_node
  end

  def each_with_index
    i = 0
    each do |node|
      yield(node, i)
      i += 1
    end
  end

  def each
    current_node = @head
    until current_node.nil?
      yield(current_node)

      current_node = current_node.next_node
    end
  end
end
