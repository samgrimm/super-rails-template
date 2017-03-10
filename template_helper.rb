copy_file "~/workspace/templates/RailsTemplates/scaffold/controller.rb", "lib/templates/rails/scaffold_controller/controller.rb"
if yes?("Would you like to install Devise?")
  gem 'devise', '~>4.2'
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
  directory "~/workspace/templates/RailsTemplates/app/views/devise", "app/views/devise"
end
if yes?("Would you like to start off with a scaffold?")
  scaffold_name = ask("What is your scaffold name?")
  lower_scaffold = scaffold_name.pluralize.downcase.to_sym
  scaffold_attrs = ask("What are the scaffold attrs? (list them as you would in your generator)")
  scaffold_params = "#{scaffold_name} #{scaffold_attrs}"
  generate :scaffold, scaffold_params --scaffold-controller=user_controller
  if scaffold_attrs.include? "user:references"
    inject_into_file 'app/models/user.rb', after: "class User < ApplicationRecord\n" do
      "has_many :#{lower_scaffold}"
    end
  end
end
