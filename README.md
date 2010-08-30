# gem-prune

Keep your local gem installation from growing wild.

## Installation

    $ gem install gem-prune
    
## Usage

    # keep the latest sinatra
    $ gem keep sinatra  

    # keep the latest rails and one from the 2.3 series
    $ gem keep rails
    $ gem keep rails -v "~> 2.3.0"

    # remove unwanted gems
    $ gem prune

## License

MIT License

## Copyright

Copyright (c) 2010 David Dollar. See LICENSE for details.
