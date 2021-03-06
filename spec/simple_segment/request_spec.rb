require 'spec_helper'

describe SimpleSegment::Request do
  context 'API errors handling' do
    before(:example) {
      stub_request(:post, 'https://key:@api.segment.io/v1/track').
        to_return(status: 500, body: { error: 'Does not compute' }.to_json)
    }

    it 'does not raise an error with default config' do
      config = SimpleSegment::Configuration.new(write_key: 'key')
      expect {
        described_class.new('/v1/track', config).post({})
      }.not_to raise_error
    end

    it 'passes http errors to the on_error hook' do
      error_code, error_body, response, exception = nil, nil, nil, nil
      error_handler = proc { |code, body, res, e|
        error_code = code
        error_body = body
        response = res
        exception = e
      }
      config = SimpleSegment::Configuration.new(
        write_key: 'key',
        on_error: error_handler
      )
      described_class.new('/v1/track', config).post({})

      expect(error_code).to eq('500')
      expect(error_body).to eq({ error: 'Does not compute' }.to_json)
      expect(response).to be_a(Net::HTTPFatalError)
      expect(exception).to be_a(Net::HTTPInternalServerError)
    end
  end
end
