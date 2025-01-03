# ddev-lucee

[![tests](https://github.com/ddev/ddev-lucee/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-lucee/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

## What is ddev-lucee?

This DDEV add-on provides integration with the Lucee CFML engine. It allows you to run CFML files directly in your webroot using Lucee 6.1 with Tomcat.

## External Documentation
- [Lucee Documentation](https://docs.lucee.org/)
- [Lucee Docker Images](https://hub.docker.com/r/lucee/lucee)
- [DDEV Documentation](https://ddev.readthedocs.io/)

## Installation

```bash
ddev add-on get davekopecek/ddev-lucee
ddev restart
```

## Configuration and Usage

The add-on provides:
- Lucee 6.1 with Tomcat
- Server Admin interface at `http://[project-name].ddev.site:8888/lucee/admin/server.cfm`
- Web Admin interface at `http://[project-name].ddev.site:8888/lucee/admin/web.cfm`
- Default admin password: `admin`

### Configuration Storage

Lucee configurations are stored in:
- `.ddev/lucee/server/` - Server-wide configurations
- `.ddev/lucee/web/` - Web context configurations

These directories are git-managed and will persist across project restarts. You can commit your Lucee configurations to version control to share them with your team.

## TODO
- HTTPS is not currently working. All Lucee URLs must be accessed using `http://` instead of `https://`. Because Tomcat. Suggestions?


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

Visit `http://[project-name].ddev.site:8888` to see it in action.

## Development

### Testing

To run the tests locally:

```bash
bats tests/test.bats
```

Tests will create a temporary DDEV project, install the add-on, verify it's working correctly, and clean up afterwards.

## Contributing

Feel free to submit issues and pull requests. All contributions are welcome!

## Maintainers

- [@davekopecek](https://github.com/davekopecek)
