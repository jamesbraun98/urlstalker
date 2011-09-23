require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "be valid" do
    assert User.new(:email=>'johnDoe@fake.com', :password=>'p@ssw0rd!').valid?
  end
end
