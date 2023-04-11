# frozen_string_literal: true

module RuboCop
  module Cop
    module TruffleRuby
      # Prefer Primitive method `nil?` to check whether object is `nil`
      #
      # @example
      #
      #   # bad
      #   object.nil?
      #
      #   # bad
      #   object == nil
      #
      #   # bad
      #   object != nil
      #
      #   # good
      #   Primitive.nil?(object)
      #
      class ReplaceWithPrimitiveNil < Base
        extend AutoCorrector

        MSG = 'Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`'
        RESTRICT_ON_SEND = %i[nil? == !=].freeze

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<~PATTERN
          {
            (send $_ :nil?)
            (send $_ :== nil)
            (send $_ :!= nil)
          }
        PATTERN

        def on_send(node)
          receiver = bad_method?(node)
          return unless receiver

          add_offense(node) do |corrector|
            source_string = "Primitive.nil?(#{receiver.source})"

            if node.method_name == :!=
              source_string = "!" + source_string
            end

            corrector.replace(node.loc.expression, source_string)
          end
        end
      end
    end
  end
end
