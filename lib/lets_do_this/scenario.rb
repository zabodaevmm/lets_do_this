require 'lets_do_this/errors'
require 'ostruct'

module LetsDoThis
  class Scenario
    attr_reader :command_sequence

    COMMAND_SEQUENCE = [].freeze
    STATE_ATTRS_WHITELIST = %i[].freeze

    def initialize(input)
      @input = input
      @errors = Errors.new
      @command_sequence = self.class::COMMAND_SEQUENCE.map(&:new)
      @state_attrs_whitelist = self.class::STATE_ATTRS_WHITELIST
    end

    def act_out!
      raise LetsDoThis::EmptyCommandSequence if @command_sequence.empty?

      raise LetsDoThis::EmptyStateAttrsWhitelist if @state_attrs_whitelist.empty?

      change_state!(@input)
      @command_sequence.each do
        command = _1.follow_instructions!(state)
        unless command.success?
          @errors.add(command.class.name, command.errors)
          break
        end

        change_state!(command.result)
      end
      self
    end

    def state
      @state ||= OpenStruct.new
    end

    def change_state!(hash)
      raise(ArgumentError) unless hash.is_a?(Hash)

      w_symbolized_keys = hash.transform_keys { |key| key.to_sym rescue key }
      w_symbolized_keys.slice(*@state_attrs_whitelist).each_pair do |key, value|
        state.public_send("#{key}=", value)
      end
    end

    def success?
      @errors.empty?
    end

    def failure?
      !success?
    end
  end
end
