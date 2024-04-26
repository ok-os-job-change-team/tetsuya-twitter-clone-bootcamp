# README

## `db/schema/user.schema`を反映させるには

ridgepole(gem)の導入と`lib/tasks/ridgepole.rake`により、下記コマンドの実行で`db/schema.rb`の更新と DB への反映が同時に行われる

```bash
rake ridgepole:apply

# test環境のDBに反映させる場合
rake ridgepole:apply test
```

## `db/seeds.rb`を DB に反映させるには

```bash
rake db:seed

# test環境のDBに反映させる場合
rake db:seed RAILS_ENV=test
```

## binding.pry を使えるようにする

コード中に`binding.pry`を記述することで、実行時にその箇所で処理を一時的に止めることができる

```ruby:Gemfile
# Gemfile
group :development, :test do
  # 省略
  # https://github.com/pry/pry-rails
  gem 'pry-rails'

  # https://github.com/deivid-rodriguez/pry-byebug
  gem 'pry-byebug'
end
```

```ruby:spec/spec_helper.rb
# spec/spec_helper.rb
RSpec.configure do |config|
  require 'pry'
  # 省略
end
```

```ruby:pry_test_spec.rb
# pry_test_spec.rb
RSpec.describe User, type: :model do
  describe '#validation' do
    context '属性が全て有効な値であるとき' do
      let(:user) { build(:user) }

      it 'userが有効であり、errorsが空である' do
        aggregate_failures do
          user.valid?
          binding.pry # <= ここで止まる
          expect(user.valid?).to be true
          expect(user.errors.full_messages).to eq([])
        end
      end
    end
  end
end
```

ターミナルで`exit`を入力すると、停止から抜け出せる
