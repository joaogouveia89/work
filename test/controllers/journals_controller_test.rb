require "test_helper"

class JournalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @journal = journals(:one)
  end

  test "should get index" do
    get journals_url
    assert_response :success
  end

  test "should get new" do
    get new_journal_url
    assert_response :success
  end

  test "should create journal" do
    assert_difference('Journal.count') do
      post journals_url, params: { journal: { comments: @journal.comments, current_task: @journal.current_task, humor: @journal.humor, meetings: @journal.meetings, team_interaction: @journal.team_interaction } }
    end

    assert_redirected_to journal_url(Journal.last)
  end

  test "should show journal" do
    get journal_url(@journal)
    assert_response :success
  end

  test "should get edit" do
    get edit_journal_url(@journal)
    assert_response :success
  end

  test "should update journal" do
    patch journal_url(@journal), params: { journal: { comments: @journal.comments, current_task: @journal.current_task, humor: @journal.humor, meetings: @journal.meetings, team_interaction: @journal.team_interaction } }
    assert_redirected_to journal_url(@journal)
  end

  test "should destroy journal" do
    assert_difference('Journal.count', -1) do
      delete journal_url(@journal)
    end

    assert_redirected_to journals_url
  end
end
