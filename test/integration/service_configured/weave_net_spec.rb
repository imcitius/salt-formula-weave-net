describe file('/usr/local/bin/weave') do
  it { should be_a_file }
  it { should be_executable }
end

describe service('weave') do
  it { should be_installed }
  it { should_not be_enabled }
  it { should_not be_running }
end

describe command('/usr/local/bin/weave version') do
  its(:stdout) { should match(/^weave script 2.5.0/) }
end

['/etc/default/weave', '/etc/sysconfig/weave'].each do |filename|
  if file(filename).exist?
    describe file(filename) do
      it { should be_a_file }
      its(:content) { should match(/WEAVE_PASSWORD='secret'/) }
      its(:content) { should match(/LOG_LEVEL='warning'/) }
    end
  end
end