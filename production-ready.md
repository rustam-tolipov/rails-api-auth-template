- [ ] ⚙️ **1. Initial Project Setup**
  - [x] `rails new your_app_name --api -T`
  - [ ] Add `pg`, `devise`, `devise-jwt`, `rswag`, `rack-cors`, `dotenv-rails`, `rubocop`, etc. to Gemfile
  - [ ] Setup `.ruby-version` and `.tool-versions` if using asdf or rbenv
  - [ ] Initialize Git and create `production-ready` branch

- [ ] 🔐 **2. Devise Setup**
  - [ ] `rails generate devise:install`
  - [ ] Create User model: `rails generate devise User`
  - [ ] Add JWT config to `devise.rb`
  - [ ] Add `jwt_revocation_strategy` to User model
  - [ ] Migrate DB: `rails db:create db:migrate`
  - [ ] Setup `devise_for :users` in `routes.rb` (under `/api/v1` namespace)
  - [ ] Customize Devise responses to return JSON only

- [ ] 🔄 **3. Refresh Token & Revocation**
  - [ ] Choose revocation strategy (`:blacklist` or custom model)
  - [ ] Create `JwtDenylist` model if using blacklist strategy
  - [ ] Add token revocation logic to logout endpoint
  - [ ] Add refresh token endpoint (custom controller)

- [ ] 🌐 **4. CORS + Cookie Auth**
  - [ ] Install and configure `rack-cors`
  - [ ] Allow specific origins and methods (e.g., `localhost:3000`, `mobile://app`)
  - [ ] Configure JWT in cookies (if using HttpOnly secure cookies)
  - [ ] Enable CSRF protection if cookie-based fallback is enabled

- [ ] 🧰 **5. Dev Tools & Linters**
  - [ ] Setup `rubocop` with default config + Rails rules
  - [ ] Add `.env` with `DEVISE_JWT_SECRET_KEY`
  - [ ] Setup `rswag` (Swagger) for API documentation

- [ ] 🧪 **6. Testing Setup**
  - [ ] Add `rspec-rails` and `factory_bot_rails`
  - [ ] Generate request specs for:
    - [ ] Signup
    - [ ] Login
    - [ ] Logout
    - [ ] Refresh token
  - [ ] Add model spec for User

- [ ] 🧱 **7. Optional Add-Ons (Future-Proof)**
  - [ ] Add roles via `enum role: [:user, :admin]`
  - [ ] Add Confirmable to Devise (email confirmation)
  - [ ] Add `rack-attack` for rate limiting
  - [ ] Prepare for omniauth setup (Google, GitHub)

- [ ] 🚀 **8. Finalize for Real Use**
  - [ ] Test with Postman or Insomnia
  - [ ] Swagger documentation ready
  - [ ] Sample React/Mobile app README section
  - [ ] Push to GitHub with full README + usage
