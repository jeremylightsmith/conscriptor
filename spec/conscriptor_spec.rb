require 'spec_helper'

describe Conscriptor do
  include Conscriptor

  it 'should have version number' do
    expect(::Conscriptor::VERSION).not_to eq nil
  end
end
