ruby_version = Gem::Version.new(RUBY_VERSION)

if ruby_version < Gem::Version.new('2.7.0')
  ['4.0.0', '4.1.0', '4.2.0'].each do |rails_version|
    appraise "rails-#{rails_version}" do
      gem 'rails', "~> #{rails_version}"
      gem 'bigdecimal', '1.3.5'
      gem 'sqlite3', '~> 1.3.6'
    end
  end
end

if ruby_version < Gem::Version.new('3.0.0')
  appraise 'rails-5.0' do
    gem 'rails', '~> 5.0.0'
    gem 'sqlite3', '~> 1.3.6'
  end

  appraise 'rails-5.1' do
    gem 'rails', '~> 5.1.0'
  end

  appraise 'rails-5.2' do
    gem 'rails', '~> 5.2.0'
  end
end

if ruby_version >= Gem::Version.new('2.5.0')
  appraise 'rails-6.0' do
    gem 'rails', '~> 6.0.0'
  end

  appraise 'rails-6.1' do
    gem 'rails', '~> 6.1.0'
  end

  appraise 'rails-7.0' do
    gem 'rails', '~> 7.0.0'
  end

  appraise 'rails-7.1' do
    gem 'rails', '~> 7.1.0'
  end
end
