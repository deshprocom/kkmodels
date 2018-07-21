class AppVersion < ApplicationRecord
  enum platform: { ios: 'ios', android: 'android' }
end
