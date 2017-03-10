gem 'rspec-rails', '~> 3.5', '>= 3.5.2', group: ["test", "development"]
gem 'capybara', '~> 2.12', '>= 2.12.1', group: ["test", "development"]
gem 'database_cleaner', '~> 1.5', '>= 1.5.3', group: ["test", "development"]
gem 'factory_girl_rails', '~> 4.8', group: ["test", "development"]
gem 'friendly_id', '~> 5.1.0'
gem 'bootstrap', '~>4.0.0.alpha6'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.1'
gem 'jquery-ui-rails', '~>6.0', '>=6.0.1'
gem 'dotenv-rails', '~>2.1', '>=2.1.2'
gem 'gritter', '~>1.2'
gem 'rails-i18n', '~> 5.0', '>= 5.0.3'
gem 'i18n-tasks', '~>0.9.8'
gem 'rails_12factor'

rails_command("generate rspec:install")

if yes?("Would you like to install Devise?")
  gem 'devise', '~>4.2'
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
  directory "~/workspace/templates/RailsTemplates/app/views/devise", "app/views/devise"
end

remove_file  "app/assets/stylesheets/application.css"
remove_file  "app/assets/stylesheets/application.js"
remove_file  "spec/rails_helper.rb"
remove_file  "spec/spec_helper.rb"
remove_file  "app/controllers/application_controller.rb"
remove_file  "app/helpers/application_helper.rb"
remove_file  "app/views/layouts/application.html.erb"
directory "~/workspace/templates/RailsTemplates/locales", "config/locales"
copy_file  "~/workspace/templates/RailsTemplates/application_controller.rb","app/controllers/application_controller.rb"
copy_file "~/workspace/templates/RailsTemplates/i18n.rb", "config/initializers/i18n.rb"
copy_file "~/workspace/templates/RailsTemplates/rails_helper.rb", "spec/rails_helper.rb"
copy_file "~/workspace/templates/RailsTemplates/spec_helper.rb", "spec/spec_helper.rb"
copy_file "~/workspace/templates/RailsTemplates/setup_mail.rb", "config/initializers/setup_mail.rb"
copy_file "~/workspace/templates/RailsTemplates/application.js", "app/assets/javascripts/application.js"
copy_file "~/workspace/templates/RailsTemplates/application.scss", "app/assets/stylesheets/application.scss"
copy_file "~/workspace/templates/RailsTemplates/i18n-tasks.yml", "config/i18n-tasks.yml"
copy_file "~/workspace/templates/RailsTemplates/application_helper.rb", "app/helpers/application_helper.rb"
copy_file "~/workspace/templates/RailsTemplates/application.html.erb", "app/views/layouts/application.html.erb"
copy_file "~/workspace/templates/RailsTemplates/nav.html.erb", "app/views/shared/_nav.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/index.html.erb", "lib/templates/erb/scaffold/index.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/show.html.erb", "lib/templates/erb/scaffold/show.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/edit.html.erb", "lib/templates/erb/scaffold/edit.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/new.html.erb", "lib/templates/erb/scaffold/new.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/_form.html.erb", "lib/templates/erb/scaffold/_form.html.erb"
copy_file "~/workspace/templates/RailsTemplates/scaffold/controller.rb", "lib/templates/rails/scaffold_controller/controller.rb"
copy_file "~/workspace/templates/RailsTemplates/scaffold_generator.rb", "lib/rails/generators/erb/scaffold/scaffold_generator.rb"
copy_file "~/workspace/templates/RailsTemplates/README.md", "README.md"

application "config.generators do |g|
      g.orm :active_record
      g.template_engine :erb
      g.test_framework :rspec
      g.stylesheets false
      g.javascript false
    end
    config.i18n.default_locale = :en
    I18n.enforce_available_locales = false"

if yes?("Would you like to create static pages (home about)?")
  generate(:controller, "StaticPages home about")
  route "root to: 'static_pages#home'"
  route "get 'about', to: 'static_pages#about'"
end

if yes?("Would you like to start off with a scaffold?")
  scaffold_name = ask("What is your scaffold name?")
  lower_scaffold = scaffold_name.pluralize.downcase.to_sym
  scaffold_attrs = ask("What are the scaffold attrs? (list them as you would in your generator)")
  scaffold_params = "#{scaffold_name} #{scaffold_attrs}"
  generate :scaffold, scaffold_params
end


inject_into_file 'config/environments/development.rb', after: "# routes, locales, etc. This feature depends on the listen gem.\n" do <<-'RUBY'
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false
RUBY
end

inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-'RUBY'
  scope '(:locale)' do
RUBY
end

inject_into_file 'config/routes.rb', after: "# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\n" do <<-'RUBY'
  end
RUBY
end

after_bundle do
  rails_command("generate friendly_id")
  rails_command("db:create")
  rails_command("db:migrate")
  locales = ask("What localed do you want to add to this app? (Comma-separated list of locale(s) to process)")
  inside("") do
    run("i18n-tasks add-missing --locales #{locales}")
  end
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  if yes?("Do you want to upload to a github repo?")
    github_repo = ask("What is your repo url?")
    git remote: %Q{add origin #{github_repo}}
    git push: %Q{ -u origin master}
    if yes?("Would you like to deploy to Heroku?")
      heroku_name = ask("What is the name of the heroku url you want to use? (leave blank if you want a heroku generated name)")
      inside("") do
        run("heroku create #{heroku_name}")
        git push: %Q{ heroku master }
        run("heroku run rake db:migrate")
      end
    end
  end
end
