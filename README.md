# LiveHeats coding challenge

Small app to create and manage races between students

## Basic setup

Requirements:

* Ruby 3.3.6 (or compatible)
* Rails 8.0.1

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
