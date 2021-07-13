require 'spec_helper'

module Conscriptor
  describe HierarchicalContextLogger do
    describe 'logging' do
      let(:logger) { HierarchicalContextLogger.new }

      it 'should allow you to push and pop context' do
        catch_stdout do
          logger.with_context('foo') do
            logger.with_context('bar') do
              logger.with_context('baz') do
                logger.info('Hello world')
              end

              logger.with_context('baz2') do
                # nothing expected to output
              end

              logger.info('Inside foo/bar')
            end
            logger.info('Inside foo')
          end

          expect($stdout.string).to eq <<~TEXT
            foo
               bar
                  baz
                     Hello world
                  Inside foo/bar
               Inside foo
          TEXT
        end
      end
    end
  end
end
