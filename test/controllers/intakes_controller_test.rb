require "test_helper"

describe IntakesController do
  it "should get new" do
    get intakes_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get intakes_create_url
    value(response).must_be :success?
  end

  it "should get index" do
    get intakes_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get intakes_show_url
    value(response).must_be :success?
  end

end
