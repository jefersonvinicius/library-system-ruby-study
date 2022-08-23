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
    context 'sort_model when is by side' do

        let(:model) { FakeModel.new id: 2, position: 1 }
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

    context 'sort_model to longer positions' do

        let(:model) { FakeModel.new id: 5, position: 4 }
        let(:models) {[
            FakeModel.new(id: 1, position: 0), 
            FakeModel.new(id: 2, position: 1), 
            FakeModel.new(id: 3, position: 2),
            FakeModel.new(id: 4, position: 3),
            FakeModel.new(id: 5, position: 4),
            FakeModel.new(id: 6, position: 5),
            FakeModel.new(id: 7, position: 6),
            FakeModel.new(id: 8, position: 7),
            FakeModel.new(id: 9, position: 8),
            FakeModel.new(id: 10, position: 9),
        ]}

        it 'should sorting to position ahead' do
            changed = Sorting.sort models: models, changing: model, to: 8

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 3, position: 2),
                FakeModel.new(id: 4, position: 3),
                FakeModel.new(id: 5, position: 8),
                FakeModel.new(id: 6, position: 4),
                FakeModel.new(id: 7, position: 5),
                FakeModel.new(id: 8, position: 6),
                FakeModel.new(id: 9, position: 7),
                FakeModel.new(id: 10, position: 9),
            ])
            expect(changed.map(&:id)).to eq([5,6,7,8,9])
        end 

        it 'should sorting to position back' do
            changed = Sorting.sort models: models, changing: model, to: 1

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 2), 
                FakeModel.new(id: 3, position: 3),
                FakeModel.new(id: 4, position: 4),
                FakeModel.new(id: 5, position: 1),
                FakeModel.new(id: 6, position: 5),
                FakeModel.new(id: 7, position: 6),
                FakeModel.new(id: 8, position: 7),
                FakeModel.new(id: 9, position: 8),
                FakeModel.new(id: 10, position: 9),
            ])
            expect(changed.map(&:id)).to eq([5,2,3,4])
        end 

        it 'should changes nothing when changes to own position' do

            changed = Sorting.sort models: models, changing: model, to: 4

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 3, position: 2),
                FakeModel.new(id: 4, position: 3),
                FakeModel.new(id: 5, position: 4),
                FakeModel.new(id: 6, position: 5),
                FakeModel.new(id: 7, position: 6),
                FakeModel.new(id: 8, position: 7),
                FakeModel.new(id: 9, position: 8),
                FakeModel.new(id: 10, position: 9),
            ])
            expect(changed.map(&:id)).to eq([])
        end
    end

    context 'with out of order models' do
        let(:model) { FakeModel.new id: 5 }
        let(:models) {[
            FakeModel.new(id: 1, position: 0), 
            FakeModel.new(id: 2, position: 1), 
            FakeModel.new(id: 4, position: 3),
            FakeModel.new(id: 5, position: 4),
            FakeModel.new(id: 10, position: 9),
            FakeModel.new(id: 7, position: 6),
            FakeModel.new(id: 6, position: 5),
            FakeModel.new(id: 8, position: 7),
            FakeModel.new(id: 3, position: 2),
            FakeModel.new(id: 9, position: 8)
        ]}

        it 'should sorting to position ahead' do
            changed = Sorting.sort models: models, changing: model, to: 8

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 4, position: 3),
                FakeModel.new(id: 5, position: 8),
                FakeModel.new(id: 10, position: 9),
                FakeModel.new(id: 7, position: 5),
                FakeModel.new(id: 6, position: 4),
                FakeModel.new(id: 8, position: 6),
                FakeModel.new(id: 3, position: 2),
                FakeModel.new(id: 9, position: 7),
            ])
            expect(changed.map(&:id)).to eq([5,6,7,8,9])
        end 

        it 'should sorting to position back' do
            changed = Sorting.sort models: models, changing: model, to: 1

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 2), 
                FakeModel.new(id: 4, position: 4),
                FakeModel.new(id: 5, position: 1),
                FakeModel.new(id: 10, position: 9),
                FakeModel.new(id: 7, position: 6),
                FakeModel.new(id: 6, position: 5),
                FakeModel.new(id: 8, position: 7),
                FakeModel.new(id: 3, position: 3),
                FakeModel.new(id: 9, position: 8),
            ])
            expect(changed.map(&:id)).to eq([5,2,3,4])
        end 

        it 'should changes nothing when changes to own position' do

            changed = Sorting.sort models: models, changing: model, to: 4

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 1), 
                FakeModel.new(id: 4, position: 3),
                FakeModel.new(id: 5, position: 4),
                FakeModel.new(id: 10, position: 9),
                FakeModel.new(id: 7, position: 6),
                FakeModel.new(id: 6, position: 5),
                FakeModel.new(id: 8, position: 7),
                FakeModel.new(id: 3, position: 2),
                FakeModel.new(id: 9, position: 8),
            ])
            expect(changed.map(&:id)).to eq([])
        end

    end

    context 'with null positions' do
        let(:model) { FakeModel.new id: 2 }
        let(:models) {[
            FakeModel.new(id: 1, position: 0), 
            FakeModel.new(id: 2, position: nil), 
            FakeModel.new(id: 3, position: 1),
            FakeModel.new(id: 4, position: nil),
            FakeModel.new(id: 5, position: 2)
        ]}

        it 'should sort the model with nil position to non-nil position' do
            changed = Sorting.sort models: models, changing: model, to: 2

            expect(models).to eq([
                FakeModel.new(id: 1, position: 0), 
                FakeModel.new(id: 2, position: 2), 
                FakeModel.new(id: 3, position: 1),
                FakeModel.new(id: 4, position: 4),
                FakeModel.new(id: 5, position: 3)
            ])
            expect(changed.map(&:id)).to eq([2,5])
        end
    end
end