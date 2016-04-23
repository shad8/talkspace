require 'rails_helper'

describe ApiVersion, type: :class do
  let(:api_version_v1) { ApiVersion.new(version: 1) }
  let(:api_version_v2) { ApiVersion.new(version: 2, default: true) }
  let(:host) { { host: 'api.example.com' } }
  let(:headers) do
    { headers: { 'Accept' => 'application/vnd.api.v1+json' } }
  end

  describe 'matches?' do
    it "returns true when the version matches the 'Accept' header" do
      request = double(host, headers)
      expect(api_version_v1.matches?(request)).to be_truthy
    end

    it "returns the default version when 'default' option is specified" do
      request = double(host)
      expect(api_version_v2.matches?(request)).to be_truthy
    end
  end
end
