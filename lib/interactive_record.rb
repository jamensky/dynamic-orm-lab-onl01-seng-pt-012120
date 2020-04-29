require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'
class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    sql = "pragma table_info('#{table_name}')"
      table_data = DB[:conn].execute(sql)
    tab_nms = []

    table_data.each do |data|
      tab_nms << data["name"]
    end
    tab_nms.compact
  end

  def initialize(attributes={})
    attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end


end
