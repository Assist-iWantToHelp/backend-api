# backend-api
The backend for iWantToHelp platform

* Ruby version
  * Ruby: `2.7.2`
  * Create and use the gemset: `rvm use 2.7.2@ihelp [--create]`
  * Rails: `6.0.3`

* Node.js and yarn dependencies
  * https://guides.rubyonrails.org/getting_started.html#installing-node-js-and-yarn

* Configuration

  * Create `.env.development` and `.env.test` based on corresponding templates
  * Update new created files with your corresponding values

* Database creation & initialization
  * `rails db:setup`

* Run application locally
  * `rails s`
  * check it: `localhost:3000`
  * Volunteers: `localhost:3000/docs/volunteers`
  * HelpSeekers: `localhost:3000/docs/help_seekers`
