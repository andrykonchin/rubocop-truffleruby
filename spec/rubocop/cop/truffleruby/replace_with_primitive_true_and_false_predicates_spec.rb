# frozen_string_literal: true

RSpec.describe RuboCop::Cop::TruffleRuby::ReplaceWithPrimitiveTrueAndFalsePredicates, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#==` with true' do
    expect_offense(<<~RUBY)
      foo == true
      ^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.true?(foo)
    RUBY
  end

  it 'registers an offense when using `#==` with false' do
    expect_offense(<<~RUBY)
      foo == false
      ^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.false?(foo)
    RUBY
  end

  it 'registers an offense when using `#!=` with true' do
    expect_offense(<<~RUBY)
      foo != true
      ^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      !Primitive.true?(foo)
    RUBY
  end

  it 'registers an offense when using `#!=` with false' do
    expect_offense(<<~RUBY)
      foo != false
      ^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      !Primitive.false?(foo)
    RUBY
  end

  it 'registers an offense when using `#equal?` with true' do
    expect_offense(<<~RUBY)
      foo.equal? true
      ^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.true?(foo)
    RUBY
  end

  it 'registers an offense when using `#equal?` with false' do
    expect_offense(<<~RUBY)
      foo.equal? false
      ^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.false?(foo)
    RUBY
  end

  it 'registers an offense when using `#equal?` with true and parentheses' do
    expect_offense(<<~RUBY)
      foo.equal?(true)
      ^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.true?(foo)
    RUBY
  end

  it 'registers an offense when using `#equal?` with false and parentheses' do
    expect_offense(<<~RUBY)
      foo.equal?(false)
      ^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.false?(foo)
    RUBY
  end

  it 'registers an offense when using `#equal?` with true with implicit receiver' do
    expect_offense(<<~RUBY)
      equal? true
      ^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.true?(self)
    RUBY
  end

  it 'registers an offense when using `#equal?` with false with implicit receiver' do
    expect_offense(<<~RUBY)
      equal? false
      ^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveTrueAndFalsePredicates: Use `Primitive.true?` and `Primitive.false?` instead of `==` or `#equal?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.false?(self)
    RUBY
  end

  it 'does not register an offense when using `Primitive.true?(foo)`' do
    expect_no_offenses(<<~RUBY)
      Primitive.true?(foo)
    RUBY
  end

  it 'does not register an offense when using `Primitive.false?(foo)`' do
    expect_no_offenses(<<~RUBY)
      Primitive.false?(foo)
    RUBY
  end
end
