# ddev-lucee

[![tests](https://github.com/ddev/ddev-lucee/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-lucee/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

## What is ddev-lucee?

This repository provides a Lucee CFML engine add-on for DDEV. It allows you to run CFML files directly in your webroot using Lucee 6.1 with Tomcat.

## External Documentation
- [Lucee Documentation](https://docs.lucee.org/)
- [Lucee Docker Images](https://hub.docker.com/r/lucee/lucee)
- [DDEV Documentation](https://ddev.readthedocs.io/)

## Installation

```bash
ddev add-on get ddev/ddev-lucee
ddev restart
```

## Configuration

The add-on provides:
- Lucee 6.1 with Tomcat
- Server Admin interface at `https://[project-name].ddev.site:8888/lucee/admin/server.cfm`
- Web Admin interface at `https://[project-name].ddev.site:8888/lucee/admin/web.cfm`
- Default admin password: `admin`
- CFML files can be placed in your project's web root

## Quick Start

Create a file named `index.cfm` in your project's webroot:

```cfml
<cfoutput>
<!DOCTYPE html>
<html>
<body>
    <h1>🚀 Woohoo! Your Lucee CFML Engine is Running!</h1>
    <p>The current date and time is: #dateTimeFormat(now(), "full")#</p>
    <p>Powered by Lucee #server.lucee.version#</p>
</body>
</html>
</cfoutput>
```

Visit `https://[project-name].ddev.site:8888` to see it in action.

## Local Development Testing

To test this add-on locally:

1. Clone this repository
2. In your DDEV project run:
```bash
ddev add-on get /path/to/ddev-lucee
```

## Contributing

Feel free to submit issues and pull requests.

**Contributed and maintained by [@davekopecek](https://github.com/davekopecek)**
