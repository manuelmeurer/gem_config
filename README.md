# GemConfig

[![Gem Version](https://badge.fury.io/rb/gem_config.png)](http://badge.fury.io/rb/gem_config)
[![Build Status](https://secure.travis-ci.org/krautcomputing/gem_config.png)](http://travis-ci.org/krautcomputing/gem_config)
[![Code Climate](https://codeclimate.com/github/krautcomputing/gem_config.png)](https://codeclimate.com/github/krautcomputing/gem_config)

A nifty way to make your gem configurable.

## Usage

### As a gem author

Include the gem and add configuration options like this:

```ruby
# awesomeness.gemspec
Gem::Specification.new do |gem|
  ...
  gem.add_runtime_dependency 'gem_config'
end
```

```ruby
# lib/awesomeness.rb
require 'gem_config'

module Awesomeness
  include GemConfig::Base

  with_configuration do
    has :api_key, classes: String
    has :format, values: [:json, :xml], default: :json
    has :region, values: ['us-west', 'us-east', 'eu'], default: 'us-west'
  end
end
```

Access the configuration values in the gem's code like this:

```ruby
Awesomeness.configuration.api_key # Whatever the user set
```

To execute something after the gem is configured:

```ruby
module Awesomeness
  include GemConfig::Base
  
  # ...
  
  after_configuration_change do
    # configure some other gem you're using, perhaps
  end
end
```

### As a gem user

Include and configure a gem like this:

```ruby
# Gemfile
gem 'awesomeness'
```

```ruby
# config/initializers/awesomeness.rb
Awesomeness.configure do |config|
  config.api_key = 'foobarbaz'
  config.format  = :xml
  config.region  = 'eu'
end
# or
Awesomeness.configuration.api_key = 'foobarbaz'
```

Of course configuration values are checked against the allowed `classes` and `values`, and the `default` is used if no value is provided.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Support

If you like this project, consider [buying me a coffee](https://www.buymeacoffee.com/279lcDtbF)! :)
