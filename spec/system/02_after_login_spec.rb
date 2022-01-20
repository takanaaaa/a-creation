require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'Mypageを押すと、自分のユーザ詳細画面に遷移する' do
        mypage_link = find_all('a')[0].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link, match: :first
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[1].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link, match: :first
        is_expected.to eq '/users'
      end
      it 'Postsを押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[2].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link, match: :first
        is_expected.to eq '/posts'
      end
      it 'Categoryを押すと、投稿一覧画面に遷移する' do
        category_link = find_all('a')[3].native.inner_text
        category_link = category_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link category_link, match: :first
        is_expected.to eq '/categories'
      end
    end
  end

  describe '投稿のテスト' do
    let!(:my_post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: other_user) }

    describe '投稿一覧画面のテスト' do
      before do
        visit posts_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts'
        end
        it '自分と他人の投稿画像が表示される: fallbackの画像が2つ存在する' do
          expect(all('.card-img-top').size).to eq(2)
        end
        it '自分の投稿と他人の投稿の投稿者のリンク先がそれぞれ正しい' do
          expect(page).to have_link my_post.user.name, href: user_path(user)
          expect(page).to have_link other_post.user.name, href: user_path(other_user)
        end
        it '自分の投稿と他人の投稿の本文が表示される' do
          expect(page).to have_content my_post.body
          expect(page).to have_content other_post.body
        end
        # it '投稿のタグが表示される' do
        #   expect(page).to have_content my_post.tags
        #   expect(page).to have_content other_post.tags
        # end
        # it '投稿のブックマークが表示される' do
        # end
        it '新規投稿のリンクが存在する' do
          expect(page).to have_link '', href: new_post_path
        end
        it 'タグ検索フォームが表示される' do
          expect(page).to have_field 'word'
        end
      end

      context '投稿一覧リンクのテスト' do
        it '投稿画像をクリックすると投稿詳細画面へ遷移する' do
          page.all('a')[11].click
          expect(current_path).to eq '/posts/' + my_post.id.to_s
        end
        it 'ユーザをクリックするとユーザ詳細画面へ遷移する' do
          click_link my_post.user.name
          expect(current_path).to eq '/users/' + user.id.to_s
        end
        it '新規投稿をクリックすると新規投稿画面へ遷移する' do
          click_link '', href: new_post_path
          expect(current_path).to eq '/postss/new'
        end
      end

      context '投稿成功のテスト' do
        before do
          visit new_post_path
          fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        end

        it '自分の新しい投稿が正しく保存される' do
          expect { click_button '投稿' }.to change(user.posts, :count).by(1)
        end
        it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
          click_button '投稿'
          expect(current_path).to eq '/posts/' + Post.last.id.to_s
        end
      end
    end

    describe '自分の投稿詳細画面のテスト' do
      before do
        visit post_path(my_post)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + my_post.id.to_s
        end
        it '投稿のbodyが表示される' do
          expect(page).to have_content my_post.body
        end
        it '投稿の編集リンクが表示される' do
          expect(page).to have_link '編集', href: edit_post_path(my_post)
        end
        it '投稿の削除リンクが表示される' do
          expect(page).to have_link '削除', href: post_path(my_post)
        end
      end

      context '編集リンクのテスト' do
        it '編集画面に遷移する' do
          click_link '編集'
          expect(current_path).to eq '/posts/' + my_post.id.to_s + '/edit'
        end
      end

      context '削除リンクのテスト' do
        before do
          click_link '削除'
        end

        it '正しく削除される' do
          expect(Post.where(id: my_post.id).count).to eq 0
        end
        it 'リダイレクト先が、投稿一覧画面になっている' do
          expect(current_path).to eq '/posts'
        end
      end

      context 'コメントのテスト' do
        context '表示の確認' do
          it 'commentフォームが表示されている' do
            expect(page).to have_field 'post_comment[comment]'
          end
          it '送信ボタンが表示される' do
            expect(page).to have_button '送信'
          end
        end

        # it 'コメントが正常の投稿されること' do
        #   expect {
        #     fill_in 'post_comment[comment]', with: "コメントテスト"
        #     click_button '送信'
        #     visit current_path
        #   }.to change(PostComment, :count).by(1)
        # end

        # context 'コメント送信成功のテスト' do
        #   before do
        #   fill_in 'post_comment[comment]', with: Faker::Lorem.characters(number: 20)
        #   end
        #   it '新しいコメントが投稿が正しく保存される' do
        #     expect do
        #       visit post_post_comments_path(post_id: 1), xhr: true
        #       end.to change(post.post_comments, :count).by(1)
        #     end
        #   it 'コメントが表示されている' do
        #     expect(page).to have_content post.post_comments
        #   end
        # end
      end
    end

    describe '自分の投稿編集画面のテスト' do
      before do
        visit edit_post_path(my_post)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + my_post.id.to_s + '/edit'
        end
        it 'body編集フォームが表示される' do
          expect(page).to have_field 'post[body]', with: my_post.body
        end
        it '更新ボタンが表示される' do
          expect(page).to have_button '更新'
        end
      end

      context '編集成功のテスト' do
        before do
          @post_old_body = my_post.body
          fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
          click_button '更新'
        end

        it 'bodyが正しく更新される' do
          expect(my_post.reload.body).not_to eq @post_old_body
        end
        it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
          expect(current_path).to eq '/posts/' + my_post.id.to_s
        end
      end
    end
  end

  describe 'ユーザー画面のテスト' do
    let!(:my_post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: other_user) }

    describe 'ユーザ一覧画面のテスト' do
      before do
        visit users_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users'
        end
        it '自分と他人の画像が表示される: fallbackの画像が2つ存在する' do
          expect(all('img').size).to eq(2)
        end
        it '自分と他人の名前がそれぞれ表示される' do
          expect(page).to have_content user.name
          expect(page).to have_content other_user.name
        end
        it '自分と他人のリンクがそれぞれ表示される' do
          expect(page).to have_link '', href: user_path(user)
          expect(page).to have_link '', href: user_path(other_user)
        end
      end
    end

    describe '自分のユーザ詳細画面のテスト' do
      before do
        visit user_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s
        end
        it '自分の名前が表示される' do
          expect(page).to have_content user.name
        end
        it '自分のプロフィールが表示される' do
          expect(page).to have_link '', href: user_path(user)
        end
        it 'followingのリンク先が表示される' do
          expect(page).to have_link '', href: user_followings_path(user)
        end
        it 'followerのリンク先が表示される' do
          expect(page).to have_link '', href: user_followers_path(user)
        end
        it 'bookmarkのリンク先が表示される' do
          expect(page).to have_link '', href: user_bookmarks_path(user)
        end
        it 'noticeのリンク先が表示される' do
          expect(page).to have_link '', href: notifications_path
        end
        it 'settingのリンク先が表示される' do
          expect(page).to have_link '', href: edit_user_path(user)
        end
        it '投稿一覧に自分の投稿が表示され、リンクが表示される' do
          expect(page).to have_content my_post.body
          expect(page).to have_link '', href: post_path(my_post)
        end
        it '他人の投稿は表示されない' do
          expect(page).not_to have_link '', href: post_path(other_post)
          expect(page).not_to have_content other_post.body
        end
      end

      context 'リンクのテスト' do
        it 'following画面に遷移する' do
          page.all(".mypage-nav-icon")[0].click
          expect(current_path).to eq '/users/' + user.id.to_s + '/followings'
        end
        it 'follower画面に遷移する' do
          page.all(".mypage-nav-icon")[1].click
          expect(current_path).to eq '/users/' + user.id.to_s + '/followers'
        end
        it 'bookmark画面に遷移する' do
          page.all(".mypage-nav-icon")[2].click
          expect(current_path).to eq '/users/' + user.id.to_s + '/bookmarks'
        end
        it 'notice画面に遷移する' do
          page.all(".mypage-nav-icon")[3].click
          expect(current_path).to eq '/notifications'
        end
        it 'setting画面に遷移する' do
          page.all(".mypage-nav-icon")[4].click
          expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
        end
      end
    end

    describe '自分のユーザ情報編集画面のテスト' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
        end
        it '名前編集フォームに自分の名前が表示される' do
          expect(page).to have_field 'user[name]', with: user.name
        end
        it '自己紹介編集フォームに自分の自己紹介文が表示される' do
          expect(page).to have_field 'user[profile]', with: user.profile
        end
        it 'プロフィール画像編集が表示される' do
          expect(page).to have_field 'user[profile_image]'
        end
        it 'ホーム画像編集フォームが表示される' do
          expect(page).to have_field 'user[home_image]'
        end
        it 'Update Userボタンが表示される' do
          expect(page).to have_button '更新'
        end
      end

      context '更新成功のテスト' do
        before do
          @user_old_name = user.name
          @user_old_profile = user.profile
          fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
          fill_in 'user[profile]', with: Faker::Lorem.characters(number: 19)
          click_button '更新'
        end

        it 'nameが正しく更新される' do
          expect(user.reload.name).not_to eq @user_old_name
        end
        it 'profileが正しく更新される' do
          expect(user.reload.profile).not_to eq @user_old_profile
        end
        it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end

    describe '他の人のユーザ情報画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '他の人の名前が表示される' do
          expect(page).to have_content other_user.name
        end
        it '他の人のプロフィールが表示される' do
          expect(page).to have_content other_user.profile
        end
        it 'followのリンク先が表示される' do
          expect(page).to have_link '', href: '/follow/' + other_user.id.to_s
        end
        it 'unfollowのリンク先が表示される' do
        end
        it '投稿一覧に他の人の投稿が表示され、リンクが表示される' do
          expect(page).to have_content other_post.body
          expect(page).to have_link '', href: post_path(other_post)
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_content my_post.body
          expect(page).not_to have_link '', href: post_path(my_post)
        end
      end
      # context 'フォローのテスト' do
      #   it 'フォローをする' do
      #     expect {
      #       post '/follow/'+ otheruser.id.to_s, xhr: true
      #     }.to change(user.follower, :count).by(1)
      #   end
      # end
    end
  end
end
