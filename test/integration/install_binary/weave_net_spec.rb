describe file('/usr/local/bin/weave') do
  it { should be_a_file }
  it { should be_executable }
end

describe systemd_service('weave') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe command('/usr/local/bin/weave version') do
  its(:stdout) { should match(/^weave script 2.5.1/) }
end

describe file("/etc/default/weave") do
  it { should_not be_a_file }
end
