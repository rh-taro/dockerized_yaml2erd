# frozen_string_literal: true

class YamlToErParser
  attr_accessor :subgraph_global_conf

  ARROW_MAP = {
    has_many: { arrowhead: 'crow', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5, penwidth: 10 },
    has_one: { arrowhead: 'tee', arrowtail: 'tee', arrowsize: 5, dir: 'both', minlen: 5, penwidth: 10 }
  }.freeze

  TABLE_HEADER = %w[
    物理名
    論理名
    型
    PK
    FK
    NOT_NULL
    DEFAULT
    説明
  ].freeze

  def initialize(yaml_file_path)
    @yaml_file_path = yaml_file_path
    File.open(@yaml_file_path) do |file|
      @yaml_data = YAML.safe_load(file.read).deep_symbolize_keys
    end
    @gv = Gviz.new

    @subgraph_global_conf = {}
  end

  # TODO: nodesとglobalの違いみたいなの調査
  def gviz_global(conf)
    @global_conf = conf
    @gv.global @global_conf
  end

  def gviz_nodes(conf)
    @nodes_conf = conf
    @gv.nodes @nodes_conf
  end

  def write_erd
    # entityとrelation作成
    db_tables.each do |table|
      db_table_name = get_db_table_name(table)
      db_columns = get_db_columns(table)
      db_relations = get_db_relations(table)
      db_table_description = get_db_table_description(table)

      validate_columns!(db_table_name, db_columns)

      # テーブル作成
      # TODO: addとrouteの違い
      @gv.route db_table_name

      # tableタグ作成
      table_tag = create_table_tag(db_table_name, db_columns, db_table_description)
      # テーブル名+カラムのラベルのマッピング
      @gv.node db_table_name, label: table_tag

      mapping_relation(db_table_name, db_relations)
    end

    # グルーピング
    relation_grouping
  end

  def file_save(save_path: '', save_ext: '')
    save_path = save_path.presence || "erd/#{remove_ext(@yaml_file_path)}"
    save_ext = save_ext.presence || :png

    @gv.save save_path, save_ext
  end

  private

  def relation_grouping
    # グループ内に適用するために再度@nodes_confをあてる
    nodes_conf = @nodes_conf
    subgrap_conf = @subgraph_global_conf
    group_bgcolor_map = create_group_bgcolor_map

    # mapをもとにグルーピング
    db_table_groups_map.each do |group_name, db_tables|
      @gv.subgraph do
        global subgrap_conf.merge(label: group_name, bgcolor: group_bgcolor_map[group_name.to_sym])
        nodes nodes_conf
        db_tables.each do |db_table|
          node db_table
        end
      end
    end
  end

  def db_table_groups_map
    # グルーピングのmap作成
    db_table_groups_map = {}
    db_tables.each do |table|
      db_table_group_name = get_db_table_group_name(table)
      db_table_name = get_db_table_name(table)

      next if db_table_group_name.blank?

      # TODO: 複数指定で重ねたり、入れ子にしたりできるように
      # {:group_name => [table_name1, ...]}というhashを作る
      db_table_group_name = db_table_group_name.to_sym
      # なければ初期化
      db_table_groups_map[db_table_group_name] = [] if db_table_groups_map[db_table_group_name].blank?
      db_table_groups_map[db_table_group_name] << db_table_name
    end
    db_table_groups_map
  end

  def remove_ext(file_name)
    File.basename(file_name, '.*')
  end

  def create_group_bgcolor_map
    bgcolor_map = {}
    @yaml_data[:groups].each do |group|
      bgcolor_map[group[:name].to_sym] = group[:bgcolor]
    end
    bgcolor_map
  end

  def db_tables
    @yaml_data[:tables]
  end

  def get_db_table_name(db_table)
    db_table[0]
  end

  def get_db_columns(db_table)
    db_table[1][:columns]
  end

  def get_db_relations(db_table)
    db_table[1][:relations]
  end

  def get_db_table_group_name(db_table)
    db_table[1][:group]
  end

  def get_db_table_description(db_table)
    db_table[1][:description]
  end

  def validate_columns!(db_table_name, db_columns)
    # ささやかなバリデーション
    return if db_columns.class == Hash
    p "#{db_table_name} columns error"
    exit
  end

  def create_table_tag(db_table_name, db_columns, db_table_description)
    table_tag = "<table border='0' cellborder='1' cellpadding='8'>"

    # DBのテーブル名
    table_tag += "<tr><td bgcolor='lightblue' colspan='#{TABLE_HEADER.size}'>#{db_table_name}</td></tr>"
    # ヘッダ(TABLE_HEADERから生成)
    table_tag += create_table_header
    # ボディ(DBのテーブルの各カラムのデータ)
    table_tag += create_table_body(db_columns)
    # フッタ
    table_tag += "<tr><td bgcolor='lightblue' colspan='#{TABLE_HEADER.size}'>#{nl2br(db_table_description)}</td></tr>"

    table_tag += '</table>'
    table_tag
  end

  def create_table_header
    table_header = '<tr>'
    TABLE_HEADER.each do |head|
      table_header += "<td bgcolor='lightblue'>#{head}</td>"
    end
    table_header += '</tr>'
    table_header
  end

  def create_table_body(db_columns)
    table_body = ''
    db_columns.each do |db_column, db_column_info|
      db_column_logical_name = db_column_info[:logical_name].presence || ''
      db_column_description = db_column_info[:description].presence || ''
      db_column_options = db_column_info[:options].presence || {}

      # 表示する値とalignの指定
      table_columns = [
        { val: db_column,                                             align: :left },
        { val: db_column_logical_name,                                align: :left },
        { val: db_column_info[:type],                                 align: :left },
        { val: convert_check_mark(db_column_options[:primary_key]),   align: :center },
        { val: convert_check_mark(db_column_options[:foreign_key]),   align: :center },
        { val: convert_check_mark(db_column_options[:not_null]),      align: :center },
        { val: db_column_options[:default],                           align: :left },
        { val: nl2br(db_column_description),                          align: :left }
      ]

      table_body += create_table_line(table_columns)
    end
    table_body
  end

  def convert_check_mark(val)
    val.present? ? '✔︎' : ''
  end

  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, '<br />')
  end

  def create_table_line(table_columns)
    table_line = '<tr>'
    table_columns.each do |table_column|
      table_line += "<td bgcolor='white' align='#{table_column[:align]}'>#{table_column[:val]}</td>" \
    end
    table_line += '</tr>'
    table_line
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
end
