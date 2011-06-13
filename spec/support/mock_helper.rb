module MockHelper

  def login_as_admin
    admin = User.create( valid_user_attributes )
    sign_in( admin )
    admin
  end
  
  
  def stubbed_mechanize
    Mechanize.stub!(:new).and_return(
      mock(
        :get => true,
        :page => mock(
          :search => ['<html>', '</html>']
        )
      )
    )
  end
  
  def stubbed_gist( result = '12345' )
    Gist.stub!(:new).and_return mock(:publish => result)
  end
  
  def create_victim_url( attributes )
    stubbed_mechanize
    stubbed_gist
    VictimUrl.create( valid_victim_url_attributes.merge( attributes ) )
  end
  
  def valid_victim_url_attributes
    {
      :name => 'Google main page',
      :url => 'http://www.google.com/',
      :query => '*'
    }
  end
  
  def valid_user_attributes
    {
      :email => 'admin@gmail.com',
      :password => '123456',
    }
  end

end