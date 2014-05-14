module Facter::Util::PublicSshPort
  def self.filepath
    '/etc/facts/public_sshport'
  end

  def self.get_fact
    if File.exists?(filepath)
      File.read(filepath)
    end
  end
end
