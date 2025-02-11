# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'hash_node'
require 'pry-byebug'

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
    # TODO: implement growth factor
    hash_code = hash(key)
    node = HashNode.new(hash_code, value)

    place_in_bucket(node, value, hash_code % @capacity)
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

  def get(key)
    hash_code = hash(key)
    index = hash_code % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index].each do |e|
      hash_node = e.value
      return hash_node.value if hash_node.key == hash_code
    end
    nil
  end

  def has?(key)
    hash_code = hash(key)
    each_node do |node|
      return true if node.key == hash_code
    end
    false
  end

  def remove(key)
    result = nil
    hash_code = hash(key)
    each_list do |list|
      i = 0
      list.each do |node|
        if node.value.key == hash_code
          result = node.value.value
          list.remove_at(i)
        end
        i += 1
      end
    end
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
end
