require "mechanize"
require "rest_client"
require "gist"


class VictimUrl < ActiveRecord::Base
  # validates :name, :url, :query, :presence => true
  validates_presence_of :name, :url, :query
  belongs_to :user
  # validates_uniqueness_of :name
  before_save :publish_gist


  def results
    agent = Mechanize.new{ |a|
      a.user_agent_alias = 'Mac Safari'
    }
    agent.get(url)
    ary = agent.page.search(query)
    ary = ary.map do |e|
      e.to_s
    end
    ary.join("\n")
  end

  def check_for_updates
    if self.enabled?
      self.publish_gist
      sha = self.output.split("\t").first
      if self.git_sha.nil?
        self.git_sha = sha
        self.save
      elsif self.git_sha != sha
        logger.info "Updating SHA...something has changed"
        self.git_sha = sha
        self.save
        StalkerMailer.look_whos_stalking(self).deliver
      end
    end
  end


  protected

  def publish_gist
    if gist_id.nil?
      gist = Gist.new(name,results)
      self.gist_id = gist.publish
    else
      gist = Gist.new(name,results, gist_id)
      gist.publish
    end
  end

  def output
    `git ls-remote git://gist.github.com/#{self.gist_id}.git`
  end
end
