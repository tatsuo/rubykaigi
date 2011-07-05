# -*- coding: utf-8 -*-
require 'spec_helper'

describe Rubyist do
  describe 'ursm' do
    subject { Rubyist.make_unsaved(:username => 'ursm') }
    it { should be_valid }
    its(:to_param) { should == 'ursm' }
  end

  %w(new edit).each do |reserved|
    context "reserved name: #{reserved}" do
      subject { Rubyist.make_unsaved(:username => reserved).tap(&:valid?) }
      its(:errors) { should be_invalid(:username) }
    end
  end

  context 'two rubyists' do
    before do
       @ursm = Rubyist.make(:username => 'ursm', :twitter_user_id => 1234)
       @kakutani = Rubyist.make(:username => 'kakutani', :twitter_user_id => 3456)
    end

    it { Rubyist.should have(2).records }
    it { @ursm.should be_valid }
    it { @kakutani.should be_valid }
  end

  describe '#website' do
    context 'valid URI' do
      subject { Rubyist.make_unsaved(:website => 'http://ursm.jp').tap(&:valid?) }
      it { should be_valid }
    end

    context 'invalid URI' do
      subject { Rubyist.make_unsaved(:website => 'javascript:alert("hello!")').tap(&:valid?) }
      its(:errors) { should be_invalid(:website) }
    end
  end

  context 'username に空白文字を含んでいる' do
    subject { Rubyist.make_unsaved(:username => 'hoge fuga').tap(&:valid?) }
    its(:errors) { should be_invalid(:username) }
  end

  context '日本語のusername' do
    subject { Rubyist.make_unsaved(:username => 'まつもとゆきひろ').tap(&:valid?) }
    its(:errors) { should be_invalid(:username) }
  end

  context '大文字小文字を無視すると同一のユーザ名' do
    let!(:first)  { Rubyist.make(:username => 'hibariya') }
    let!(:second) { Rubyist.make_unsaved(:username => 'Hibariya') }

    it { second.should_not be_valid }
    it { second.tap(&:valid?).errors[:username].should_not be_blank }
  end

  describe "#gravatar_email" do
    context "when default" do
      subject { Rubyist.make(:username => 'kakutani', :email => 'kakutani@example.com') }
      its(:email) { should == "kakutani@example.com" }
      its(:gravatar_email) { should == "kakutani@example.com" }
    end

    context "個別にメールアドレスを設定した場合" do
      subject { Rubyist.make(:username => 'kakutani',
          :email => 'kakutani@example.com',
          :gravatar_email => 'shintaro@example.com') }

      its(:email) { should == "kakutani@example.com" }
      its(:gravatar_email) { should == "shintaro@example.com" }
    end

    context "gravaterに空文字を設定した場合" do
      subject { Rubyist.make(:username => 'kakutani',
          :email => 'kakutani@example.com',
          :gravatar_email => '') }
      its(:email) { should == "kakutani@example.com" }
      its(:gravatar_email) { should be_blank }
    end
  end

  describe "#gravatar_url" do
    context "設定されている" do
      subject { Rubyist.make(:username => 'kakutani',
          :email => 'kakutani@example.com',
          :gravatar_email => 'shintaro@example.com') }
      its(:gravatar_url) { should_not == "/images/bow_face.png" }
    end

    context "設定されていない" do
      subject { Rubyist.make(:username => 'kakutani',
          :email => 'kakutani@example.com',
          :gravatar_email => '') }
      its(:gravatar_url) { should == "/images/bow_face.png" }
    end

  end
end
