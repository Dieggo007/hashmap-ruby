# frozen_string_literal: true

require './node_hash'

class LinkedListHash

  def initialize
    @head = nil
  end

  def iterate(node = nil, check_length: false)
    node ||= @head
    old_length = length if check_length
    i = 0
    while node && (!check_length || i < old_length)
      temp = node.next_node
      yield node
      node = temp
      i += 1
    end
  end

  def append(new_node)
    if @head.nil?
      @head = new_node
      return
    end
    iterate { |node| node.next_node = new_node if node.next_node.nil? }
  end

  def set(key, new_value)
    if @head.nil?
      @head = NodeHash.new(key, new_value)
      return true
    end
    iterate do |node|
      if key == node.key
        node.value = new_value
        return false
      end
      node.next_node = NodeHash.new(key, new_value) if node.next_node.nil?
    end
    true
  end

  def get(key)
    iterate { |node| return node.value if key == node.key }
    nil
  end

  def has(key)
    iterate { |node| return true if key == node.key }
    false
  end

  def remove(key)
    if @head && key == @head.key
      value = @head.value
      @head = @head.next_node
      return value
    elsif @head.nil?
      return nil
    end
    previous_node = @head
    iterate(@head.next_node) do |node|
      if key == node.key
        previous_node.next_node = node.next_node
        return node.value
      end
      previous_node = node
    end
    nil
  end

  def length
    count = 0
    iterate { count += 1 }
    count
  end

  def clear
    @head = nil
  end

  def keys
    key_array = []
    iterate { |node| key_array.push(node.key) }
    key_array
  end

  def values
    value_array = []
    iterate { |node| value_array.push(node.value) }
    value_array
  end

  def entries
    entries_array = []
    iterate { |node| entries_array.push([node.key, node.value]) }
    entries_array
  end

  def to_s
    string = ''
    iterate { |node| string += "#{node.value} -> " }
    "#{string}nil"
  end
end


