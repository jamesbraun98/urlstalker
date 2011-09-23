require 'spec_helper'

describe VictimUrl do
  include MockHelper

  context "When Mechanize returns a simple page" do
    before do
      stubbed_mechanize
    end

    context "and victim_url is a valid new instance of VictimUrl" do
      let(:victim_url) { VictimUrl.new( valid_victim_url_attributes ) }

      context "and gist.publish returns '12345'" do
        before{ stubbed_gist('12345') }

        it "should be valid" do
          victim_url.valid?.should == true
        end

        context "with empty name" do
          before{ victim_url.name = nil }

          it "should be invalid" do
            victim_url.should be_invalid
            victim_url.errors[:name].should be_present
          end
        end

        context "with empty url" do
          before{ victim_url.url = nil }

          it "should be invalid" do
            victim_url.should be_invalid
            victim_url.errors[:url].should be_present
          end
        end

        context "with empty query" do
          before{ victim_url.query = nil }

          it "should be invalid" do
            victim_url.should be_invalid
            victim_url.errors[:query].should be_present
          end
        end

        context "and record saved" do
          before{ victim_url.save }

          it "should save 12345 as a gist_id" do
            victim_url.gist_id.should == '12345'
          end

          context "and record disabled" do
            before{ victim_url.update_attribute(:enabled, false)}

            context "should not save record" do
              before{ victim_url.should_not_receive(:save) }

              it { victim_url.check_for_updates }
            end
          end

          context "and record enabled" do
            before do
              victim_url.update_attribute(:enabled, true)
              victim_url.should_receive(:publish_gist).and_return(true)
              victim_url.should_receive(:output).and_return("sha\trest")

            end

            it 'should save is the sha is nil' do
              victim_url.git_sha = nil
              victim_url.should_receive(:save)
              victim_url.check_for_updates
              victim_url.git_sha.should == "sha"
            end

            it 'should save is the sha is changed' do
              victim_url.git_sha = "old sha"
              StalkerMailer.should_receive(:look_whos_stalking).and_return(mock(:deliver => true))
              victim_url.should_receive(:save)
              victim_url.check_for_updates
              victim_url.git_sha.should == "sha"
            end

            it 'should not save is the sha is the same' do
              victim_url.git_sha = "sha"
              victim_url.should_not_receive(:save)
              victim_url.check_for_updates
            end

          end

        end


      end

      context "and record is saved" do
        before{ Gist.should_receive(:new).with('Google main page', "<html>\n</html>" ).and_return mock(:publish => '777') }

        it 'should call Gist.new with ("Google main page","<html>\n</html>")' do
          victim_url.save
        end

        context "twice" do
          before do
            victim_url.save
            Gist.should_receive(:new).with('Google main page', "<html>\n</html>", "777" ).and_return mock(:publish => '888')
          end

          it 'should call Gist.new with 3 params: ("Google main page","<html>\n</html>", "777")' do
            victim_url.save
          end
        end

      end
    end
  end
end
