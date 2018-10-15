# frozen_string_literal: true

class YamlToErParser
  ARROW_MAP = {
    has_many: { arrowhead: 'crow', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5 },
    has_one: { arrowhead: 'tee', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5 }
  }.freeze

  def initialize(yaml_file_path)
    @yaml_data = YAML.safe_load(yaml_file_path).deep_symbolize_keys
    @gv = Gviz.new
  end

  def gviz_global(conf)
    @gv.global conf
  end

  def gviz_nodes(conf)
    @gv.nodes conf
  end

  def write_erd
    tables.each { |table|
      table_name = get_table_name(table)
      columns = get_columns(table)
      relations = get_relations(table)
      table_description = get_table_description(table)

      validate_columns!(columns)

      # テーブル作成
      @gv.add table_name

      # tableタグ作成
      table_column_body = create_table_tag(table_name, columns, table_description)
      # テーブル名+カラムのラベルのマッピング
      @gv.node table_name, label: table_column_body

      mapping_relation(table_name, relations)
    }
  end

  def file_save(file_path, file_ext)
    @gv.save file_path, file_ext
  end

  private

  def tables
    @yaml_data[:tables]
  end

  def get_table_name(table)
    table[0]
  end

  def get_columns(table)
    table[1][:columns]
  end

  def get_relations(table)
    table[1][:relations]
  end

  def get_table_description(table)
    table[1][:description]
  end

  def validate_columns!(columns)
    # ささやかなバリデーション
    return if columns.class == Hash
    p "#{table[0]} columns error"
    exit
  end

  def mapping_relation(table_name, relations)
    # リレーションのマッピング
    return if relations.blank?
    relations.each do |relation|
      relation.each do |rel_type, rel_table|
        next if rel_type == :belongs_to
        @gv.edge "#{table_name}_#{rel_table}", ARROW_MAP[rel_type]
      end
    end
  end

  def create_table_tag(table_name, columns, table_description)
    # テーブル名+カラムの構成
    table_column_body = "<table border='0' cellborder='1' cellpadding='8'>"
    table_column_body += "<tr><td bgcolor='lightblue' colspan='4'>#{table_name}</td></tr>"
    table_column_body +=
      '<tr>' \
      "<td bgcolor='lightblue'>物理名</td>" \
      "<td bgcolor='lightblue'>論理名</td>" \
      "<td bgcolor='lightblue'>型</td>" \
      "<td bgcolor='lightblue'>説明</td>" \
      '</tr>'

    columns.each do |column, column_info|
      column_logical_name = column_info[:logical_name].presence || ''
      column_description = column_info[:description].presence || ''

      table_column_body +=
        '<tr>' \
        "<td align='left'>#{column}</td>" \
        "<td align='left'>#{column_logical_name}</td>" \
        "<td align='left'>#{column_info[:type]}</td>" \
        "<td align='left'>#{column_description.gsub(/\r\n|\r|\n/, '<br />')}</td>" \
        '</tr>'
    end

    table_column_body += "<tr><td bgcolor='lightblue' colspan='4'>#{table_description.gsub(/\r\n|\r|\n/, '<br />')}</td></tr>"
    table_column_body += '</table>'
  end
end
