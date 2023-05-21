# メインのサンプルユーザーを1人作成する
User.create!(name:  "珈琲 店長",
    email: "user0@example.com",
    password:              "password",
    password_confirmation: "password",
    admin: true)

# 追加のユーザーをまとめて生成する
19.times do |n|
name  = Gimei.name.kanji
email = "user#{n+1}@example.com"
password = "password"
User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end