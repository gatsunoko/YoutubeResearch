require "application_system_test_case"

class VideosTest < ApplicationSystemTestCase
  setup do
    @video = videos(:one)
  end

  test "visiting the index" do
    visit videos_url
    assert_selector "h1", text: "Videos"
  end

  test "should create video" do
    visit videos_url
    click_on "New video"

    fill_in "Channel", with: @video.channel_id
    fill_in "Channel name", with: @video.channel_name
    fill_in "Channel url", with: @video.channel_url
    fill_in "Description", with: @video.description
    fill_in "Play count", with: @video.play_count
    fill_in "Posted date", with: @video.posted_date
    fill_in "Thumbnail", with: @video.thumbnail
    fill_in "Title", with: @video.title
    fill_in "Url", with: @video.url
    click_on "Create Video"

    assert_text "Video was successfully created"
    click_on "Back"
  end

  test "should update Video" do
    visit video_url(@video)
    click_on "Edit this video", match: :first

    fill_in "Channel", with: @video.channel_id
    fill_in "Channel name", with: @video.channel_name
    fill_in "Channel url", with: @video.channel_url
    fill_in "Description", with: @video.description
    fill_in "Play count", with: @video.play_count
    fill_in "Posted date", with: @video.posted_date
    fill_in "Thumbnail", with: @video.thumbnail
    fill_in "Title", with: @video.title
    fill_in "Url", with: @video.url
    click_on "Update Video"

    assert_text "Video was successfully updated"
    click_on "Back"
  end

  test "should destroy Video" do
    visit video_url(@video)
    click_on "Destroy this video", match: :first

    assert_text "Video was successfully destroyed"
  end
end
