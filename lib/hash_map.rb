# frozen_string_literal: true

require './linked_list_hash'

class HashMap

  def initialize
    @buckets = Array.new(16) { LinkedListHash.new }
    @load_factor = 0.75
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def bucket_index(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def set(key, value)
    index = bucket_index(key)
    @size += 1 if @buckets[index].set(key, value)
    grow if @size >= @buckets.length * @load_factor
  end

  def get(key)
    index = bucket_index(key)
    @buckets[index].get(key)
  end

  def has(key)
    index = bucket_index(key)
    @buckets[index].has(key)
  end

  def remove(key)
    index = bucket_index(key)
    @buckets[index].remove(key)
  end

  def grow
    previous_length = @buckets.length
    @buckets.push(*Array.new(@buckets.length) { LinkedListHash.new })
    previous_length.times do |i|
      @buckets[i].iterate(check_length: true) do |node|
        @buckets[i].remove(node.key)
        index = bucket_index(node.key)
        @buckets[index].append(node)
        node.next_node = nil
      end
    end
  end

  def length
    count = 0
    @buckets.each { |list| count += list.length }
    count
  end

  def clear
    @buckets.each(&:clear)
  end

  def keys
    key_array = []
    @buckets.each { |list| key_array.push(*list.keys) }
    key_array
  end

  def values
    value_array = []
    @buckets.each { |list| value_array.push(*list.values) }
    value_array
  end

  def entries
    entries_array = []
    @buckets.each { |list| entries_array.push(*list.entries) }
    entries_array
  end

  def capacity
    @buckets.length
  end

end

