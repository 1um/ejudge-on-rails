#encoding: utf-8
class Contest < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :path, :settings

  validates_presence_of :path

  def self.all
    p =  Pathname.new(JUDGES_PATH)
    pathes = p.children.select{|c| c.basename.to_s.match(/^\d+$/)}
    pathes.map{|p| Contest.new(path: p)}
  end

  def self.find name
    contest = self.all.find{|contest| contest.name.match(/^0*#{name}$/)}
    Contest.new(path: contest.path) if contest
  end

  def tasks
    p  = self.path+'problems'
    p.children.map{|path| Task.new(path: path)}
  end

  def id
    name
  end

  def name
    self.path.basename.to_s
  end

  def reload_settings
    settings = {}
    current_block = settings[:common] = []
    current_block<<{}
    return {} unless File.exist?(self.path.to_s+"/conf/serve.cfg")
    f = File.open(self.path.to_s+"/conf/serve.cfg")
    f.lines.each do |line|
      unless line.match(/^$/)
        if mt = line.match(/(?<property>\w+)\s?=\s?"?(?<value>[А-Яа-я\w\s]++)"?$/)
          current_block.last[mt[:property]]=mt[:value]
        elsif mt = line.match(/\[(?<block>\w+)\]/)
          current_block = settings[mt[:block]]||=[]
          current_block<<{}
        elsif mt =line.match(/^\w+$/)
          current_block.last[mt.to_s]=true
        end
      end
    end
    settings["problem"]=structurize_problem_settings(settings["problem"])
    self.settings = settings
  end

  def structurize_problem_settings before
    after = {}
    before.each do |problem|
      if problem["id"]
        after[problem['id'].to_i] = problem.slice!("id")
      end
    end if before
    after
  end
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    reload_settings
  end

  def sid
    Ejudge2::Application.config.sid_hash[self.id]
  end

  def unstaged_changes?
    Ejudge2::Application.config.push_hash[self.id]
  end

  def persisted?
    false
  end

  def save
    content = File.read(self.path.to_s+"/conf/serve.cfg")
    content.gsub!(Regexp.new('\[problem\](?!\nabstract).*?\n\n', Regexp::MULTILINE),"#pb\n")
    # File.open(self.path+"conf/serve.cfg","w"){|f| f.write(content)}
    binding.pry
  end
end
