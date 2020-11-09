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

* Heroku deployment
  * [`sudo snap install heroku`] - install Heroku
  * `heroku login`
  * `heroku git:remote -a iwanttohelp` - Add remote to the local repository
  * `git config --list --local | grep heroku` - verifies that the remote is added to your project
  * `git push heroku main` - pushes `main` branch to Heroku
  * `heroku run rake db:migrate` - applies the migrations
  * `heroku ps:scale web=1` - checks that the dyno is running
  * `heroku ps` - checks the state of the app's dyno
  * `heroku open` - visits the app in the browser
  * `heroku logs` - checks the logs
  * `heroku run rails console` - runs the Rails console on server
