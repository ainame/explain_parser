require "explain_parser/version"

class ExplainParser

  class Explain
    COLUMNS = [
      :id, :select_type, :table, :type, :possible_keys, :key, :key_len, :len, :ref, :rows, :filtered, :extra
    ].freeze

    def initialize(params)
      raise ArgumentError unless params
      @params = params
    end

    COLUMNS.each do |column|
      method_name = column.to_s
      if [:id, :rows].include?(column)
        define_method(column) do
          @params[method_name].to_i
        end
      else
        define_method(column) do
          @params[method_name]
        end
      end
    end

    def using_filesort?
      !!(extra =~ /Using filesort/)
    end

    def using_temporary?
      !!(extra =~ /Using temporary/)
    end

    def using_where?
      !!(extra =~ /Using where/)
    end

    def using_index?
      !!(extra =~ /Using index/)
    end
  end

  def initialize(explain)
    raise ArgumentError unless explain
    @explain = explain
  end

  def self.call(explain)
    new(explain).call
  end

  def call
    return unless rows && !rows.empty?
    build
  end

  def lines
    @explain.each_line.to_a
  end

  def rows
    @rows ||= lines.select{|line| line =~ /\w+/ && line !~ /\d+ row in set/ }
  end

  def keys()
    @keys ||= rows[0].chomp.split('|').compact.map(&:strip).reject(&:empty?).map(&:downcase)
  end

  def values_list()
    rows[1..-1].map{|row| cleanup_values(row.chomp.split('|').compact) }
  end

  def cleanup_values(dirty_values)
    dirty_values.map(&:strip).reject(&:empty?).map {|val| val == 'NULL' ? nil : val }
  end

  def build
    values_list.reduce([]) do |explains, values|
      params = keys.zip(values).inject({}) { |h, (k, v)| h[k] = v; h }
      explains << ExplainParser::Explain.new(params)
      explains
    end
  end

end
