# frozen_string_literal: true

# usage:
# $ docker-compose build
# $ docker-compose up -d
# $ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml

# TODO: yamlの文法チェック, gem化, specでschema保証できるように,設定のyaml化、erdにnot null、pk、default欄追加、ciやらhookやらいい感じにプロジェクトに取り込める形を想定
# TODO: グルーピング(name,bgcolor)
# 設計の補助ツールとして 最終的には設計から保守までずっと使えるように
# ref: https://qiita.com/asmsuechan/items/0c943aba2ff3e06f3d98
# ref: https://qiita.com/rubytomato@github/items/51779135bc4b77c8c20d
# ref: https://teratail.com/questions/126320
# ref: https://renenyffenegger.ch/notes/tools/Graphviz/examples/index

require './lib/yaml_to_er_parser.rb'

file_path = ARGF.filename
parser = YamlToErParser.new(file_path)

# 共通設定
parser.gviz_nodes(shape: 'Mrecord', fontname: 'Noto Sans CJK JP Black', fontsize: 50)
parser.gviz_global(layout: 'dot')

# gvizへ書き出し
parser.write_erd

# 保存
parser.file_save
