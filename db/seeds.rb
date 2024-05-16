# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

StampsType.create(name: "Like")

Genre.create([
  { name: "中華" },
  { name: "イタリアン" },
  { name: "和食" },
  { name: "フレンチ" },
  { name: "アメリカン" },
  { name: "洋食" },
	{ name: "その他" },
  # 追加したいジャンルをここに追加してください
])

Menu.create([
  { name: "唐揚げ" },
  { name: "カレーライス" },
  { name: "ハンバーグ" },
  { name: "ピザ" },
  { name: "ラーメン" },
  { name: "天ぷら" },
  { name: "餃子" },
  { name: "パスタ" },
  { name: "カレー" },
  { name: "サンドイッチ" },
  { name: "シチュー" },
  { name: "オムライス" },
  { name: "鍋" },
  { name: "お好み焼き" },
  { name: "ステーキ" },
  { name: "カツ丼" },
  { name: "うどん" },
  { name: "そば" },
  { name: "チャーハン" },
  { name: "カルボナーラ" },
  { name: "焼きそば" },
  { name: "チキンライス" },
  { name: "トンカツ" },
  { name: "ムニエル" },
  { name: "パエリア" },
  { name: "鶏のから揚げ" },
	{ name: "焼き鳥" },
  { name: "フライドポテト" },
  { name: "タコス" },
  { name: "ビーフシチュー" },
  { name: "パスタ" },
  { name: "エビフライ" },
  { name: "エビチリ" },
  { name: "カニクリームコロッケ" },
  { name: "マグロ丼" },
  { name: "カキフライ" },
  { name: "アサリの酒蒸し" },
  { name: "エビマヨ" },
  { name: "スープカレー" },
  { name: "ガパオライス" },
	{ name: "その他" },
  # 追加したいメニューをここに追加してください
])