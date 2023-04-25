# frozen_string_literal: true

RSpec.describe RuboCop::Cop::TruffleRuby::ReplaceWithPrimitiveIsA, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#kind_of?`' do
    expect_offense(<<~RUBY)
      a.kind_of?(String)
      ^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?(a, String)
    RUBY
  end

  it 'registers an offense when using `#is_a?`' do
    expect_offense(<<~RUBY)
      a.is_a?(String)
      ^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?(a, String)
    RUBY
  end

  it 'registers an offense when using `Module#===`' do
    expect_offense(<<~RUBY)
      String === a
      ^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?(a, String)
    RUBY
  end

  it 'registers an offense when using `Module#===` and expression' do
    expect_offense(<<~RUBY)
      String === (a || b)
      ^^^^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?((a || b), String)
    RUBY
  end

  it 'registers an offense when there is no explicit receiver of `#kind_of?`' do
    expect_offense(<<~RUBY)
      kind_of?(String)
      ^^^^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?(self, String)
    RUBY
  end

  it 'registers an offense when there is no explicit receiver of `#is_a?`' do
    expect_offense(<<~RUBY)
      is_a?(String)
      ^^^^^^^^^^^^^ TruffleRuby/ReplaceWithPrimitiveIsA: Use `Primitive.is_a?` instead of `#kind_of?` or `#is_a?`
    RUBY

    expect_correction(<<~RUBY)
      Primitive.is_a?(self, String)
    RUBY
  end

  it 'does not register an offense when using `#instance_of?`' do
    expect_no_offenses(<<~RUBY)
      a.instance_of?(String)
    RUBY
  end

  it 'does not register an offense when using `#===` with non-constant receiver' do
    expect_no_offenses(<<~RUBY)
      string === a
    RUBY
  end
end
