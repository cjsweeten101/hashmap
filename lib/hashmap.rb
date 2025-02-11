# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'hash_node'

# Implementation of custom HashMap class
class HashMap
  attr_accessor :load_factor, :capacity, :buckets

  def initialize
    @capacity = 16
    @buckets = Array.new(@capacity)
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
    place_in_bucket(hash_code, value)
  end

  def place_in_bucket(hash_code, value)
    node = HashNode.new(hash_code, value)
    bucket_index = hash_code % @capacity

    bucket_obj = @buckets[bucket_index]
    if bucket_obj.nil?
      @buckets[bucket_index] = node
    elsif bucket_obj.instance_of(HashNode) && bucket_obj.key == node.key
      @buckets[bucket_index].value = value
    else
      handle_collisions(bucket_obj, node, bucket_index)
    end
  end

  def handle_collisions(current_obj, new_node, index)
    if current_obj.instance_of?(linked_list)
      @buckets[index].append(new_node)
    else
      new_list = LinkedList.new
      new_list.append(current_obj)
      new_list.append(new_node)
      @buckets[index] = new_list
    end
  end
end
