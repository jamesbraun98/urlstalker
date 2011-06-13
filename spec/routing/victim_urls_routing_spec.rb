require "spec_helper"

describe VictimUrlsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/victim_urls" }.should route_to(:controller => "victim_urls", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/victim_urls/new" }.should route_to(:controller => "victim_urls", :action => "new")
    end
    
    it "recognizes and generates #show" do
      { :get => "/victim_urls/1" }.should route_to(:controller => "victim_urls", :action => "show", :id => "1")
    end
    
    it "recognizes and generates #edit" do
      { :get => "/victim_urls/1/edit" }.should route_to(:controller => "victim_urls", :action => "edit", :id => "1")
    end
    
    it "recognizes and generates #create" do
      { :post => "/victim_urls" }.should route_to(:controller => "victim_urls", :action => "create")
    end
    
    it "recognizes and generates #update" do
      { :put => "/victim_urls/1" }.should route_to(:controller => "victim_urls", :action => "update", :id => "1")
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/victim_urls/1" }.should route_to(:controller => "victim_urls", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #test_mail" do
      { :get => "/victim_urls/test_mail" }.should route_to(:controller => "victim_urls", :action => "test_mail")
    end
    
    it "recognizes and generates #preview" do
      { :get => "/victim_urls/preview" }.should route_to(:controller => "victim_urls", :action => "preview")
    end

  end
end