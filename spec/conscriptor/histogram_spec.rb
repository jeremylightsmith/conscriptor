require 'spec_helper'

module Conscriptor
  describe Histogram do
    include Histogram

    describe 'histogram' do
      it 'should make a histgram' do
        expect(histogram(%i[foo bar bar bart bar] + [:bob] * 20)).to eq <<~TEXT.chomp
          20\t bob
          3\t bar
          1\t foo
          1\t bart
        TEXT
      end
    end
  end
end
