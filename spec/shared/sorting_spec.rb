require 'rails_helper'

class FakeModel
    attr_reader :id
    attr_accessor :position

    def initialize(id:, position: nil)
        @id = id
        @position = position
    end

    def ==(other)
        self.id == other.id &&
        self.position == other.position
    end
end

RSpec.describe 'Sorting' do
    context 'sort_model' do

        let(:model) { FakeModel.new id: 2 }
        let(:models) {[
            FakeModel.new(id: 1, position: 0), 
            FakeModel.new(id: 2, position: 1), 
            FakeModel.new(id: 3, position: 2)
        ]}

        it 'should sorting to position ahead' do
            Sorting.sort models: models, changing: model, to: 2

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0),
                FakeModel.new(id: 2, position: 2),
                FakeModel.new(id: 3, position: 1)
            ])
        end 

        it 'should sorting to position back' do
            Sorting.sort models: models, changing: model, to: 0

            expect(models).to eq([
                FakeModel.new(id: 1, position: 1),
                FakeModel.new(id: 2, position: 0),
                FakeModel.new(id: 3, position: 2)
            ])
        end 

        it 'should no change nothing when index does not exists (positive)' do
            Sorting.sort models: models, changing: model, to: 999

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 3, position: 2)
            ])
        end 

        it 'should no change nothing when index does not exists (negative)' do
            Sorting.sort models: models, changing: model, to: -1

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 3, position: 2)
            ])
        end 

        it 'should return changed models' do
            changed = Sorting.sort models: models, changing: model, to: 2

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0),
                FakeModel.new(id: 2, position: 2),
                FakeModel.new(id: 3, position: 1)
            ])
            expect(changed).to eq([
                FakeModel.new(id: 2, position: 2),
                FakeModel.new(id: 3, position: 1)
            ])
        end 
    end
end