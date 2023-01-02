require "application_system_test_case"

class DailiesTest < ApplicationSystemTestCase
  setup do
    @daily = dailies(:one)
  end

  test "visiting the index" do
    visit dailies_url
    assert_selector "h1", text: "Dailies"
  end

  test "creating a Daily" do
    visit dailies_url
    click_on "New Daily"

    fill_in "Notes", with: @daily.notes
    fill_in "Task", with: @daily.task_id
    click_on "Create Daily"

    assert_text "Daily was successfully created"
    click_on "Back"
  end

  test "updating a Daily" do
    visit dailies_url
    click_on "Edit", match: :first

    fill_in "Notes", with: @daily.notes
    fill_in "Task", with: @daily.task_id
    click_on "Update Daily"

    assert_text "Daily was successfully updated"
    click_on "Back"
  end

  test "destroying a Daily" do
    visit dailies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Daily was successfully destroyed"
  end
end
