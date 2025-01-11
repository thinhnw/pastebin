require "test_helper"

class PasteTest < ActiveSupport::TestCase
  def setup
    @paste = pastes(:text_paste)
  end

  # Test Validations
  test "should be valid with valid attributes" do
    assert @paste.valid?
  end

  test "should require a title" do
    @paste.title = nil
    assert_not @paste.valid?
    assert_includes @paste.errors[:title], "can't be blank"
  end

  test "should require a slug" do
    @paste.slug = nil
    assert_not @paste.valid?
    assert_includes @paste.errors[:slug], "can't be blank"
  end

  test "slug should be unique" do
    duplicate_paste = @paste.dup
    @paste.save
    assert_not duplicate_paste.valid?
    assert_includes duplicate_paste.errors[:slug], "has already been taken"
  end

  test "should validate title length" do
    @paste.title = "a" * 256
    assert_not @paste.valid?
    assert_includes @paste.errors[:title], "is too long (maximum is 255 characters)"
  end

  # Test Attachment
  test "should require a content file" do
    @paste.content_file = nil
    assert_not @paste.valid?
    assert_includes @paste.errors[:content_file], "can't be blank"
  end
end
