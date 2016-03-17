require 'spec_helper'

describe 'sshpubkey_to_x509' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('ssh-rsa', '1', 'extras').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

  describe 'when passing a key' do
    it { is_expected.to run.with_params('ssh-rsa', 'AAAAB3NzaC1yc2EAAAABIwAAAQEA3RC8whKGFx+b7BMTFtnIWl6t/qyvOvnuqIrMNI9J8+1sEYv8Y/pJRh0vAe2RaSKAgB2hyzXwSJ1Fh+ooraUAJ+q7P2gg2kQF1nCFeGVjtV9m4ZrV5kZARcQMhp0Bp67tPo2TCtnthPYZS/YQG6u/6Aco1XZjPvuKujAQMGSgqNskhKBO9zfhhkAMIcKVryjKYHDfqbDUCCSNzlwFLts3nJ0Hfno6Hz+XxuBIfKOGjHfbzFyUQ7smYnzF23jFs4XhvnjmIGQJcZT4kQAsRwQubyuyDuqmQXqa+2SuQfkKTaPOlVqyuEWJdG2weIF8g3YP12czsBgNppz3jsnhEgstnQ==').and_return("-----BEGIN RSA PUBLIC KEY-----\nMIIBCAKCAQEA3RC8whKGFx+b7BMTFtnIWl6t/qyvOvnuqIrMNI9J8+1sEYv8Y/pJ\nRh0vAe2RaSKAgB2hyzXwSJ1Fh+ooraUAJ+q7P2gg2kQF1nCFeGVjtV9m4ZrV5kZA\nRcQMhp0Bp67tPo2TCtnthPYZS/YQG6u/6Aco1XZjPvuKujAQMGSgqNskhKBO9zfh\nhkAMIcKVryjKYHDfqbDUCCSNzlwFLts3nJ0Hfno6Hz+XxuBIfKOGjHfbzFyUQ7sm\nYnzF23jFs4XhvnjmIGQJcZT4kQAsRwQubyuyDuqmQXqa+2SuQfkKTaPOlVqyuEWJ\ndG2weIF8g3YP12czsBgNppz3jsnhEgstnQIBIw==\n-----END RSA PUBLIC KEY-----\n") }
  end
end
