# dirwatch

[![Build Status](https://travis-ci.org/ThunderKey/dirwatch.svg?branch=master)](https://travis-ci.org/ThunderKey/dirwatch)
[![Code Climate](https://codeclimate.com/github/ThunderKey/dirwatch/badges/gpa.svg)](https://codeclimate.com/github/ThunderKey/dirwatch)
[![Test Coverage](https://codeclimate.com/github/ThunderKey/dirwatch/badges/coverage.svg)](https://codeclimate.com/github/ThunderKey/dirwatch/coverage)
[![Issue Count](https://codeclimate.com/github/ThunderKey/dirwatch/badges/issue_count.svg)](https://codeclimate.com/github/ThunderKey/dirwatch/issues)

A ruby gem to watch specific files and execute commands when any of the files change

## Installation

```bash
gem install dirwatch
```

## Usage

See:
```bash
dirwatch --help
dirwatch init --help
```

### Start a Watcher

`dirwatch [directory]` starts a service, which uses the `.dirwatch.yml` file in the specified directory or the current directory if not specified. 

### Initialize a Template

To create a template configuration use:
```bash
dirwatch init [template]
```
