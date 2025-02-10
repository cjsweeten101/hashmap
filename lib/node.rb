# frozen_string_literal: true

# Responsible for storing list items, data and next pointer
class Node
  attr_accessor :value, :next_node

  def initialize
    @value = nil
    @next_node = nil
  end
end
