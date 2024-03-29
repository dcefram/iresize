# iresize

**i-resize:** _conyo_ tagalog for the word resize. Actual tagalog word is "baguhin ang laki", but that word is too long for a cli command.

Use CLI to resize images. This is just a personal tool that I use for my blogs (converting super large images to smaller sizes that I can safely upload onto my blog). My blog is a static site, generated using [Hugo](https://gohugo.io/), and I created this tool before I thought of hosting my images in a cheap bucket on GCP.

## Requirements

Since I use [magickwand-crystal](https://github.com/blocknotes/magickwand-crystal), this tool inherits all the requirements of that shard.

- _libMagickWand_ must be installed
- _pkg-config_ must be available

## Installation

I use Linux at home, so that's the only platform that I would generate binaries for.

- Install the requirements first
- Download the binary from the [releases page](https://github.com/dcefram/iresize/releases)
- Add the binary to your path :)

## Usage

```bash
iresize -I ./ -O ./output -H 720 
iresize --input ./ --output ./output --height 720 --width 720
iresize --input ./ --output ./output --height 720 --watch
```

#### Options

|Flag|Short|Description|Default Value|
|-----------|-----------|-----------|-----------|
|`--input`|`-I`|Path to the folder filled with images, or Path to the target image (JPEG and PNG files are only supported as of now)|`./`|
|`--output`|`-O`|Path to the output folder|`./output`|
|`--height`|`-H`|Define the height we should resize the image(s) to.|720|
|`--width`|`-W`|Define the width we should resize the image(s) to.|Keep aspect ratio|
|`--watch`|<none>|Watch directory and auto convert files if new files are added|false|

## Contributing

1. Fork it (<https://github.com/dcefram/img-resize/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [dcefram](https://github.com/dcefram) Daniel Cefram Ramirez - creator, maintainer
