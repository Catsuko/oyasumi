# frozen_string_literal: true

module Sleeping
  # PaginatedResult wraps query results with cursor-based pagination metadata.
  # Provides both the results and the next_cursor for seamless pagination.
  # Includes Enumerable to provide iteration methods (map, select, etc.)
  class PaginatedResult
    include Enumerable

    attr_reader :results

    # @param results [ActiveRecord::Relation, Array] the query results
    # @param cursor_field [Symbol] the field to use for cursor (default: :started_at)
    def initialize(results, cursor_field: :started_at)
      @results = results.to_a
      @cursor_field = cursor_field
    end

    # Returns the cursor for the next page of results
    # @return [String, nil] the cursor value, or nil if no more results
    def next_cursor
      return nil if @results.empty?

      last_result = @results.last
      last_result.public_send(@cursor_field)&.iso8601
    end

    # Returns true if there are more results available
    # @return [Boolean]
    def more_results?
      !next_cursor.nil?
    end

    # Implement #each for Enumerable support
    # @yield [Object] each result in the collection
    # @return [Enumerator] if no block given
    def each(&block)
      @results.each(&block)
    end

    # Keep performance-optimized direct accessors
    # Enumerable provides these methods, but they iterate through elements.
    # Delegating to @results array is O(1) instead of O(n).
    delegate :count, :size, :length, :first, :last, :[], :empty?, to: :results
  end
end
