module Schema2type

  DEFAULT_SCHEMA_PATH = "./db/schema.rb".freeze
  DEFAULT_NAME_SPACE = "schema".freeze

  def self.execute(input_file:, out_file:, name_space:, is_snake_case:)

    resultHash = eval(File.read(input_file || DEFAULT_SCHEMA_PATH), CovertService.new(is_snake_case).get_binding)

    File.open(out_file, "w") do |f|
      f.puts <<~EOS
        /* eslint no-unused-vars: 0 */

        /**
         * auto-generated file
         * schema version: #{resultHash[:version]}
         * This file was automatically generated by schema2type
         */
        declare namespace #{name_space || DEFAULT_NAME_SPACE} {
          #{resultHash[:lines]}
        }
      EOS
    end
  end
end
