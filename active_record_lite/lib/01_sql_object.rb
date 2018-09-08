require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns

    query_result = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        '#{self.table_name}'
    SQL

    @columns = query_result[0].map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column|

      define_method(column) do
        instance_variable_get("@#{column}")
      end

      define_method("#{column}=") do |value|
        instance_variable_set("@#{column}", value)
      end

      #@attributes[key] = val
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    @sql_objects ||= []
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    self.class.all << self
  end

  def attributes
    @attributes ||= {}
    @attributes
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
