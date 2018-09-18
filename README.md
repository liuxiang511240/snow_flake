# SnowFlake

This is a gem can generate ID using SnowFlake. The advantage of SnowFlake is that it is sorted by time increment on the whole, and there is no ID collision
(distinguished by data center ID and machine ID) in the whole distributed system, and it is more efficient.
After testing, SnowFlake can generate about 260,000 IDs per second

雪花算法简单描述： 
+ 最高位是符号位，始终为0，不可用。 
+ 41位的时间序列，精确到毫秒级，41位的长度可以使用69年。时间位还有一个很重要的作用是可以根据时间进行排序。 
+ 10位的机器标识，10位的长度最多支持部署1024个节点。 
+ 12位的计数序列号，序列号即一系列的自增id，可以支持同一节点同一毫秒生成多个ID序号，12位的计数序列号支持每个节点每毫秒产生4096个ID序号。

看的出来，这个算法很简洁也很简单，但依旧是一个很好的ID生成策略。其中，10位器标识符一般是5位IDC+5位machine编号，唯一确定一台机器。
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snow_flake'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snow_flake

## Usage

example
```ruby
SnowFlake::ID.new(0, 0).next_id
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/snow_flake. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SnowFlake project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/snow_flake/blob/master/CODE_OF_CONDUCT.md).
