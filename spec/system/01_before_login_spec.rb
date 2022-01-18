require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Sign upリンクが表示される: 表示が「SIGN UP」である' do
        sign_up_link = find_all('a')[0].native.inner_text
        expect(sign_up_link).to match(/SIGN UP/)
      end
      it 'Sign upリンクの内容が正しい' do
        sign_up_link = find_all('a')[0].native.inner_text
        expect(page).to have_link sign_up_link, href: '/users/sign_up'
      end
      it 'Log inリンクが表示される: 表示が「LOG IN」である' do
        log_in_link = find_all('a')[1].native.inner_text
        expect(log_in_link).to match(/LOG IN/)
      end
      it 'Log inリンクの内容が正しい' do
        log_in_link = find_all('a')[1].native.inner_text
        expect(page).to have_link log_in_link, href: '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'Mypageリンクが表示されない' do
        expect(page).not_to have_link 'Mypage'
      end
      it 'Usersリンクが表示されない' do
        expect(page).not_to have_link 'Users'
      end
      it 'Postsリンクが表示されない' do
        expect(page).not_to have_link 'Posts'
      end
      it 'Categoryリンクが表示されない' do
        expect(page).not_to have_link 'Category'
      end
      it 'Logoutリンクが表示されない' do
        expect(page).not_to have_link 'Logout'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button 'Sign up'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
    context '新規登録失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'Sign up'
      end
      it '新規登録に失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq '/users'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'emailフォームは表示されない' do
        expect(page).not_to have_field 'user[email]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end
      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end
    context 'ヘッダーの表示を確認' do
      it 'Mypageリンクが表示される: 左から1番目のリンクが「Mypage」である' do
        mypage_link = find_all('a')[0].native.inner_text
        expect(mypage_link).to match(/Mypage/)
      end
      it 'Usersリンクが表示される: 左から2番目のリンクが「Users」である' do
        users_link = find_all('a')[1].native.inner_text
        expect(users_link).to match(/Users/)
      end
      it 'Postsリンクが表示される: 左から3番目のリンクが「Posts」である' do
        posts_link = find_all('a')[2].native.inner_text
        expect(posts_link).to match(/Posts/)
      end
      it 'Categoryリンクが表示される: 左から4番目のリンクが「Category」である' do
        categories_link = find_all('a')[3].native.inner_text
        expect(categories_link).to match(/Category/)
      end
      it 'Logoutリンクが表示される: 左から5番目のリンクが「Logout」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/Logout/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end
    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        logout_link = find_all('a')[9].native.inner_text
        logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link logout_link, match: :first
        expect(current_path).to eq '/'
      end
    end
  end
end
