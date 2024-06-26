# Protoform

An experimental fork of [Superform](https://github.com/rubymonolith/superform).
Uses [protos](https://github.com/inhouse-work/protos) as base components.

This is a more opinionated version of Superform. My goal is to maintain feature
parity with and contribute features back to Superform.

## Usage

```
gem "protos-protoform", require: "protoform"
```

Once the gem is installed you can run the generators:

```
bin/rails g protoform:install
```

This will:

- Add `phlex-rails` to your gemfile if it does not exist
- Add `layouts`, `components` and other folders to be autoloaded from `app/views`
- Add an `ApplicationForm` as the base form class to your `app/views`

This gem follows the same conventions as Superform with some key differences:

- Components are expected to inherit from `Protos::Component` so your
  `ApplicationComponent` should inherit from that

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rubymonolith/superform. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [code of
conduct](https://github.com/rubymonolith/superform/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Superform project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/rubymonolith/superform/blob/main/CODE_OF_CONDUCT.md).
