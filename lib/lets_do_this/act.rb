require 'lets_do_this/errors'

module LetsDoThis
  class Act
    attr_accessor :performed, :errors, :result

    def initialize
      @performed = false
      @errors = Errors.new
    end

    def instructions(_stage)
      raise NotImplementedError
    end

    def follow_instructions!(stage)
      tap do
        _1.performed = true
        instructions_ = instructions(stage)
        _1.result = instructions_.is_a?(Hash) ? instructions_ : {}
      end
    end

    def success?
      @performed && @errors.empty?
    end

    def failure?
      @performed && @errors.present?
    end
  end
end
