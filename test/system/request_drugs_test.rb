require "application_system_test_case"

class RequestDrugsTest < ApplicationSystemTestCase
  setup do
    @request_drug = request_drugs(:one)
  end

  test "visiting the index" do
    visit request_drugs_url
    assert_selector "h1", text: "Request Drugs"
  end

  test "creating a Request drug" do
    visit request_drugs_url
    click_on "New Request Drug"

    click_on "Create Request drug"

    assert_text "Request drug was successfully created"
    click_on "Back"
  end

  test "updating a Request drug" do
    visit request_drugs_url
    click_on "Edit", match: :first

    click_on "Update Request drug"

    assert_text "Request drug was successfully updated"
    click_on "Back"
  end

  test "destroying a Request drug" do
    visit request_drugs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Request drug was successfully destroyed"
  end
end
