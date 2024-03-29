# Broadbean
Communicate to Broadbean's AdCourier service in order to post and manage job adverts.

Check [Wiki](https://github.com/rvracaric/broadbean/wiki/Broadbean-gem) for more info.

## Installation

Add this line to your application's Gemfile:

    gem 'broadbean'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install broadbean

## Usage

    # initialization
    Broadbean.init(api_key, username, password)

    # Export
    exp = Broadbean.export(
        {
            job_id:          1234,
            job_title:       'Bus operator',
            job_description: 'Driving a bus',
            job_reference:   'transit job',
            channels:        [:monster, :workopolis]
        }
    )
    exp.configure(
        style_sheet:      'http://v4.adcourier.com/css/hybrid-neutral.css',
        display_menu:     false,
        force_step_one:   true,
        return_store_url: true
    )
    result = exp.execute

    if exp.failed?
        # result is a failure message
    else
        # result is an array with data
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
