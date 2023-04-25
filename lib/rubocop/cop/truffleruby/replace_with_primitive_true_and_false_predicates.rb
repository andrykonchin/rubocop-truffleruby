# frozen_string_literal: true

module RuboCop
  module Cop
    module TruffleRuby
      # Prefer `Primitive.true?` and `Primitive.false?` to check whether object
      # is `true` or `false`.
      #
      # @example
      #
      #   # bad
      #   foo == true
      #   foo == false
      #
      #   # bad
      #   foo.equal?(true)
      #   foo.equal?(false)
      #
      #   # good
      #   Primitive.true?(foo)
      #   Primitive.false?(foo)
      #
      class ReplaceWithPrimitiveTrueAndFalsePredicates < Base
        extend AutoCorrector

        MSG = 'Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`'

        RESTRICT_ON_SEND = %i[== != equal?].freeze

        # @!method bad_method?(node)
        def_node_matcher :bad_method?, <<~PATTERN
          (send $_ ${ :== :!= :equal? } ${ true false })
        PATTERN

        def on_send(node)
          captures = bad_method?(node)
          return unless captures

          add_offense(node) do |corrector|
            source_string = build_source_string_to_replace_with(*captures)
            corrector.replace(node.loc.expression, source_string)
          end
        end

        private

        def build_source_string_to_replace_with(receiver, method, argument)
          receiver_source = receiver&.source || 'self'
          optional_negation = method == :!= ? '!' : ''
          primitive_name = argument.source == 'true' ? :true? : :false?

          "#{optional_negation}Primitive.#{primitive_name}(#{receiver_source})"
        end
      end
    end
  end
end
