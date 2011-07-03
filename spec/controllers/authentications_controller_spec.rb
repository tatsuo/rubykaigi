# coding: utf-8

require 'spec_helper'

describe AuthenticationsController do
  let(:rubyist) { Rubyist.make(:authentications => [Authentication.new(:provider => 'twitter', :uid => '12345')]) }

  describe 'delete' do
    context 'authenticationが1つしかないアカウントはauthenticationを削除できない' do
      before do
        delete :destroy, :id => rubyist.authentications.last
      end

      it { rubyist.should have(1).authentication }
    end
  end
end
