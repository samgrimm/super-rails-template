require 'rails/generators/erb'
require 'rails/generators/resource_helpers'

module Erb # :nodoc:
  module Generators # :nodoc:
    class ScaffoldGenerator < Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      argument :attributes,
               type: :array,
               default: [],
               banner: 'field:type field:type'

      def create_root_folder
        empty_directory File.join('app/views', controller_file_path)
      end

      def reference_attrs
        if attributes.last.type == :references && attributes.last.name == 'user'
          add_has_many
        end
        copy_view_files
      end

      private

      def copy_view_files
        available_views.each do |view|
          formats.each do |format|
            filename = filename_with_extensions(view, format)
            template filename, File.join(
              'app/views',
              controller_file_path,
              filename
            )
          end
        end
      end

      def add_has_many
        after_str = "class User < ApplicationRecord\n"
        inject_into_file 'app/models/user.rb', after: after_str do
          "has_many :#{controller_file_path}\n"
        end
      end

      def available_views
        %w(index edit show new _form)
      end
    end
  end
end
