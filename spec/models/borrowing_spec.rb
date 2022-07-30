RSpec.describe 'Borrowing' do
    context 'new_for' do
        let(:user) { User.new(name: 'Any user') }
        let(:book) { Book.new(title: 'Any book') }
        let(:borrowing) { Borrowing.new_for user: user, book: book }
        
        before { allow(Time).to receive(:now).and_return("2020-10-22T20:20:10.000Z".to_datetime) }

        it 'should create new with give_back_at 7 days after' do
            expect(borrowing.give_back_at.iso8601).to eq('2020-10-29T20:20:10Z')
        end

        it 'should create new with borrowed_at with current date' do
            expect(borrowing.borrowed_at.iso8601).to eq('2020-10-22T20:20:10Z')
        end
    end
end