## SuperMegaUltra Rails App Generator Template!

This app was created using the template located [here](https://github.com/samgrimm/super-rails-template).

To see an example app built with this template [click here](https://sam-sample-blog.herokuapp.com/)

### How to use it:

* Copy or clone the repository
* Make sure you have postgresql running already (you can install it from [this link](https://www.postgresql.org/download/macosx/))
* Run `rails new <app-name> -m <path-to-cloned-repo>/template.rb -d postgresql`
* Follow the prompts
* When asked to overwrite files, say Yes (this will overwrite the original Rails generated files with the ones from this template)

### It has the following items pre-configured:

* Bootstrap 4 and FontAwesome
* Devise
* SendGrid
* gritter
* Custom scaffold templates
* Navbar partial and helpers
* English and Portuguese (Br) locales setup

### What it will do:

* Install the gems listed above and their dependencies
* Configure RSPEC with Factory Girl, Warden, and database_cleaner
* Update the application assets to get bootstrap, FontAwesome, and gritter
* Update application.rb with generator configuration and locale configuration
* Update application_controller with locale method
* Update the application layout to contain a Navbar and the calls to gritter, so you don't need to do anything after Devise setup
* Add helper methods to the application_helper to help edit the navbar, gritter
* Add initializers for Sendgrid setup
* Add locale files for EN and PT with some of the basic tags already translated
* Add generator templates for the scaffold that include locale paths, i18n tags, and some bootstrap styles
* Modify the scaffold generator to add has_many/belongs_to associations and use the view and controller files with the correct i18n tags
* Add the locale scope to routes.rb
* Run the first db:create and db:migrate
* Create a static_pages controller with a home (directed to root_path) and an about page
* Run the initial Git Commit command, so you start off great with git, and push to github all from the very first command

### To-dos after deployment

* Make sure to configure email server with the correct url by pasting the following line into production.rb
config.action_mailer.default_url_options = { :host => "<YourURLHere>" }
* Go to Heroku and add the SendGrid Add-on and follow the prompts:
  1. Go to Sender Whiz
  2. Choose * Integrate using SMTP Relay
  3. Create API key
  4. Verify Integration!
* You may need to install the tether gem to run some of the bootstrap features, so add this to your gemfile:

```ruby
source "https://rails-assets.org" do
  gem "rails-assets-tether"
end
```

### Why I built this
I found myself having to make several changes to the rails applications I was building in order to accommodate for i18n and the different locales. There was also adding bootstrap, devise, and rspec everytime, with their configurations. There were also some steps needed to deploy to heroku.

While none of these steps were particularly complicated or time consuming, I thought it would be a nice exercise to automate them. The result is a very basic app with authentication, deployed to heroku, which can be built upon using TDD (RSpec).

### Contribute
Bug reports and pull requests are welcome! This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.
