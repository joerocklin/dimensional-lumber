# Dimensional Lumber Tools

This repo has some tools that I've pulled together to help do some design and planning for working with dimensional lumber. Currently, it consists of a library for OpenSCAD and a small tool to read the output from OpenSCAD rendering to generate board cut lists and what boards to buy.

## Usage

You can build the binary with `go build` or you can just run it with `go run board-calculations.go <openscad file>`. If your openscad binary is not in the path (as is the case on MacOS) you can specify the binary to use with the `-openscad-bin` flag.

Some [examples](./examples/) are provided.

## Why?

It's a good question. I like OpenSCAD and I found myself wanting to design various projects that used dimensional lumber. Once I had a simple design, the logical extension was to figure out what I needed to buy and what cuts I needed to make.

Maybe something else was already out there and I didn't find it, but this is my take on solving my need. The implementation is a simple brute-force approach and is probably not terribly elegant, but it works for my needs.

**Warning** This is solidly in the 'works for me' category. It probably doesn't work on very large projects, but let me know!

## Wishlist

- [ ] Updating board prices with config file
- [ ] Updating board prices with API calls
  - [ ] Comparing board prices at different stores would be neat
- [ ] Autogenerate some of the helper methods in the openscad library
  - [ ] Maybe find a better way to work with these
