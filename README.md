# LiveHeats coding challenge

Small app to create and manage races between students

**DEMO:**

https://github.com/user-attachments/assets/14d484c8-3779-41d6-a576-88483b6f9f75

Find the demo here: [https://liveheats-coding-challenge-21d393942147.herokuapp.com/](https://liveheats-coding-challenge-21d393942147.herokuapp.com/)

## Basic setup

Requirements:

* Ruby 3.3.6 (or compatible)
* Rails 8.0.1
* Postgres 14.16

```bash
$ git clone git@github.com:jahseng-lee/liveheats-coding-challenge.git
$ cd liveheats-coding-challenge
$ ./bin/setup
```

Then the app should be available at `localhost:3000`

## Running tests

This project uses RSpec and Jest.

Requirements:
* Jest
* Chrome (feature tests use `selenium` and `chrome` as the driver)

```ruby
bundle exec rspec && yarn test
```

If you wish to run feature specs in headless mode, run
```ruby
HEADLESS=1 bundle exec rspec spec/features
```

The Ruby tests can be found under `spec/` directory.\
There are a couple of Jest tests, under:
* `app/javascript/bundles/Races/components/CreateRace/CreateRace.test.jsx`; and
* `app/javascript/bundles/Races/components/Navbar/Navbar.test.jsx`
