class Task < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :path, :st

  validates_presence_of :path

  require 'xmlsimple'

  # ####################
  def id
    name
  end

  def contest
    Contest.new(:path=>self.path.parent.parent)
  end
  # ####################
  def title
    self.st[:problem][0][:statement][0][:title][0]
  end

  def title= new_title
    self.st[:problem][0][:statement][0][:title][0] = new_title
  end


  def description
    desc = self.st[:problem][0][:statement][0][:description][0]
    desc.class != String ?
      XmlSimple.xml_out(
        self.st[:problem][0][:statement][0][:description][0],
        'KeepRoot' => true ) :
      desc
  end

  def description= new_description
    new_hash = XmlSimple.xml_in('<root>'+new_description+'</root>')
    self.st[:problem][0][:statement][0][:description][0] = new_hash
  end

  def examples
    examples = []
    st[:problem][0][:examples][0][:example].each do |example|
      examples<<{:input=>example[:input][0], :output=>example[:output][0]}
    end
    return examples
  end

  def examples= new_examples
    st[:problem][0][:examples][0][:example]=[]
    new_examples.each do |example|
      st[:problem][0][:examples][0][:example]<<{
          :input=>[example[:input]],
          :output=>[example[:output]]}
    end
  end

  def name
    self.path.basename.to_s
  end

  def name= new_name
    File.rename task.path.to_s, task.path.parent.to_s+"/"+new_name
  end

  def input_format
    if st[:problem][0][:statement][0][:input_format]
      st[:problem][0][:statement][0][:input_format][0]
    end
  end

  def input_format= new_input_format
    st[:problem][0][:statement][0][:input_format] = [new_input_format]
  end

  def output_format
    if st[:problem][0][:statement][0][:output_format]
      st[:problem][0][:statement][0][:output_format][0]
    end
  end

  def output_format= new_output_format
    st[:problem][0][:statement][0][:output_format] = [new_output_format]
  end

  def tests
    all_tests = {}
    tpath = self.path
    tpath+="tests"
    tpath.children.each do |child|
      md = child.basename.to_s.match(/^(?<name>\d+).(?<ext>ans|dat)$/)
      all_tests[md[:name]]||={}
      all_tests[md[:name]][md[:ext]]=Test.new(:path=>child)
    end
    return all_tests
  end

  def tl
    settings["time_limit"].to_i if settings
  end

  def ml
    settings["max_vm_size"].to_i if settings
  end

  def settings
    pb=self.contest.settings["problem"][self.id]
    puts self.contest.path+"/conf/serve.cfg has no "+self.id+"problem=(" unless pb
    return pb
  end
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    if self.path
      send("st=",st = XmlSimple.xml_in( self.path.to_s+"/statement.xml",
        { 'KeepRoot' => true ,'KeyToSymbol' => true}))
    end

  end

  def persisted?
    false
  end

  def save
    statement = '<?xml version="1.0" encoding="utf-8" ?>'
    statement+=XmlSimple.xml_out(self.st,'KeepRoot' => true)
    File.open(self.path.to_s+"/statement.xml", 'w') {|f| f.write(statement) }
  end

  def update_attributes params
    params.each do |param|
      self.send(param[0]+'=',param[1]);
    end
  end

end
