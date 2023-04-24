# frozen_string_literal: true

RSpec.describe RuboCop::Cop::TruffleRuby::ReplaceWithPrimitiveObjectEqual, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#equal?`' do
    expect_offense(<<~RUBY)
      foo.equal?(bar)
      ^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveObjectEqual: Use `Primitive.equal?` instead of `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.equal?(foo, bar)
    RUBY
  end

  it 'registers an offense when using `#equal?` without explicit receiver' do
    expect_offense(<<~RUBY)
      equal?(bar)
      ^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveObjectEqual: Use `Primitive.equal?` instead of `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.equal?(self, bar)
    RUBY
  end

  it 'does not register an offense when using `Primitive.equal?`' do
    expect_no_offenses(<<~RUBY)
      Primitive.equal?(foo, bar)
    RUBY
  end

  it 'does not register an offense when using `#==`' do
    expect_no_offenses(<<~RUBY)
      foo == bar
    RUBY
  end
end
