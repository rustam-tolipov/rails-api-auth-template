# rails-api-auth-template

> fast start rails api auth setup with devise + jwt

## 🚀 what is this?

this is a rails 7.2 api-only template with jwt authentication using devise.
you can skip the boring setup and jump straight into building cool stuff.

## 🧠 why tho?

because every time you start a new project, you forget one step.
or five.
or all of them.

this template saves you from:

* repeating the same setup 900 times
* googling “rails api jwt devise setup” again
* crying over untracked .env files

## 🔧 stack

* ruby 3.3.1
* rails 7.2.2.1 (api-only)
* devise (user auth)
* jwt (hand-rolled, no devise-jwt dependency)
* rspec + rswag (for testing + swagger docs)
* dotenv (for managing secrets)
* rack-cors (so your frontend doesn’t scream)

## ⚙️ setup

```bash
git clone https://github.com/yourname/rails-api-auth-template.git
cd rails-api-auth-template
bundle install
yarn install # (if needed)
cp .env.example .env
rails db:create db:migrate
```

## 🔐 auth flow

### signup

```bash
POST /api/v1/signup
{
  "email": "bob@random.com",
  "password": "123456",
  "password_confirmation": "123456"
}
```

returns a jwt + user json

### login

```bash
POST /api/v1/login
{
  "email": "bob@random.com",
  "password": "123456"
}
```

returns a jwt + user json

### profile (protected)

```bash
GET /api/v1/profile
Authorization: Bearer <your_token>
```

returns current user

### logout

```bash
POST /api/v1/logout
```

just a client-side logout trigger. token = gone.

## 📖 swagger ui

run:

```bash
RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
rails s
```

open [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

## 🧪 test

```bash
rspec
```

## 🤝 contribute

open to contributions, improvements, or just saying hi.
open issues or pull requests.

## 🧼 todo

* add blacklisted token support (aka real logout)
* add refresh tokens
* add role-based auth maybe?

## 📢 shoutout

built to help devs like you (and me) avoid setup fatigue.
feel free to fork, star, share, or improve.

## ⚠️ disclaimer

this is not prod-ready out of the box. it's a starter kit.
use with brain.

---

made with ♥ by rustam
