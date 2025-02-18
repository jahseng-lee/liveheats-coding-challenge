# LiveHeats coding challenge

Small app to create and manage races between students

**DEMO:**
https://github.com/user-attachments/assets/40b66ef0-9911-4c54-be2f-2e3da5713a7a

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
