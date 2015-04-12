require 'spec_helper'

describe Restaurant, :type => :model do
  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: "Moe's")
    restaurant = Restaurant.new(name: "Moe's")
    expect(restaurant).to have(1).error_on(:name)
  end

  it { is_expected.to belong_to :user }

end