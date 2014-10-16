module Pacto
  class Provider
    include Resettable

    def self.reset!
      @actor  = nil
      @driver = nil
    end

    def self.actor
      @actor ||= Pacto::Actors::FromExamples.new
    end

    def self.actor=(actor)
      fail ArgumentError, 'The actor must respond to :build_response' unless actor.respond_to? :build_response
      @actor = actor
    end

    def self.response_for(contract, data = {}, example = nil)
      actor.build_response contract, data, example
    end
  end
end
