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
