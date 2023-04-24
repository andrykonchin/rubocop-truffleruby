# frozen_string_literal: true

RSpec.describe RuboCop::Cop::TruffleRuby::ReplaceWithPrimitiveNil, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#nil?`' do
    expect_offense(<<~RUBY)
      object.nil?
      ^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `object == nil`' do
    expect_offense(<<~RUBY)
      object == nil
      ^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `object != nil`' do
    expect_offense(<<~RUBY)
      object != nil
      ^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      !Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `object.equal? nil`' do
    expect_offense(<<~RUBY)
      object.equal?(nil)
      ^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `nil.equal? object`' do
    expect_offense(<<~RUBY)
      nil.equal?(object)
      ^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `Primitive.object_equal(nil, object)`' do
    expect_offense(<<~RUBY)
      Primitive.equal?(nil, object)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'registers an offense when using `Primitive.object_equal(object, nil)`' do
    expect_offense(<<~RUBY)
      Primitive.equal?(object, nil)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveNil: Use `Primitive.nil?` instead of `Object#nil?` or `object == nil`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end

  it 'does not register an offense when using `Primitive.nil?`' do
    expect_no_offenses(<<~RUBY)
      Primitive.nil?(object)
    RUBY
  end
end
