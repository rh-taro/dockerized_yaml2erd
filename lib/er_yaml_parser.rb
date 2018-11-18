require 'er_yaml_model'

class ErYamlParser
  attr_reader :yaml_file_path
  attr_reader :models
  attr_reader :groups
  attr_reader :model_list

  def initialize(yaml_file_path)
    @yaml_file_path = yaml_file_path
    File.open(@yaml_file_path) do |file|
      @yaml_data = YAML.safe_load(file.read).deep_symbolize_keys
    end

    # modelのリスト
    @model_list = @yaml_data[:models].map do |h| h[0] end

    # YamlModelのハッシュ
    @models = {}
    @model_list.each do |model_name|
      @models[model_name] = ErYamlModel.new(@yaml_data[:models][model_name])
    end

    # groups
    @groups = @yaml_data[:groups]
  end
end
