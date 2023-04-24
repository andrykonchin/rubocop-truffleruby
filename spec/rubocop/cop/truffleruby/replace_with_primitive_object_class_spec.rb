# frozen_string_literal: true

RSpec.describe RuboCop::Cop::TruffleRuby::ReplaceWithPrimitiveObjectClass, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#nil?`' do
    expect_offense(<<~RUBY)
      object.class
      ^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveObjectClass: Use `Primitive.class` instead of `Object#class`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.class(object)
    RUBY
  end

  it 'does not register an offense when using `Primitive.class`' do
    expect_no_offenses(<<~RUBY)
      Primitive.class(object)
    RUBY
  end
end
