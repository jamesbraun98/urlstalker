require 'spec_helper'

describe Gist do
  before do
    @gist_id = "12345"
    gist_response = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gists type=\"array\">\n <gist>\n <repo>#{@gist_id}</repo>\n  </gist>\n</gists>\n"
    @gist_client =  mock(
        :post => gist_response,
        :put => gist_response,
        :get => "data1"
    )
    RestClient::Resource.stub!(:new).and_return(@gist_client)
    HTTParty.stub!(:get).and_return( {"gists" => [{"files" => ["test1.html"]}]} )
  end

  context "new post" do

    it "should gets the gist id from the response" do
      test_gist = Gist.new('test1', 'data1')
      gist_id = test_gist.publish
      gist_id.should == @gist_id
    end

    it "should call the post command" do
      @gist_client.should_receive(:post)
      test_gist = Gist.new('test1', 'data1')
      gist_id = test_gist.publish
    end
  end

  context "existing post" do
    it "should call put if the data is different" do
      @gist_client.should_receive(:put)
      test_gist = Gist.new('test1', 'data2', @gist_id)
      gist_id = test_gist.publish
    end

    it "should not call put if the data is the same" do
      @gist_client.should_not_receive(:put)
      test_gist = Gist.new('test1', 'data1',  @gist_id)
      gist_id = test_gist.publish
    end
  end
end

