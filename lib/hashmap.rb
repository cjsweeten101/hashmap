# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'hash_node'

# Implementation of custom HashMap class
class HashMap
  attr_accessor :load_factor, :capacity, :buckets

  def initialize
    @capacity = 16
    @buckets = Array.new(@capacity) { LinkedList.new }
    @load_factor = 0.75
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    hash_code = hash(key)
    node = HashNode.new(key, value)

    place_in_bucket(node, value, hash_code % @capacity)
    grow if length > (@capacity * @load_factor)
  end

  def place_in_bucket(node, new_value, index)
    raise IndexError if index.negative? || index >= @buckets.length

    value_updated = false
    @buckets[index].each do |entry|
      current_hash_node = entry.value
      next unless current_hash_node.key == node.key

      current_hash_node.value = new_value
      value_updated = true
      break
    end
    @buckets[index].append(node) unless value_updated
  end

  def grow
    @capacity *= 2
    old_entries = entries
    @buckets = Array.new(@capacity) { LinkedList.new }
    old_entries.each { |arr| set(arr[0], arr[1]) }
  end

  def get(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index].each do |e|
      hash_node = e.value
      return hash_node.value if hash_node.key == key
    end
    nil
  end

  def has?(key)
    each_node do |node|
      return true if node.key == key
    end
    false
  end

  def remove(key)
    result = nil
    each_list do |list|
      i = 0
      list.each do |node|
        if node.value.key == key
          result = node.value.value
          list.remove_at(i)
        end
        i += 1
      end
    end
    result
  end

  def length
    result = 0
    each_node { |_n| result += 1 }
    result
  end

  def each_list(&block)
    @buckets.each(&block)
  end

  def each_node
    each_list do |list|
      list.each do |node|
        yield(node.value)
      end
    end
  end

  def clear
    @buckets = Array.new(@capacity) { LinkedList.new }
    nil
  end

  def keys
    result = []
    each_node { |n| result << n.key }
    result
  end

  def values
    result = []
    each_node { |n| result << n.value }
    result
  end

  def entries
    result = []
    each_node { |n| result << [n.key, n.value] }
    result
  end
end
