# frozen_string_literal: true

# For storing key/values inside hashmap buckets
class HashNode
  attr_accessor :key, :value

  def initialize(key = nil, value = nil)
    @key = key
    @value = value
  end
end
