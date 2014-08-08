# ExplainParser

Parser for result of EXPLAIN of MySQL(inspired from http://search.cpan.org/~moznion/MySQL-Explain-Parser-0.02/lib/MySQL/Explain/Parser.pm)

## Installation

Add this line to your application's Gemfile:

    gem 'explain_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install explain_parser

## Usage

```ruby
input <<-EOS
+----+-------------+-------+------+---------------+------+---------+------+------+----------------------------------------------------------+
| id | select_type | table | type | possible_keys | key  | key_len | ref  | rows | Extra                                                    |
+----+-------------+-------+------+---------------+------+---------+------+------+----------------------------------------------------------+
|  1 | SIMPLE      | users | ALL  | NULL          | NULL | NULL    | NULL |  155 | Using where; Using index Using temporary; Using filesort |
+----+-------------+-------+------+---------------+------+---------+------+------+----------------------------------------------------------+
1 row in set (0.00 sec)
EOS

parser = ExplainParser.new(input)
explains = parser.parse
explain = explains.first

explain.id #=> 1
explain.select_type #=> 'SIMPLE'

...

explain.rows #=> 155
explain.extra #=> 'Using where; Using index Using temporary; Using filesort'
explain.using_filesort? #=> true
explain.using_where? #=> true
explain.using_temporary? #=> true
explain.using_index? #=> true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/explain_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
