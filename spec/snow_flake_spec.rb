RSpec.describe SnowFlake do
  it 'has a version number' do
    expect(SnowFlake::VERSION).not_to be nil
  end

  it 'ID should be 18 digits' do
    expect(SnowFlake::ID.new(0, 0).next_id.to_s.size).to eq(18)
  end

  it 'ID increase should be true' do
    snow_flake = SnowFlake::ID.new(0, 0)
    first_id = snow_flake.next_id
    next_id = snow_flake.next_id
    expect(first_id).to be < next_id
  end
end
