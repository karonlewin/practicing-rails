module SessionHelper
  def sign_in(user, password=nil)
    visit new_user_session_path
    fill_in User.human_attribute_name(:login), with: (user.is_a?(User) ? user.login : user)
    fill_in User.human_attribute_name(:password), with: (password || user.is_a?(User) && user.password || '')
    click_button I18n.t('devise.links.sign_in')
  end

  def warden_sign_in user
    login_as(user, :scope => :user)
    allow_any_instance_of(ActionController::Base).to receive(:current_user).and_return user
  end

  module HttpBasic
    def http_auth_with_role role
      pw = 'password1234'
      http_auth_with_user create(:user, role: role, password: pw,
        password_confirmation: pw), pw
    end

    def http_auth_with_user user, password
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic
        .encode_credentials(user.login, password)
    end
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :feature
  config.include SessionHelper, type: :controller
  config.include SessionHelper::HttpBasic, type: :controller

  include Warden::Test::Helpers
  Warden.test_mode!

  config.after(:each) do
    Warden.test_reset!
  end
end
