require 'spec_helper'
require 'facter/util/public_sshport'

describe 'public_sshport fact' do
  before :each do
    Facter.clear
  end

  context 'when all file exist and content is 2222' do
    it 'should return public_sshport 2222' do
      File.expects(:exists?).with('/etc/facts/public_sshport').returns(true)
      File.expects(:read).with('/etc/facts/public_sshport').returns('2222')
      Facter.value(:public_sshport).should == '2222'
    end
  end

  context 'when file /etc/facts/public_sshport does not exists' do
    it 'should return no value' do
      File.expects(:exists?).with('/etc/facts/public_sshport').returns(false)
      Facter.value(:public_sshport).should == nil
    end
  end

end

