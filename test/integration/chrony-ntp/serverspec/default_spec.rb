#
# Copyright (c) 2017 Make.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Migrate as platform helper
require 'spec_helper'
require 'platform_helper'

platform = get_platform_specific(host_inventory['platform'])

describe service(platform['service']) do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe file(platform['config_file']) do
  it { should contain('manual') }
  it { should contain('maxclockerror 5') }
  it { should contain('0.europe.pool.ntp.org') }
  it { should contain('1.europe.pool.ntp.org') }
  it { should_not contain('0.centos.pool.ntp.org iburst') }
  it { should_not contain('1.centos.pool.ntp.org iburst') }
  it { should_not contain('2.centos.pool.ntp.org iburst') }
  it { should_not contain('3.centos.pool.ntp.org iburst') }
end

describe command('/usr/bin/chronyc activity') do
  its(:stdout) { should contain('200 OK') }
  its(:stdout) { should contain('2 sources online') }
end