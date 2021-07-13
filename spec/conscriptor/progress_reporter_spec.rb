require 'spec_helper'
require 'timecop'

module Conscriptor
  describe ProgressReporter do
    let(:logger) { FakeLogger.new }

    it 'should report progress' do
      start = Time.now
      Timecop.freeze(start) do
        progress = ProgressReporter.new(total: 5, name: 'Explode', logger: logger)

        Timecop.travel(start + 5 * 60)
        progress.inc
        expect(progress.done?).to eq false

        Timecop.travel(start + 6 * 60)
        progress.inc

        Timecop.travel(start + 7 * 60)
        progress.inc

        Timecop.travel(start + 8 * 60)
        progress.inc

        Timecop.travel(start + 9 * 60)
        progress.inc
        expect(progress.done?).to eq true

        expect(logger.logs).to eq(
          info: [
            'Explode 1/5 (20%) 5.0m spent, 20.0m to go-ish',
            'Explode 2/5 (40%) 6.0m spent, 9.0m to go-ish',
            'Explode 3/5 (60%) 7.0m spent, 4.7m to go-ish',
            'Explode 4/5 (80%) 8.0m spent, 2.0m to go-ish',
            'Explode 5/5 (100%) 9.0m spent, 0.0m to go-ish'
          ]
        )
      end
    end
  end
end
