# frozen_string_literal: true

ARROW_MAP = {
  has_many: { arrowhead: 'crow', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5 },
  has_one: { arrowhead: 'tee', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5 }
}.freeze

gv = Gviz.new
# 初期設定
gv.nodes shape: 'Mrecord', fontname: 'DejaVu Serif', fontsize: 40
gv.global layout: 'dot'

file_path = ARGF.read
yaml_data = YAML.safe_load(file_path).deep_symbolize_keys

yaml_data[:tables].each { |table|
  table_name = table[0]
  columns = table[1][:columns]
  relations = table[1][:relations]
  table_description = table[1][:description]

  # ささやかなバリデーション
  if columns.class != Hash
    p "#{table[0]} columns error"
    exit
  end

  # テーブル作成
  gv.add table_name

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

  # テーブル名+カラムのラベルのマッピング
  gv.node table_name, label: table_column_body

  # リレーションのマッピング
  if relations.present?
    relations.each do |relation|
      relation.each do |rel_type, rel_table|
        next if rel_type == :belongs_to
        gv.edge "#{table_name}_#{rel_table}", ARROW_MAP[rel_type]
      end
    end
  end
}
gv.save 'erd/erd', :png