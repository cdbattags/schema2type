module Schema2type

  DEFAULT_SCHEMA_PATH = "./db/schema.rb".freeze
  DEFAULT_NAME_SPACE = "schema".freeze

  def self.execute(input_file:, out_file:, name_space:, snake_case:)

    result = eval(File.read(input_file || DEFAULT_SCHEMA_PATH), CovertService.new(snake_case).get_binding)

    File.open(out_file, "w") do |f|
      f.puts <<~EOS
        /* eslint no-unused-vars: 0 */

        /**
         * auto-generated file
         * schema version: #{result[:version]}
         * This file was automatically generated by schema2type
         */
        declare namespace #{name_space || DEFAULT_NAME_SPACE} {
          #{result[:lines]}
        }
      EOS
    end
  end
end
