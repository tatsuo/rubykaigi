require 'acceptance/acceptance_helper'

feature "既存のアカウントに他のプロバイダのアカウントを紐付ける" do
  include_context 'signout after all'

  # TODO 2つ目以降のscenarioでBlueprintがうまく動かない(No blueprint for class Authentication)
  let(:rubyist) { Rubyist.create!(:username => 'hibariya', :authentications => [Authentication.new(:provider => 'twitter', :uid => '12345')]) }

  let(:openid_hash) {
    {
      :provider  => 'open_id',
      :uid       => 'https://www.google.com/accounts/o8/id?i://www.google.com/accounts/o8/id?id=hibariya',
      :user_info => {:email => 'hibariya@gmail.com', :name => 'Hibariya Hi'}
    }
  }

  background do
    authentication = rubyist.authentications.first

    OmniAuth.config.mock_auth[authentication.provider.intern] = {
      :provider  => authentication.provider,
      :uid       => authentication.uid
    }

    OmniAuth.config.mock_auth[:open_id] = openid_hash

    visit '/auth/twitter'
    click_link I18n.t('account_settings')
  end

  scenario "紐付けられているアカウント一覧が表示されていること" do
    authentication = rubyist.authentications.first

    find('#authentications .provider').should have_content(authentication.provider.classify)
    find('#authentications .uid').should have_content(authentication.uid)
  end

  scenario "新たに別のアカウントを追加できること" do
    authentication = rubyist.authentications.first
    click_link 'via Google'

    find('#authentications .provider').should have_content('OpenId')
    find('#authentications .uid').should have_content(openid_hash[:uid])
  end
end

feature "紐づいているアカウント情報の削除" do
  include_context 'signout after all'

  let(:rubyist) {
    Rubyist.create!(
      :username        => 'hibariya',
      :authentications => [
        Authentication.new(:provider => 'twitter', :uid => '12345'),
        Authentication.new(:provider => 'open_id', :uid => 'https://www.google.com/accounts/o8/id?i://www.google.com/accounts/o8/id?id=hibariya')
      ]
    )
  }

  background do
    authentication = rubyist.authentications.first

    OmniAuth.config.mock_auth[authentication.provider.intern] = {
      :provider  => authentication.provider,
      :uid       => authentication.uid
    }

    visit '/auth/twitter'
    click_link I18n.t('account_settings')
  end

  scenario "紐づいているプロバイダのアカウント情報が削除できること" do
    authentication = rubyist.authentications.where(:provider => 'open_id').first

    provider_el = all('#authentications .provider').detect {|p| p.has_content?(authentication.provider.classify) }
    provider_el.find('a.remove').click

    find('#authentications .provider').should_not have_content(authentication.provider.classify)
    find('#authentications .uid').should_not have_content(authentication.uid)
  end

  scenario "紐づいているアカウントが1つしかない場合は削除することはできない" do
    find('#authentications .provider a.remove').click
    find('#authentications .provider').should_not have_content('解除')
  end
end

