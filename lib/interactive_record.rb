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

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.delete_if{|col_nm| col_nm == "id"}.join(", ")
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM #{table_name} WHERE name = ?", name)
  end

  def self.find_by(att)
    test2 = DB[:conn].execute("SELECT * FROM #{table_name} WHERE #{att.to_a[0][0].to_s}  = #{att.to_a[0][1]}")
    #binding.pry
  end

end
