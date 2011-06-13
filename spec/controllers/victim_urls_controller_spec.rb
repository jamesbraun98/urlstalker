require 'spec_helper'

describe VictimUrlsController do
  include MockHelper
  include Devise::TestHelpers

  context "An Admin" do 
    before { @administrator = login_as_admin }

    it "should be valid" do
      @administrator.should be_valid
    end
    
    context "with victim url assigned to current user" do
      before{ @vu = create_victim_url( :user_id => @administrator.id ) }

      context "viewing index page" do
        before { get :index }
    
        it "should be success" do
          response.should be_success
        end
      
        it "should render :index template" do
          response.should render_template(:index)
        end
      
        it "should assign to @victim_urls the list with @vu" do
          assigns[:victim_urls].should == [@vu]
        end
      end

      context "viewing index page as xml" do
        before{ get :index, :format => :xml}
        
        it "should be success" do
          response.should be_success
        end
      
        it "should return application/xml content" do
          response.content_type.should == 'application/xml'
        end
      end

      context "viewing a victim page" do
        before{ get :show, :id => @vu.id}
        
        it "should be success" do
          response.should be_success
        end
      
        it "should render :show template" do
          response.should render_template(:show)
        end
      
        it "should assign to @victim_url the @vu" do
          assigns[:victim_url].should == @vu
        end
        
        it "should assign the victim url to current user" do
          assigns[:victim_url][:user_id].should == @administrator.id
        end
      end

      context "viewing a victim page as xml" do
        before{ get :show, :id => @vu.id, :format => :xml}
        
        it "should be success" do
          response.should be_success
        end
      
        it "should return application/xml content" do
          response.content_type.should == 'application/xml'
        end
      end

      context "with stubbed 3rd-parties responses" do
        before do
          stubbed_mechanize
          stubbed_gist
        end

        context "viewing preview" do
          before{ get :preview, :victim_url => 'http://www.google.com'}
          
          it "should be success" do
            response.should be_success
          end
        
          it "should render :preview layout" do
            response.should render_template("layouts/preview")
          end
          
          it "should assign the variable victim_url" do
            assigns[:victim_url].should_not be_nil
          end
        
          it "should assign the new record" do
            assigns[:victim_url].new_record?.should == true
          end

          it "should assign the new record to current user" do
            assigns[:victim_url][:user_id].should == @administrator.id
          end
        end
        
        context "create an victim_url" do
          context "with valid data" do
            before{ post :create, :victim_url => valid_victim_url_attributes }
            
            it { should redirect_to(:action => :show, :id => assigns[:victim_url]) } 

            it "should have some text in flash[:notice]" do
              flash[:notice].should == 'Victim url was successfully created.'
            end
          end

          context "with valid data and xml formal" do
            before{ post :create, :victim_url => valid_victim_url_attributes, :format => :xml }
            
            it "should return application/xml content" do
              response.content_type.should == 'application/xml'
            end
            it "should have 'created'(201) status" do
              response.status.should == 201
            end
          end
          
          context "with invalid data" do
            before{ post :create, :victim_url => invalid_victim_url_attributes }

            it { should render_template(:new) }
            
            it "should assign the victim_url" do
              assigns[:victim_url].should_not be_nil
            end

            it "should be invalid" do
              assigns[:victim_url].valid?.should_not == true
            end
          end

          context "with invalid data and xml formal" do
            before{ post :create, :victim_url => invalid_victim_url_attributes, :format => :xml }
            
            it "should return application/xml content" do
              response.content_type.should == 'application/xml'
            end
            it "should have 'unprocessable_entity'(422) status" do
              response.status.should == 422
            end
          end
        end
        
        context "update an victim_url" do
          context "with valid data" do
            before{ put :update, :id => @vu.id, :victim_url => @vu.attributes }
            
            it { should redirect_to(:action => :show, :id => assigns[:victim_url]) } 

            it "should have some text in flash[:notice]" do
              flash[:notice].should == 'Victim url was successfully updated.'
            end
          end

          context "with valid data and xml formal" do
            before{ put :update, :id => @vu.id, :victim_url => @vu.attributes, :format => :xml }
            
            it "should return application/xml content" do
              response.content_type.should == 'application/xml'
            end
            it "should have 'ok'(200) status" do
              response.status.should == 200
            end
          end
          
          context "with invalid data" do
            before{ put :update, :id => @vu.id, :victim_url => invalid_victim_url_attributes( @vu ) }
          
            it { should render_template(:edit) }
            
            it "should assign the victim_url" do
              assigns[:victim_url].should_not be_nil
            end
          
            it "should be invalid" do
              assigns[:victim_url].valid?.should_not == true
            end
          end
          
          context "with invalid id" do
            it "should raise ActiveRecord::RecordNotFound error" do
              lambda{
                put :update, :id => 'wrong_id'
              }.should raise_error( ActiveRecord::RecordNotFound )
            end
          end

          context "with invalid data and xml formal" do
            before{ put :update, :id => @vu.id, :victim_url => invalid_victim_url_attributes(@vu), :format => :xml }
            
            it "should return application/xml content" do
              response.content_type.should == 'application/xml'
            end
            it "should have 'unprocessable_entity'(422) status" do
              response.status.should == 422
            end
          end
        end
        
        context "destroy an victim_url" do

          context "with valid id" do
            before{ delete :destroy, :id => @vu.id }
            
            it { should redirect_to( victim_urls_url ) } 
          end

          context "with invalid id" do
            it "should raise ActiveRecord::RecordNotFound error" do
              lambda{
                delete :destroy, :id => 'wrong_id'
              }.should raise_error( ActiveRecord::RecordNotFound )
            end
          end

        end
      end

      context "viewing new page" do
        before{ get :new }
        
        it "should be success" do
          response.should be_success
        end
      
        it "should render :new template" do
          response.should render_template(:new)
        end
      
        it "should assign the @victim_url" do
          assigns[:victim_url].should_not be_nil
        end
        
        it "should assign the new record to @victim_url" do
          assigns[:victim_url].new_record?.should == true
        end
      end
      
      context "viewing a new page as xml" do
        before{ get :new, :format => :xml }
        
        it "should be success" do
          response.should be_success
        end
      
        it "should return application/xml content" do
          response.content_type.should == 'application/xml'
        end
      end

      context "viewing edit page" do
        before{ get :edit, :id => @vu.id }
        
        it "should be success" do
          response.should be_success
        end
      
        it "should render :edit template" do
          response.should render_template(:edit)
        end
      
        it "should assign the @victim_url to @vu" do
          assigns[:victim_url].should == @vu
        end
      end

      context "with stubbed StalkerMailer" do
        before{ StalkerMailer.should_receive(:hello_email).with("rob.christie@eyestreet.com").and_return(mock(:deliver => true))}

        context "testing mail" do
          before{ get :test_mail }
          
          it "should be success" do
            response.should be_success
          end

          it "should render the test 'send'" do
            response.body.should == 'Sent'
          end
        end
      end
      
    end
    
    
  end


  private
    def invalid_victim_url_attributes(vu = nil)
      if vu.nil?
        valid_victim_url_attributes.merge(:name => nil)
      else
        vu.attributes.merge(:name => nil)
      end
    end
  
    
end