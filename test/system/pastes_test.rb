require "application_system_test_case"

class PastesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @user_john = users(:john)
    @user_jane = users(:jane)
    @public_paste = pastes(:text_paste)
    @private_paste = pastes(:private_paste)
  end

  test "visiting index for signed in user" do
    login_as @user_john
    visit pastes_url
    assert_selector "h1", text: "Pastes"
  end

  test "should redirect anon when visiting index" do
    visit pastes_url
    assert_equal new_user_session_path, current_path
  end

  test "should create paste" do
    visit root_path

    fill_in "Title", with: "Hello, World!"
    select "plaintext", from: "Language"
    fill_in "Content", with: "Lorem ipsum"

    click_on "Create Paste"

    assert_text "Paste was successfully created"
  end

  # test "should update Paste" do
  #   visit paste_url(@paste)
  #   click_on "Edit this paste", match: :first

  #   check "Private" if @paste.private
  #   fill_in "Slug", with: @paste.slug
  #   fill_in "Title", with: @paste.title
  #   click_on "Update Paste"

  #   assert_text "Paste was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Paste" do
  #   visit paste_url(@paste)
  #   click_on "Destroy this paste", match: :first

  #   assert_text "Paste was successfully destroyed"
  # end
end
