# frozen_string_literal: true

module AmazingActivist
  module Rescuable
    protected

    # @api internal
    def rescue_handlers
      return @rescue_handlers if defined?(@rescue_handlers)

      ancestors.each do |klass|
        next unless klass < Base && klass != self

        return @rescue_handlers = klass.rescue_handlers
      end

      @rescue_handlers = [].freeze
    end

    # @api internal
    def rescue_handlers=(new_handlers)
      @rescue_handlers = new_handlers.freeze
    end

    private

    def rescue_from(*klasses, &block)
      raise ArgumentError, "Handler block required." unless block

      klasses.each do |klass|
        klass_name =
          case klass
          when Module then klass.name
          when String then klass
          else raise ArgumentError, "#{klass.inspect} must be an Exception class or a String referencing a class."
          end

        self.rescue_handlers += [[klass_name, block].freeze]
      end
    end

    # @api internal
    def rescue_handler_for(exception)
      while exception
        rescue_handlers.reverse_each do |klass, handler|
          return handler if exception.is_a?(const_get(klass))
        rescue StandardError
          # do nothing
        end

        exception = exception.cause
      end

      nil
    end
  end
end
