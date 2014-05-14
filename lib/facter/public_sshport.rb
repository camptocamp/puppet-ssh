require 'facter/util/public_sshport'

Facter.add(:public_sshport) do
  setcode { Facter::Util::PublicSshPort::get_fact }
end

