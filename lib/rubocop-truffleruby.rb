# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/truffleruby'
require_relative 'rubocop/truffleruby/version'
require_relative 'rubocop/truffleruby/inject'

RuboCop::TruffleRuby::Inject.defaults!

require_relative 'rubocop/cop/truffleruby_cops'
