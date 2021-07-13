require 'spec_helper'
require 'colorize'

module Conscriptor
  describe EventCounter do
    let(:logger) { FakeLogger.new }
    let(:counts) { EventCounter.new(logger) }

    before do
      String.disable_colorization = true
    end

    before do
      String.disable_colorization = true
    end

    describe '#record' do
      it 'should record events' do
        counts.record(:one)
        counts.record(:two)
        counts.record(:three)
        counts.record(:two)
        counts.record(:three)
        counts.record(:three)
        counts.record_many(:four, 4)

        expect(counts[:one]).to eq 1
        expect(counts[:two]).to eq 2
        expect(counts[:three]).to eq 3
        expect(counts[:four]).to eq 4

        expect(counts.to_s)
          .to eq 'four = 4, one = 1, three = 3, two = 2'
      end
    end

    describe '#dump' do
      it 'should dump recorded values in desc order' do
        counts.record_many(:one, 1)
        counts.record_many(:two, 2)
        counts.record_many(:three, 3)
        counts.record_many(:four, 4)

        counts.dump

        expect(logger.logs[:info].join("\n")).to eq <<~TEXT.chomp

          four = 4
          three = 3
          two = 2
          one = 1
        TEXT
      end

      it 'should dump errors' do
        counts.record(:some_event)
        counts.record(:some_event)
        counts.record_error(:parsing_error, 'bad name')
        counts.record_error(:parsing_error, 'bad address')
        counts.record_error(:db_error, 'connection not found')

        counts.dump

        expect(logger.logs[:info].join("\n")).to eq <<~TEXT.chomp

          some_event = 2
          Error parsing_error (2):
          1\t bad name
          1\t bad address
          Error db_error (1):
          1\t connection not found
        TEXT
      end
    end

    describe '#record_and_print' do
      it 'should print a char and record the event' do
        catch_stdout do
          counts.record_and_print('√', :good)
          counts.record_and_print('√', :good)
          counts.record_and_print('x', :bad)
          counts.record_and_print('x', :bad)
          counts.record_and_print('?', :what)
          counts.record_and_print('x', :bad)
          counts.record_and_print('√', :good)

          expect($stdout.string).to eq '√√xx?x√'
        end

        expect(counts.to_h).to eq(
          good: 3,
          bad: 3,
          what: 1
        )
      end
    end
  end
end
