# frozen_string_literal: true

# usage:
# $ docker-compose build
# $ docker-compose up -d
# $ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml
# or
# $ docker-compose exec yaml2erd rails runner app/scripts/yaml_dump.rb app/yaml/table.yaml -c config/gv_conf.yaml -o erd/table

# TODO: yamlの文法チェック, gem化, specでschema保証できるように、ciやらhookやらいい感じにプロジェクトに取り込める形を想定
# 設計の補助ツールとして 最終的には設計から保守までずっと使えるように
# ref: https://qiita.com/asmsuechan/items/0c943aba2ff3e06f3d98
# ref: https://qiita.com/rubytomato@github/items/51779135bc4b77c8c20d
# ref: https://teratail.com/questions/126320
# ref: https://renenyffenegger.ch/notes/tools/Graphviz/examples/index

require 'optparse'
require './lib/yaml_2_erd.rb'

options = {}
OptionParser.new do |opt|
  opt.on('-c [VALUE]', 'config path') { |v| options[:c] = v }
  opt.on('-o [VALUE]', 'output path') { |v| options[:o] = v }
  opt.parse!(ARGV)
end

parser = Yaml2Erd.new(ARGV[0], options[:c])
# gvizへ書き出し
parser.write_erd
# 保存
parser.file_save(save_path: options[:o])
