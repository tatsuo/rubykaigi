# coding: utf-8

shared_context 'signout after all' do
  after :all do
    click_link 'Sign out' rescue nil # XXX scenarioが上から順番に実行されるわけではないらしいので必要。rescue nilどうにかしたい
  end
end


