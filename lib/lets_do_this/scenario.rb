require 'lets_do_this/errors'
require 'ostruct'

module LetsDoThis
  class Scenario
    attr_reader :act_sequence

    ACT_SEQUENCE = [].freeze
    STAGE_ATTRS_WHITELIST = %i[].freeze

    def initialize(input)
      @input = input
      @errors = Errors.new
      @act_sequence = self.class::ACT_SEQUENCE.map(&:new)
      @stage_attrs_whitelist = self.class::STAGE_ATTRS_WHITELIST
    end

    def act_out!
      raise LetsDoThis::EmptyActSequence if @act_sequence.empty?

      raise LetsDoThis::EmptyStageAttrsWhitelist if @stage_attrs_whitelist.empty?

      go_on_stage!(@input)
      @act_sequence.each do
        act = _1.follow_instructions!(stage)
        unless act.success?
          @errors.add(act.class.name, act.errors)
          break
        end

        go_on_stage!(act.result)
      end
      self
    end

    def stage
      @stage ||= OpenStruct.new
    end

    def go_on_stage!(hash)
      raise(ArgumentError) unless hash.is_a?(Hash)

      w_symbolized_keys = hash.transform_keys { |key| key.to_sym rescue key }
      w_symbolized_keys.slice(*@stage_attrs_whitelist).each_pair do |key, value|
        stage.public_send("#{key}=", value)
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
