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
    # TODO: implement growth factor
    hash_code = hash(key)
    node = HashNode.new(hash_code, value)

    place_in_bucket(node, value, hash_code % @capacity)
  end

  def place_in_bucket(node, new_value, index)
    value_updated = false
    @buckets[index].each do |entry|
      current_hash_node = entry.value
      next unless current_hash_node.key == node.key

      current_hash_node.value = new_value
      value_updated = true
      break
    end
    @buckets[index].append unless value_updated
  end
end
