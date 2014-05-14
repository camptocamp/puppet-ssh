require 'spec_helper'
require 'facter/util/public_sshport'

describe Facter::Util::PublicSshPort do

  describe Facter::Util::PublicSshPort.filepath do
    it 'should return fact file path' do
      Facter::Util::PublicSshPort.filepath.should == '/etc/facts/public_sshport'
    end
  end

  describe Facter::Util::PublicSshPort.get_fact do
    it 'should return nil if file does not exists' do
      File.expects(:exists?).returns(false)
      Facter::Util::PublicSshPort.get_fact.should == nil
    end

    it 'should return file content if it exists' do
      File.expects(:exists?).returns(true)
      File.expects(:read).returns('2222')
      Facter::Util::PublicSshPort.get_fact.should == '2222'
    end
  end

end
