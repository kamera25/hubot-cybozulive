hubot-cybozulive
==============

A Hubot adapter for cybozulive.

## Installation

1. Install `hubot-cybozulive`.
  ```sh
npm install hubot-cybozulive --save
  ```

2. Set environment variables.
  ```sh
export HUBOT_CYBOZU_USERNAME=hoge@foober.com    # cybozulive account username for hubot
export HUBOT_CYBOZU_PASSWORD=qwert123           # cybozulive account password for hubot
export HUBOT_CYBOZU_KEY=abcdef123456789abcdef123456789abcdef123 # Consumer Key. see https://developer.cybozulive.com/apps/top
export HUBOT_CYBOZU_SECRET=123456789abcdef123456789abcdef123456789 # Consumer Secret. see https://developer.cybozulive.com/apps/top
  ```

3. Run hubot with cybozulive adapter.
  ```sh
bin/hubot -a cybozulive
  ```

## License
The MIT License. See `LICENSE` file.
