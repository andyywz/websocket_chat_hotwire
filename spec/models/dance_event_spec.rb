# == Schema Information
#
# Table name: dance_events
#
#  id          :bigint           not null, primary key
#  city        :string
#  country     :string           not null
#  description :text
#  end_date    :date
#  name        :string           not null
#  start_date  :date
#  tags        :string           default([]), is an Array
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_dance_events_on_tags     (tags) USING gin
#  index_dance_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe DanceEvent do
  describe "scopes" do
    describe ".tagged_one_of" do
      it "returns all dance events that match at least one of the tags provided" do
        user = create(:user, :test)
        tags = ["balboa", "lindy hop", "slow dancing", "blues"]
        dance_events = tags.map do |tag|
          create(:dance_event, organizer: user, tags: [tag])
        end

        expect(described_class.tagged_one_of(["lindy hop", "blues"])).to eq(
          [dance_events.second, dance_events.last],
        )
      end

      it "returns all dance events if no tags are provided" do
        user = create(:user, :test)
        tags = ["balboa", "lindy hop", "slow dancing", "blues"]
        dance_events = tags.map do |tag|
          create(:dance_event, organizer: user, tags: [tag])
        end

        expect(described_class.tagged_one_of([])).to eq(dance_events)
      end

      it "returns an empty array if no dance events match at least one of the tags provided" do
        user = create(:user, :test)
        tags = ["balboa", "lindy hop", "slow dancing", "blues"]
        _dance_events = tags.map do |tag|
          create(:dance_event, organizer: user, tags: [tag])
        end

        expect(described_class.tagged_one_of(["another", "another 2"])).to eq([])
      end
    end

    describe ".tagged_all_of" do
      it "returns all dance events that match all the tags provided" do
        user = create(:user, :test)
        expected_result = create(:dance_event, organizer: user, tags: ["lindy hop", "balboa", "blues"])
        _other_event = create(:dance_event, organizer: user, tags: ["lindy hop"])
        _other_event_two = create(:dance_event, organizer: user, tags: ["balboa"])

        expect(described_class.tagged_all_of(["lindy hop", "balboa"])).to eq([expected_result])
      end

      it "returns all dance events if no tags are provided" do
        user = create(:user, :test)
        tags = ["balboa", "lindy hop", "slow dancing", "blues"]
        dance_events = tags.map do |tag|
          create(:dance_event, organizer: user, tags: [tag])
        end

        expect(described_class.tagged_all_of([])).to eq(dance_events)
      end

      it "returns an empty array if no dance events match the tags provided" do
        user = create(:user, :test)
        tags = ["balboa", "lindy hop", "slow dancing", "blues"]
        _dance_events = tags.map do |tag|
          create(:dance_event, organizer: user, tags: [tag])
        end

        expect(described_class.tagged_all_of(["another"])).to eq([])
      end
    end

    describe ".name_like" do
      it "returns all dance events with names that match the string provided" do
        user = create(:user, :test)
        expected_result = [
          create(:dance_event, organizer: user, name: "Balweek"),
          create(:dance_event, organizer: user, name: "BALLOVE"),
        ]
        _other_event = create(:dance_event, organizer: user, name: "Other")

        expect(described_class.name_like("bal")).to eq(expected_result)
      end

      it "returns all dance events if no string is provided" do
        user = create(:user, :test)
        dance_events = create_list(:dance_event, 3, organizer: user)

        expect(described_class.name_like([])).to eq(dance_events)
      end

      it "returns an empty array if no dance events has a name that matches the string provided" do
        user = create(:user, :test)

        create(:dance_event, organizer: user, name: "Balweek")
        create(:dance_event, organizer: user, name: "BALLOVE")

        expect(described_class.name_like("balboa")).to eq([])
      end
    end

    describe ".instructors_name_like" do
      it "returns all dance events with instructors that match the string provided" do
        user = create(:user, :test)
        mickey = create(:user, username: "mickey")

        expected_result = [
          create(:dance_event, organizer: user, instructors: [mickey]),
          create(:dance_event, organizer: user, instructors: [user, mickey]),
        ]
        _other_event = create(:dance_event, organizer: user, instructors: [user])

        expect(described_class.instructors_name_like("mick")).to eq(expected_result)
      end

      it "returns all dance events if no string is provided" do
        user = create(:user, :test)
        dance_events = create_list(:dance_event, 3, organizer: user)

        expect(described_class.instructors_name_like([])).to eq(dance_events)
      end

      it "returns an empty array if no dance events has an instructor whose name matches the string provided" do
        user = create(:user, :test)
        create(:user, username: "mickey")

        create(:dance_event, organizer: user, instructors: [])
        create(:dance_event, organizer: user, instructors: [user])

        expect(described_class.instructors_name_like("mickey")).to eq([])
      end
    end
  end
end
