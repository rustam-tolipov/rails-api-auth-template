![Ruby](https://img.shields.io/badge/ruby-3.3.1-red)
![Rails](https://img.shields.io/badge/rails-7.2.2.1-red)
![RSpec](https://img.shields.io/badge/tested%20with-rspec-blue)
![Swagger](https://img.shields.io/badge/docs-swagger-yellow)

# rails-api-auth-template

> fast start rails api auth setup with devise + jwt

## 🚀 what is this?

this is a rails 7.2 api-only template with jwt authentication using devise.
you can skip the boring setup and jump straight into building cool stuff.

![screenshot](https://github.com/user-attachments/assets/278b23fd-46d0-4085-9170-45a8da140e6f)

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
* rack-attack (rate limiting — no room for brute force bots)

## 🧪 how to use this as a template

1. click the green **“Use this template”** button on the top-right
2. name your new repo (e.g. `my-next-api`)
3. clone it
4. run the setup:

```bash
bundle install
cp .env.example .env
rails db:create db:migrate
```

## ⚙️ or setup as a starter project

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

returns access token + refresh token + user json

### login

```bash
POST /api/v1/login
{
  "email": "bob@random.com",
  "password": "123456"
}
```

returns access token + refresh token + user json

### refresh

```bash
POST /api/v1/refresh
{
  "refresh_token": "<your_refresh_token>"
}
```

returns a new access token (keeps you logged in without re-entering credentials)

### profile (protected)

```bash
GET /api/v1/profile
Authorization: Bearer <your_access_token>
```

returns current user

### logout

```bash
POST /api/v1/logout
Authorization: Bearer <your_access_token>
```

blacklists the current token (real logout, token becomes invalid)

## 👥 role-based authorization

users have roles: `user` (default), `moderator`, or `admin`

### example: admin-only endpoint

```bash
GET /api/v1/admin/dashboard
Authorization: Bearer <admin_access_token>
```

returns admin dashboard data (403 forbidden for non-admins)

### using roles in your controllers

```ruby
class MyController < ApplicationController
  include AuthorizeRequest
  include AuthorizeRole

  before_action :require_admin  # only admins
  # or
  before_action :require_moderator  # admins + moderators
end
```

## 🔒 security features

* **no secret fallbacks**: JWT_SECRET_KEY must be set (crashes if missing)
* **token blacklisting**: logout actually invalidates tokens
* **refresh tokens**: short-lived access tokens (1 hour) + long-lived refresh tokens (7 days)
* **rate limiting**: login, signup, and refresh endpoints are throttled
* **JTI tracking**: every token has a unique identifier for precise control
* **automatic cleanup**: expired tokens can be cleaned via scheduled jobs

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

## 🚀 production considerations

### cleanup jobs

add these to your scheduled jobs (sidekiq, cron, etc):

```ruby
# clean up expired blacklisted tokens
BlacklistedToken.cleanup_expired

# clean up old refresh tokens
RefreshToken.cleanup_old_tokens
```

### environment variables

make sure to set these in production:

```bash
JWT_SECRET_KEY=your_super_secret_key_here_use_rails_secret
DATABASE_URL=your_database_url
REDIS_URL=your_redis_url (optional, for rack-attack)
```

### database indexes

migrations include proper indexes for performance:
* `blacklisted_tokens.jti` (unique)
* `blacklisted_tokens.exp`
* `refresh_tokens.token` (unique)
* `refresh_tokens.user_id + revoked`
* `users.role`

## 🤝 contribute

open to contributions, improvements, or just saying hi.
open issues or pull requests.

## ✨ features

* ✅ JWT authentication with secure token generation (includes JTI for tracking)
* ✅ Token blacklisting for real logout (tokens are invalidated on logout)
* ✅ Refresh tokens (7-day expiry, keeps users logged in securely)
* ✅ Role-based authorization (user, moderator, admin roles)
* ✅ Rate limiting with Rack::Attack (prevents brute force attacks)
* ✅ Comprehensive test coverage with RSpec
* ✅ Swagger API documentation via rswag
* ✅ Security best practices (no fallback secrets, proper validation)

## 🧼 todo

* add email confirmation for signup 📧
* add password reset functionality 🔑
* add remember me token (long-lived sessions) 💾
* add oauth providers (google, github, etc) 🔗

## 📢 shoutout

built to help devs like you (and me) avoid setup fatigue.
feel free to fork, star, share, or improve.

## ⚠️ disclaimer

this template includes production-grade features like token blacklisting, refresh tokens, and role-based auth.
however, you should still:
* review security settings for your specific use case
* set up proper monitoring and logging
* configure ssl/tls in production
* add email confirmation if needed
* implement proper error tracking

use responsibly and test thoroughly before deploying.

---

made with ♥ by rustam
